# Script d'extraction de produits compatibles SII

Ce script analyse le dump CSV complet d'Open Food Facts et extrait 100 produits réellement compatibles avec le syndrome de l'intestin irritable (low FODMAP).

## 📋 Prérequis

- Python 3.7 ou supérieur
- Accès au partage réseau `\\192.168.1.184\partage`
- Le fichier CSV d'Open Food Facts dans ce partage

## 🎯 Ce que fait le script

1. **Cherche le fichier CSV** dans le partage réseau
2. **Analyse ligne par ligne** le dump Open Food Facts
3. **Filtre les produits** selon des critères SII :
   - Sans lactose / Sans gluten / Low FODMAP
   - Pas d'ingrédients FODMAP élevés (oignon, ail, blé, etc.)
   - Disponibles en France
   - Avec une image disponible
4. **Extrait 100 produits** réels et compatibles
5. **Génère 3 fichiers** de sortie :
   - `produits_sii_compatible.json` (pour intégration)
   - `produits_sii_compatible.csv` (pour Excel)
   - `produits_sii_compatible.txt` (lisible)

## 🚀 Utilisation

```bash
python extract_fodmap_products.py
```

## 📊 Exemple de sortie

```
================================================================================
EXTRACTION DE PRODUITS COMPATIBLES SII DEPUIS OPEN FOOD FACTS
================================================================================
🔍 Recherche du fichier CSV dans \\192.168.1.184\partage...
✓ Fichier trouvé: openfoodfacts-products.csv (2450.3 MB)

📊 Analyse du fichier CSV...
🎯 Objectif: 100 produits compatibles SII

   Analysé: 2,450,000 lignes | Trouvés: 156 produits compatibles

✅ Objectif atteint! 100 produits trouvés

📈 Résumé:
   • Lignes analysées: 1,234,567
   • Produits compatibles: 156
   • Produits extraits: 100

💾 Sauvegarde des résultats...

   ✓ JSON: produits_sii_compatible.json
   ✓ CSV: produits_sii_compatible.csv
   ✓ TXT: produits_sii_compatible.txt

📊 Répartition par catégorie:
   • Yaourts: 15
   • Pains: 12
   • Fromages: 10
   • Laits: 10
   • Biscuits: 8
   • Pâtes: 7
   ...

================================================================================
✅ TERMINÉ!
================================================================================
```

## 🔧 Critères de filtrage

### Ingrédients interdits (FODMAPs élevés)
- Lactose, fructose, polyols (sorbitol, mannitol, xylitol)
- Inuline, chicorée
- Oignon, ail, poireau, échalote
- Blé, seigle, orge
- Pomme, poire, mangue, cerise, pastèque
- Champignons, chou-fleur, asperges

### Labels recherchés
- Sans lactose / Lactose-free
- Sans gluten / Gluten-free
- Low FODMAP
- Bio / Organic

### Catégories ciblées
- Yaourts, fromages, laits
- Pains, biscottes, biscuits
- Pâtes, riz, céréales
- Chocolats, sauces, jus
- Compotes, confitures

## 📁 Fichiers générés

### `produits_sii_compatible.json`
Format JSON prêt pour l'intégration dans `alternatives_service.dart` :

```json
[
  {
    "name": "Yaourt sans lactose nature",
    "brand": "Matin Léger",
    "barcode": "3033710074792",
    "category": "Yaourts",
    "benefits": ["Sans lactose"],
    "availability": "Carrefour",
    "image_url": "https://images.openfoodfacts.org/...",
    "ingredients": "Lait (avec lactase), ferments lactiques"
  }
]
```

### `produits_sii_compatible.csv`
Format CSV pour analyse dans Excel/Sheets

### `produits_sii_compatible.txt`
Format texte lisible avec toutes les infos

## ⚙️ Personnalisation

Tu peux modifier les critères dans le script :

```python
# Ligne 11-15 : Sortie
OUTPUT_JSON = "produits_sii_compatible.json"
OUTPUT_CSV = "produits_sii_compatible.csv"
OUTPUT_TXT = "produits_sii_compatible.txt"

# Ligne 18-24 : Ingrédients interdits
FORBIDDEN_INGREDIENTS = [
    'lactose', 'fructose', 'sorbitol', ...
]

# Ligne 26-36 : Catégories à cibler
GOOD_CATEGORIES = [
    'yaourts', 'fromages', 'laits', ...
]

# Ligne 38-42 : Labels à rechercher
GOOD_LABELS = [
    'sans lactose', 'sans gluten', ...
]
```

## 🐛 Dépannage

**Erreur "Le partage n'est pas accessible"**
- Vérifie que tu es sur le même réseau
- Vérifie les permissions d'accès au partage
- Essaie d'ouvrir `\\192.168.1.184\partage` dans l'explorateur Windows

**Aucun produit trouvé**
- Le fichier CSV est peut-être dans un format différent
- Ajuste les critères de filtrage (moins restrictifs)
- Vérifie que le CSV contient bien des produits français

**Script trop lent**
- Normal, le CSV fait plusieurs Go
- Le script affiche la progression toutes les 10000 lignes
- Peut prendre 5-15 minutes selon le fichier

## 💡 Après l'extraction

Une fois les 100 produits extraits :

1. **Vérifie** le fichier `produits_sii_compatible.json`
2. **Utilise** un autre script pour intégrer ces produits dans `alternatives_service.dart`
3. **Ou copie manuellement** les produits dans le service

## 📝 Notes

- Le script cherche automatiquement le CSV dans le partage
- Il privilégie les produits avec images et disponibles en France
- Les codes-barres sont RÉELS et vérifiés par Open Food Facts
- Les images existent vraiment sur Open Food Facts



