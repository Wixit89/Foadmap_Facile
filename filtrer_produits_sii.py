#!/usr/bin/env python3
"""
Script pour filtrer les produits compatibles SII
depuis Open Food Facts en comparant avec la whitelist des marques françaises
(Version simple et efficace, écriture en temps réel)
"""

import csv
import os
import sys

# Augmenter la limite des champs CSV (évite le crash sur fichiers volumineux)
csv.field_size_limit(10 * 1024 * 1024)  # 10 MB par champ

# Configuration
NETWORK_SHARE = r"\\192.168.1.184\partage"
WHITELIST_CSV = "marques_francaises_whitelist.csv"
OUTPUT_CSV = "produits_sii_compatibles.csv"

# ============================================================================
# CRITÈRES DE COMPATIBILITÉ SII
# ============================================================================

# Labels recherchés (au moins un)
GOOD_LABELS = [
    'sans lactose', 'sans gluten', 'sans-lactose', 'sans-gluten',
    'lactose-free', 'gluten-free', 'lactose free', 'gluten free',
    'low fodmap', 'low-fodmap',
    'sans sucre ajouté', 'sans sucre ajoute',
]

# Ingrédients INTERDITS (FODMAPs élevés)
FORBIDDEN_INGREDIENTS = [
    'lactose', 'fructose', 
    'sorbitol', 'mannitol', 'xylitol', 'maltitol',
    'inuline', 'chicorée', 'chicory',
    'topinambour', 'artichaut', 'artichoke',
    'oignon', 'onion', 'ail', 'garlic',
    'poireau', 'leek', 'échalote', 'shallot',
    'blé', 'wheat', 'seigle', 'rye', 'orge', 'barley',
    'pomme', 'apple', 'poire', 'pear',
    'mangue', 'mango', 'cerise', 'cherry',
    'pastèque', 'watermelon',
    'champignon', 'mushroom',
    'chou-fleur', 'cauliflower',
    'asperge', 'asparagus',
]

# Catégories pertinentes pour SII
SII_CATEGORIES = [
    'yaourt', 'yogurt', 'yoghurt',
    'fromage', 'cheese',
    'lait', 'milk', 'crème', 'cream',
    'pain', 'bread',
    'biscuit', 'cookie', 'gâteau', 'cake',
    'pâtes', 'pasta', 'pates',
    'riz', 'rice',
    'céréale', 'cereal', 'cereale',
    'chocolat', 'chocolate',
    'compote', 'compotes',
    'confiture', 'jam', 'confitures',
    'jus', 'juice', 'boisson', 'beverage',
]

# ============================================================================
# 2. FONCTIONS DE FILTRAGE
# ============================================================================

def is_french_brand(brands_str: str, whitelist: set) -> bool:
    """Vérifie si la marque du produit est dans la whitelist française"""
    if not brands_str:
        return False
    
    brands_lower = brands_str.lower().strip()
    
    # Vérifier si une des marques de la whitelist est présente
    for marque_wl in whitelist:
        if marque_wl in brands_lower:
            return True
    
    return False


def has_good_label(labels_str: str) -> bool:
    """Vérifie si le produit a un label compatible SII"""
    if not labels_str:
        return False
    
    labels_lower = labels_str.lower()
    
    for good_label in GOOD_LABELS:
        if good_label in labels_lower:
            return True
    
    return False


def has_forbidden_ingredient(ingredients_str: str) -> bool:
    """Vérifie si le produit contient un ingrédient interdit"""
    if not ingredients_str:
        return False  # Pas d'ingrédients = on ne peut pas vérifier
    
    ingredients_lower = ingredients_str.lower()
    
    for forbidden in FORBIDDEN_INGREDIENTS:
        if forbidden in ingredients_lower:
            return True
    
    return False


def is_sii_category(categories_str: str) -> bool:
    """Vérifie si le produit est dans une catégorie pertinente pour SII"""
    if not categories_str:
        return False
    
    categories_lower = categories_str.lower()
    
    for cat in SII_CATEGORIES:
        if cat in categories_lower:
            return True
    
    return False


def is_sii_compatible(row: dict, whitelist: set) -> tuple[bool, str]:
    """
    Vérifie si un produit est compatible SII ET de marque française
    
    Returns:
        (compatible, raison_rejet)
    """
    # 1. Vérifier marque française (PRIORITÉ)
    brands = row.get('brands', '')
    if not is_french_brand(brands, whitelist):
        return False, "Marque non française"
    
    # 2. Vérifier catégorie pertinente
    categories = row.get('categories', '')
    if not is_sii_category(categories):
        return False, "Catégorie non pertinente SII"
    
    # 3. Vérifier labels (doit avoir au moins un bon label)
    labels = row.get('labels', '') + ' ' + row.get('labels_tags', '')
    if not has_good_label(labels):
        return False, "Pas de label sans gluten/lactose"
    
    # 4. Vérifier ingrédients (ne doit pas avoir d'ingrédients interdits)
    ingredients = row.get('ingredients_text', '')
    if has_forbidden_ingredient(ingredients):
        return False, "Ingrédients interdits (FODMAPs)"
    
    # 5. Vérifier qu'il a un code-barres et un nom
    if not row.get('code') or not row.get('product_name'):
        return False, "Pas de code-barres ou nom"
    
    return True, "OK"


def main():
    """Fonction principale"""
    print("=" * 80)
    print("FILTRAGE PRODUITS COMPATIBLES SII + MARQUES FRANÇAISES")
    print("=" * 80)

    # ============================================================================
    # 1. CHARGER LA WHITELIST DES MARQUES FRANÇAISES
    # ============================================================================
    print(f"\n📋 Chargement de la whitelist des marques françaises...")
    
    whitelist_marques = set()
    
    try:
        with open(WHITELIST_CSV, 'r', encoding='utf-8') as f:
            reader = csv.DictReader(f)
            for row in reader:
                marque = row['marque'].lower().strip()
                whitelist_marques.add(marque)
        
        print(f"   ✓ {len(whitelist_marques)} marques chargées")
        print(f"   Exemples: {list(sorted(whitelist_marques))[:5]}")
    except Exception as e:
        print(f"   ❌ Erreur: {e}")
        exit(1)

    # ============================================================================
    # 2. TROUVER LE FICHIER OPEN FOOD FACTS
    # ============================================================================
    print(f"\n🔍 Recherche du fichier Open Food Facts sur {NETWORK_SHARE}...")
    
    openfoodfacts_file = None
    
    try:
        if not os.path.exists(NETWORK_SHARE):
            print(f"   ❌ Partage réseau inaccessible")
            exit(1)
        
        # Chercher le fichier products.csv
        files = os.listdir(NETWORK_SHARE)
        
        for filename in files:
            if 'product' in filename.lower() and filename.endswith('.csv'):
                openfoodfacts_file = os.path.join(NETWORK_SHARE, filename)
                size_mb = os.path.getsize(openfoodfacts_file) / (1024 * 1024)
                print(f"   ✓ Fichier trouvé: {filename}")
                print(f"   Taille: {size_mb:.1f} MB")
                break
        
        if not openfoodfacts_file:
            print(f"   ❌ Fichier products.csv non trouvé")
            exit(1)
            
    except Exception as e:
        print(f"   ❌ Erreur: {e}")
        exit(1)

    # ============================================================================
    # 3. FILTRAGE EN TEMPS RÉEL (ligne par ligne)
    # ============================================================================
    print(f"\n📊 Filtrage des produits...")
    print(f"   Critères:")
    print(f"   • Marques françaises uniquement")
    print(f"   • Catégories SII (yaourts, fromages, pains, etc.)")
    print(f"   • Labels: sans gluten, sans lactose, low FODMAP")
    print(f"   • Pas d'ingrédients FODMAPs élevés")
    print(f"\n   💾 Écriture en temps réel dans {OUTPUT_CSV}")
    print(f"   ⏳ Traitement en cours (5-10 minutes)...\n")

    total_lignes = 0
    produits_sauvegardes = 0
    rejets = {}

    try:
        # Ouvrir les 2 fichiers : lecture + écriture simultanée
        with open(openfoodfacts_file, 'r', encoding='utf-8', errors='ignore') as f_in, \
             open(OUTPUT_CSV, 'w', encoding='utf-8', newline='') as f_out:
            
            # Détecter le délimiteur
            sample = f_in.read(1024)
            f_in.seek(0)
            delimiter = '\t' if '\t' in sample else ','
            
            delimiter_name = 'TAB' if delimiter == '\t' else 'VIRGULE'
            print(f"   Délimiteur détecté: {delimiter_name}\n")
            
            reader = csv.DictReader(f_in, delimiter=delimiter)
            fieldnames = reader.fieldnames
            
            # Créer le writer pour écrire directement
            writer = csv.DictWriter(f_out, fieldnames=fieldnames)
            writer.writeheader()
            
            # Traiter ligne par ligne
            for row in reader:
                try:
                    total_lignes += 1
                    
                    # Afficher progression toutes les 10000 lignes
                    if total_lignes % 10000 == 0:
                        print(f"   Analysées: {total_lignes:,} | ✓ Compatibles: {produits_sauvegardes:,}", end='\r')
                    
                    # Vérifier compatibilité (marque française + SII)
                    compatible, raison = is_sii_compatible(row, whitelist_marques)
                    
                    if compatible:
                        # ÉCRITURE IMMÉDIATE dans le fichier
                        writer.writerow(row)
                        produits_sauvegardes += 1
                    else:
                        rejets[raison] = rejets.get(raison, 0) + 1
                
                except Exception as e:
                    # Ignorer les lignes problématiques
                    if total_lignes % 100000 == 0:
                        print(f"\n   ⚠️  Erreur ligne {total_lignes} (ignorée)", end='')
                    continue
            
            print(f"\n\n   ✓ Traitement terminé")
            print(f"   • Total lignes analysées: {total_lignes:,}")
            print(f"   • Produits compatibles: {produits_sauvegardes:,}")
            if total_lignes > 0:
                print(f"   • Taux de compatibilité: {produits_sauvegardes/total_lignes*100:.2f}%")

    except Exception as e:
        print(f"\n   ❌ Erreur fatale: {e}")
        import traceback
        traceback.print_exc()
        exit(1)

    # ============================================================================
    # 4. STATISTIQUES DES REJETS
    # ============================================================================
    print(f"\n📉 Raisons de rejet (top 10):")
    for raison, count in sorted(rejets.items(), key=lambda x: -x[1])[:10]:
        pourcentage = (count / total_lignes * 100) if total_lignes > 0 else 0
        print(f"   • {raison}: {count:,} produits ({pourcentage:.1f}%)")

    # ============================================================================
    # 5. VÉRIFICATION DU FICHIER GÉNÉRÉ
    # ============================================================================
    print(f"\n💾 Vérification du fichier généré...")

    if not produits_sauvegardes:
        print(f"   ⚠️  Aucun produit compatible trouvé")
        exit(0)

    try:
        size_mb = os.path.getsize(OUTPUT_CSV) / (1024 * 1024)
        print(f"   ✓ Fichier créé: {OUTPUT_CSV}")
        print(f"   ✓ {produits_sauvegardes:,} produits sauvegardés")
        print(f"   ✓ Taille fichier: {size_mb:.1f} MB")

    except Exception as e:
        print(f"   ❌ Erreur: {e}")
        exit(1)

    print("\n" + "=" * 80)
    print("✅ EXTRACTION TERMINÉE")
    print("=" * 80)
    print(f"\n📁 Fichier généré: {OUTPUT_CSV}")
    print(f"🏥 {produits_sauvegardes:,} produits compatibles SII trouvés")
    print(f"\n💡 Ce fichier contient uniquement:")
    print(f"   • Produits de marques françaises (whitelist)")
    print(f"   • Labels: sans gluten, sans lactose, low FODMAP")
    print(f"   • Pas d'ingrédients FODMAPs élevés")
    print(f"   • Catégories pertinentes SII (yaourts, fromages, pains, etc.)")
    print(f"\n🎯 Tu peux maintenant utiliser ce fichier pour:")
    print(f"   • Intégrer les produits dans l'application Flutter")
    print(f"   • Analyser les alternatives disponibles")
    print(f"   • Proposer des suggestions aux utilisateurs")


# ============================================================================
# POINT D'ENTRÉE (requis pour multiprocessing sur Windows)
# ============================================================================
if __name__ == '__main__':
    main()


