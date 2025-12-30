#!/usr/bin/env python3
"""
Script simple pour filtrer les produits Open Food Facts
par marques françaises de la whitelist
"""

import csv
import os
import sys
from typing import Set

# Augmenter la limite de taille des champs CSV (pour éviter les erreurs)
csv.field_size_limit(10 * 1024 * 1024)  # 10 MB au lieu de 128 KB

# Configuration
NETWORK_SHARE = r"\\192.168.1.184\partage"
WHITELIST_CSV = "marques_francaises_whitelist.csv"
OUTPUT_CSV = "produits_marques_francaises.csv"

print("=" * 80)
print("FILTRAGE PRODUITS PAR MARQUES FRANÇAISES")
print("=" * 80)

# ============================================================================
# 1. CHARGER LA WHITELIST
# ============================================================================
print(f"\n📋 Chargement whitelist depuis {WHITELIST_CSV}...")

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
print(f"\n🔍 Recherche du fichier Open Food Facts dans {NETWORK_SHARE}...")

openfoodfacts_file = None

try:
    if not os.path.exists(NETWORK_SHARE):
        print(f"   ❌ Partage inaccessible")
        exit(1)
    
    # Chercher le fichier
    files = os.listdir(NETWORK_SHARE)
    
    # Chercher spécifiquement le fichier products
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
# 3. FILTRER LES PRODUITS (avec sauvegarde directe pour éviter saturation mémoire)
# ============================================================================
print(f"\n📊 Filtrage des produits par marques...")
print(f"   Sauvegarde en temps réel dans {OUTPUT_CSV}")
print(f"   (Ceci peut prendre 5-10 minutes...)\n")

total_lignes = 0
produits_trouves = 0
marques_stats = {}

try:
    with open(openfoodfacts_file, 'r', encoding='utf-8', errors='ignore') as f_in, \
         open(OUTPUT_CSV, 'w', encoding='utf-8', newline='') as f_out:
        # Détecter le délimiteur
        sample = f_in.read(1024)
        f_in.seek(0)
        delimiter = '\t' if '\t' in sample else ','
        
        delimiter_name = 'TAB' if delimiter == '\t' else 'VIRGULE'
        print(f"   Délimiteur détecté: {delimiter_name}")
        
        reader = csv.DictReader(f_in, delimiter=delimiter)
        
        # Récupérer les noms de colonnes
        fieldnames = reader.fieldnames
        
        # Créer le writer pour écrire directement
        writer = csv.DictWriter(f_out, fieldnames=fieldnames)
        writer.writeheader()
        
        for row in reader:
            try:
                total_lignes += 1
                
                # Afficher la progression toutes les 10000 lignes
                if total_lignes % 10000 == 0:
                    pourcentage = (total_lignes / 3000000) * 100 if total_lignes < 3000000 else 100
                    print(f"   [{pourcentage:5.1f}%] Lignes: {total_lignes:,} | Trouvés: {produits_trouves:,}", end='\r')
                
                # Vérifier si la marque est dans la whitelist
                brands = row.get('brands', '').lower().strip()
                
                if brands:
                    # Vérifier si une des marques de la whitelist est présente
                    for marque_wl in whitelist_marques:
                        if marque_wl in brands:
                            produits_trouves += 1
                            writer.writerow(row)  # Écriture directe !
                            
                            # Stats par marque
                            marque_principale = brands.split(',')[0].strip()
                            marques_stats[marque_principale] = marques_stats.get(marque_principale, 0) + 1
                            break  # Une seule correspondance suffit
            
            except Exception as e:
                # Ignorer les lignes problématiques et continuer
                if total_lignes % 100000 == 0:
                    print(f"\n   ⚠️  Erreur ligne {total_lignes} (ignorée)", end='')
                continue
        
        print(f"\n\n   ✓ Analyse terminée")
        print(f"   • Total lignes: {total_lignes:,}")
        print(f"   • Produits français trouvés: {produits_trouves:,}")

except Exception as e:
    print(f"\n   ❌ Erreur fatale: {e}")
    import traceback
    traceback.print_exc()
    exit(1)

# ============================================================================
# 4. VÉRIFIER LES RÉSULTATS
# ============================================================================
print(f"\n\n💾 Vérification du fichier généré...")

if not produits_trouves:
    print(f"   ⚠️  Aucun produit trouvé")
    exit(0)

try:
    size_mb = os.path.getsize(OUTPUT_CSV) / (1024 * 1024)
    print(f"   ✓ {produits_trouves:,} produits sauvegardés")
    print(f"   Taille fichier: {size_mb:.1f} MB")
    
except Exception as e:
    print(f"   ❌ Erreur: {e}")
    exit(1)

# ============================================================================
# 5. STATISTIQUES PAR MARQUE
# ============================================================================
print(f"\n📊 Top 20 des marques:")

# Afficher top 20
for i, (marque, count) in enumerate(sorted(marques_stats.items(), key=lambda x: -x[1])[:20], 1):
    print(f"   {i:2d}. {marque[:40]:40s} : {count:6,} produits")

print("\n" + "=" * 80)
print("✅ TERMINÉ")
print("=" * 80)
print(f"\n📁 Fichier généré: {OUTPUT_CSV}")
print(f"🇫🇷 {produits_trouves:,} produits de marques françaises")
print(f"\n💡 Tu peux maintenant utiliser ce fichier pour:")
print(f"   • Analyser les produits disponibles par marque")
print(f"   • Filtrer ensuite par catégories SII")
print(f"   • Extraire les produits compatibles")

