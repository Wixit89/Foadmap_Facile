#!/usr/bin/env python3
"""
Script pour récupérer les URLs d'images depuis Open Food Facts
et mettre à jour le fichier alternatives_service.dart
"""

import requests
import re
import time
from typing import Optional, Dict, List

# Configuration
OPENFOODFACTS_API = "https://world.openfoodfacts.org/api/v0/product/{}.json"
ALTERNATIVES_SERVICE_FILE = "lib/services/alternatives_service.dart"


def get_product_image_url(barcode: str) -> Optional[str]:
    """
    Récupère l'URL de l'image d'un produit depuis Open Food Facts
    
    Args:
        barcode: Code-barres du produit
        
    Returns:
        URL de l'image ou None si non trouvée
    """
    try:
        url = OPENFOODFACTS_API.format(barcode)
        print(f"  Requête API pour {barcode}...", end=" ")
        
        response = requests.get(url, timeout=10)
        response.raise_for_status()
        
        data = response.json()
        
        if data.get('status') == 1 and 'product' in data:
            product = data['product']
            
            # Essayer différents champs d'image par ordre de préférence
            image_url = (
                product.get('image_front_url') or
                product.get('image_front_small_url') or
                product.get('image_url') or
                product.get('image_small_url')
            )
            
            if image_url:
                print(f"✓ Image trouvée")
                return image_url
            else:
                print(f"✗ Pas d'image")
                return None
        else:
            print(f"✗ Produit non trouvé")
            return None
            
    except requests.exceptions.RequestException as e:
        print(f"✗ Erreur: {e}")
        return None
    except Exception as e:
        print(f"✗ Erreur inattendue: {e}")
        return None


def extract_products_from_dart(file_path: str) -> List[Dict[str, str]]:
    """
    Extrait les produits (id, barcode) du fichier Dart
    
    Args:
        file_path: Chemin du fichier alternatives_service.dart
        
    Returns:
        Liste de dictionnaires {id, barcode}
    """
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    products = []
    
    # Pattern pour extraire les AlternativeProduct
    pattern = r'AlternativeProduct\s*\(\s*id:\s*(\d+),.*?barcode:\s*[\'"]([^\'"]+)[\'"].*?\)'
    
    matches = re.finditer(pattern, content, re.DOTALL)
    
    for match in matches:
        product_id = match.group(1)
        barcode = match.group(2)
        products.append({
            'id': product_id,
            'barcode': barcode
        })
    
    return products


def update_dart_file_with_images(file_path: str, image_mapping: Dict[str, str]):
    """
    Met à jour le fichier Dart avec les URLs d'images
    
    Args:
        file_path: Chemin du fichier alternatives_service.dart
        image_mapping: Dictionnaire {barcode: image_url}
    """
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Pour chaque produit, ajouter le champ imageUrl
    def replace_product(match):
        full_product = match.group(0)
        barcode = match.group(1)
        
        # Vérifier si imageUrl existe déjà
        if 'imageUrl:' in full_product:
            # Remplacer l'imageUrl existant
            if barcode in image_mapping and image_mapping[barcode]:
                # Remplacer l'imageUrl existant par le nouveau
                new_product = re.sub(
                    r"imageUrl:\s*(?:'[^']*'|\"[^\"]*\"|null),?",
                    f"imageUrl: '{image_mapping[barcode]}',",
                    full_product
                )
                return new_product
            return full_product
        else:
            # Ajouter imageUrl avant emoji
            if barcode in image_mapping and image_mapping[barcode]:
                new_product = full_product.replace(
                    f"emoji: ",
                    f"imageUrl: '{image_mapping[barcode]}',\n      emoji: "
                )
                return new_product
            return full_product
    
    # Pattern pour chaque AlternativeProduct
    pattern = r'AlternativeProduct\s*\(\s*id:.*?barcode:\s*[\'"]([^\'"]+)[\'"].*?\),\s*(?=AlternativeProduct|$)'
    
    updated_content = re.sub(pattern, replace_product, content, flags=re.DOTALL)
    
    # Sauvegarder
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(updated_content)
    
    print(f"\n✅ Fichier {file_path} mis à jour !")


def main():
    """Fonction principale"""
    print("=" * 60)
    print("Script de mise à jour des images des produits alternatifs")
    print("=" * 60)
    
    # Test avec un barcode précis
    print("\n1️⃣  TEST avec le yaourt Pâturages (3250392486341)")
    print("-" * 60)
    test_barcode = "3250392486341"
    test_url = get_product_image_url(test_barcode)
    if test_url:
        print(f"   URL trouvée: {test_url[:80]}...")
    
    # Extraction des produits
    print(f"\n2️⃣  EXTRACTION des produits depuis {ALTERNATIVES_SERVICE_FILE}")
    print("-" * 60)
    products = extract_products_from_dart(ALTERNATIVES_SERVICE_FILE)
    print(f"   ✓ {len(products)} produits extraits")
    
    # Récupération des images
    print(f"\n3️⃣  RÉCUPÉRATION des images pour les {len(products)} produits")
    print("-" * 60)
    
    image_mapping = {}
    success_count = 0
    
    for i, product in enumerate(products, 1):
        barcode = product['barcode']
        product_id = product['id']
        
        print(f"[{i:3d}/{len(products)}] Produit #{product_id} (barcode: {barcode})")
        
        image_url = get_product_image_url(barcode)
        
        if image_url:
            image_mapping[barcode] = image_url
            success_count += 1
        
        # Pause pour ne pas surcharger l'API
        if i < len(products):
            time.sleep(0.5)  # 500ms entre chaque requête
    
    # Résumé
    print("\n" + "=" * 60)
    print(f"RÉSUMÉ:")
    print(f"  • Total produits: {len(products)}")
    print(f"  • Images trouvées: {success_count}")
    print(f"  • Images manquantes: {len(products) - success_count}")
    print("=" * 60)
    
    # Mise à jour du fichier
    if success_count > 0:
        print(f"\n4️⃣  MISE À JOUR du fichier {ALTERNATIVES_SERVICE_FILE}")
        print("-" * 60)
        
        response = input(f"   Voulez-vous mettre à jour le fichier avec {success_count} images ? (o/n): ")
        
        if response.lower() in ['o', 'oui', 'y', 'yes']:
            update_dart_file_with_images(ALTERNATIVES_SERVICE_FILE, image_mapping)
            print("\n✅ Mise à jour terminée avec succès!")
            print("   👉 Lance un hot restart dans Flutter pour voir les images")
        else:
            print("\n❌ Mise à jour annulée")
    else:
        print("\n⚠️  Aucune image trouvée, fichier non modifié")


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\n\n⚠️  Script interrompu par l'utilisateur")
    except Exception as e:
        print(f"\n❌ Erreur fatale: {e}")
        import traceback
        traceback.print_exc()



