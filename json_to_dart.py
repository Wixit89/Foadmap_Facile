#!/usr/bin/env python3
"""
Script pour convertir le JSON des produits en code Dart
pour alternatives_service.dart
"""

import json
import sys

INPUT_JSON = "produits_sii_compatible.json"
OUTPUT_DART = "alternatives_products_generated.dart"

# Mapping emoji par catégorie
EMOJI_MAP = {
    'Yaourts': '🥛',
    'Fromages': '🧀',
    'Laits': '🥛',
    'Pains': '🍞',
    'Biscuits': '🍪',
    'Pâtes': '🍝',
    'Féculents': '🍚',
    'Chocolats': '🍫',
    'Sauces': '🥫',
    'Boissons': '🍊',
    'Compotes': '🍎',
    'Confitures': '🍓',
    'Céréales': '🥣',
    'Snacks': '🥔',
    'Huiles': '🫒',
    'Autres': '🛒',
}


def escape_dart_string(text: str) -> str:
    """Échappe les caractères spéciaux pour Dart"""
    return text.replace("'", "\\'").replace('\n', ' ').replace('\r', '')


def generate_dart_code(products: list) -> str:
    """
    Génère le code Dart pour la liste de produits
    
    Args:
        products: Liste des produits
        
    Returns:
        Code Dart
    """
    dart_code = []
    
    dart_code.append("// ⚠️  FICHIER GÉNÉRÉ AUTOMATIQUEMENT - NE PAS MODIFIER DIRECTEMENT")
    dart_code.append("// Utilise extract_fodmap_products.py et json_to_dart.py pour régénérer")
    dart_code.append("")
    dart_code.append("static final List<AlternativeProduct> products = [")
    dart_code.append("")
    
    for i, product in enumerate(products, 1):
        name = escape_dart_string(product.get('name', 'Sans nom'))
        brand = escape_dart_string(product.get('brand', 'Sans marque'))
        barcode = product.get('barcode', '')
        category = product.get('category', 'Autres')
        benefits = product.get('benefits', [])
        availability = escape_dart_string(product.get('availability', 'Supermarchés'))
        image_url = product.get('image_url', '')
        emoji = EMOJI_MAP.get(category, '🛒')
        
        # Commenter les sections
        if i == 1 or (i > 1 and products[i-2].get('category') != category):
            dart_code.append(f"    // ==================== {category.upper()} ====================")
        
        dart_code.append("    AlternativeProduct(")
        dart_code.append(f"      id: {i},")
        dart_code.append(f"      name: '{name}',")
        dart_code.append(f"      brand: '{brand}',")
        dart_code.append(f"      category: '{category}',")
        dart_code.append(f"      barcode: '{barcode}',")
        dart_code.append(f"      availability: '{availability}',")
        
        # Benefits
        benefits_str = ", ".join([f"'{escape_dart_string(b)}'" for b in benefits])
        dart_code.append(f"      benefits: [{benefits_str}],")
        
        dart_code.append(f"      emoji: '{emoji}',")
        
        if image_url:
            dart_code.append(f"      imageUrl: '{image_url}',")
        
        dart_code.append("    ),")
        dart_code.append("")
    
    dart_code.append("  ];")
    
    return "\n".join(dart_code)


def main():
    """Fonction principale"""
    print("=" * 80)
    print("CONVERSION JSON → DART")
    print("=" * 80)
    
    # Charger le JSON
    print(f"\n📂 Lecture de {INPUT_JSON}...")
    try:
        with open(INPUT_JSON, 'r', encoding='utf-8') as f:
            products = json.load(f)
        print(f"   ✓ {len(products)} produits chargés")
    except FileNotFoundError:
        print(f"   ❌ Fichier {INPUT_JSON} non trouvé")
        print(f"   Lance d'abord extract_fodmap_products.py")
        return
    except json.JSONDecodeError as e:
        print(f"   ❌ Erreur de parsing JSON: {e}")
        return
    
    # Générer le code Dart
    print(f"\n⚙️  Génération du code Dart...")
    dart_code = generate_dart_code(products)
    
    # Sauvegarder
    print(f"\n💾 Sauvegarde dans {OUTPUT_DART}...")
    with open(OUTPUT_DART, 'w', encoding='utf-8') as f:
        f.write(dart_code)
    
    print(f"   ✓ Code Dart généré ({len(dart_code)} caractères)")
    
    # Stats
    categories = {}
    for p in products:
        cat = p.get('category', 'Autres')
        categories[cat] = categories.get(cat, 0) + 1
    
    print(f"\n📊 Répartition par catégorie:")
    for cat, count in sorted(categories.items(), key=lambda x: -x[1]):
        emoji = EMOJI_MAP.get(cat, '🛒')
        print(f"   {emoji} {cat}: {count}")
    
    print("\n" + "=" * 80)
    print("✅ TERMINÉ!")
    print("=" * 80)
    print(f"\n💡 Prochaines étapes:")
    print(f"   1. Ouvre {OUTPUT_DART}")
    print(f"   2. Copie le contenu dans lib/services/alternatives_service.dart")
    print(f"   3. Remplace la liste 'products' existante")
    print(f"   4. Fais un hot restart dans Flutter")


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\n\n⚠️  Script interrompu")
    except Exception as e:
        print(f"\n❌ Erreur: {e}")
        import traceback
        traceback.print_exc()



