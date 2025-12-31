# Script de mise à jour des images des produits alternatifs

Ce script Python récupère automatiquement les vraies images des produits depuis l'API Open Food Facts et met à jour le fichier `alternatives_service.dart`.

## 📋 Prérequis

- Python 3.7 ou supérieur
- Module `requests`

## 🚀 Installation

1. Installe les dépendances Python :

```bash
pip install -r requirements.txt
```

Ou directement :

```bash
pip install requests
```

## 💻 Utilisation

1. Lance le script depuis le dossier racine du projet :

```bash
python update_product_images.py
```

2. Le script va :
   - Tester l'API avec un barcode de test
   - Extraire les 100 produits depuis `alternatives_service.dart`
   - Faire une requête API pour chaque barcode
   - Récupérer les URLs des images
   - Afficher un résumé des images trouvées

3. Le script te demandera confirmation avant de modifier le fichier

4. Après la mise à jour, fais un **hot restart** (R majuscule) dans Flutter

## 📊 Exemple de sortie

```
============================================================
Script de mise à jour des images des produits alternatifs
============================================================

1️⃣  TEST avec le yaourt Pâturages (3250392486341)
------------------------------------------------------------
  Requête API pour 3250392486341... ✓ Image trouvée
   URL trouvée: https://images.openfoodfacts.org/images/products/325/039/248/6341/front...

2️⃣  EXTRACTION des produits depuis lib/services/alternatives_service.dart
------------------------------------------------------------
   ✓ 100 produits extraits

3️⃣  RÉCUPÉRATION des images pour les 100 produits
------------------------------------------------------------
[  1/100] Produit #1 (barcode: 3033710074792)
  Requête API pour 3033710074792... ✓ Image trouvée
[  2/100] Produit #2 (barcode: 3250392486341)
  Requête API pour 3250392486341... ✓ Image trouvée
...

============================================================
RÉSUMÉ:
  • Total produits: 100
  • Images trouvées: 87
  • Images manquantes: 13
============================================================

4️⃣  MISE À JOUR du fichier lib/services/alternatives_service.dart
------------------------------------------------------------
   Voulez-vous mettre à jour le fichier avec 87 images ? (o/n): o

✅ Fichier lib/services/alternatives_service.dart mis à jour !
✅ Mise à jour terminée avec succès!
   👉 Lance un hot restart dans Flutter pour voir les images
```

## 🔧 Modification manuelle

Tu peux aussi modifier manuellement les produits dans `lib/services/alternatives_service.dart` :

```dart
AlternativeProduct(
  id: 1,
  name: 'Yaourt sans lactose nature',
  brand: 'Matin Léger',
  category: 'Yaourts',
  barcode: '3033710074792',
  availability: 'Tous supermarchés',
  benefits: ['Sans lactose', '0% lactose'],
  emoji: '🥛',
  imageUrl: 'https://images.openfoodfacts.org/images/products/...',  // Ajoute cette ligne
),
```

## ⚠️ Notes

- Le script fait une pause de 500ms entre chaque requête pour ne pas surcharger l'API Open Food Facts
- Si un produit n'a pas d'image sur Open Food Facts, l'emoji sera affiché à la place
- Le script préserve la structure du fichier Dart

## 🐛 Dépannage

**Erreur de timeout :**
- Vérifie ta connexion internet
- Augmente le timeout dans le script (ligne `response = requests.get(url, timeout=10)`)

**Produits sans images :**
- Certains produits ne sont pas encore photographiés sur Open Food Facts
- Tu peux contribuer en ajoutant des photos sur openfoodfacts.org

**Fichier non modifié :**
- Vérifie que tu lances le script depuis le dossier racine du projet
- Vérifie les permissions d'écriture sur `lib/services/alternatives_service.dart`



