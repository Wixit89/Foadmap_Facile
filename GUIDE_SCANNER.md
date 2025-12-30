# Guide du Scanner de Code-Barres

## 🎯 Fonctionnalités

Le scanner de code-barres permet de :
- Scanner uniquement des codes-barres (EAN-8, EAN-13, UPC-A, UPC-E)
- Interroger l'API OpenFoodFacts automatiquement
- Afficher les informations complètes du produit

## 🚀 Comment tester

### Méthode 1 : Test automatique avec Nutella ✨

1. Lancez l'application : `flutter run`
2. Allez sur l'onglet "Scanner" (premier onglet)
3. Cliquez sur le bouton **"Test avec Nutella"** (bouton marron)
4. L'application va automatiquement :
   - Utiliser le code-barres : `3017620422003`
   - Interroger OpenFoodFacts
   - Afficher les informations du Nutella

### Méthode 2 : Scanner avec la caméra 📷

1. Lancez l'application
2. Onglet "Scanner"
3. Cliquez sur **"Démarrer le scan"**
4. Autorisez l'accès à la caméra si demandé
5. **Option A** : Scanner un vrai produit
   - Pointez la caméra vers un code-barres d'un produit alimentaire
   
6. **Option B** : Utiliser l'image de test
   - Cliquez sur l'icône 📷 en haut à droite de l'écran
   - Une popup s'ouvre avec l'image `code-barre.png`
   - Affichez cette image sur un autre écran/téléphone
   - Scannez-la avec la caméra de votre appareil

### Méthode 3 : Afficher le code-barre sur un autre écran

1. Ouvrez le fichier `code-barre.png` sur votre ordinateur
2. Affichez-le en plein écran
3. Lancez l'app sur votre téléphone/émulateur
4. Scannez le code-barre affiché à l'écran

## 📊 Informations affichées

Après le scan, vous verrez :

### Informations générales
- ✅ **Nom du produit**
- ✅ **Marque**
- ✅ **Quantité**
- ✅ **Image du produit** (photo frontale)
- ✅ **Nutri-Score** (A, B, C, D, E) avec code couleur

### Détails
- ✅ **Catégories**
- ✅ **Ingrédients** (texte complet)
- ✅ **Allergènes**
- ✅ **Labels** (Bio, Sans gluten, etc.)
- ✅ **Magasins** où le produit est disponible

### Informations nutritionnelles (pour 100g/100ml)
- ✅ Énergie (kcal)
- ✅ Matières grasses
- ✅ Acides gras saturés
- ✅ Glucides
- ✅ Sucres
- ✅ Fibres
- ✅ Protéines
- ✅ Sel

## 🔧 Architecture technique

### Service OpenFoodFacts
📁 `lib/services/openfoodfacts_service.dart`

**Méthodes principales :**
```dart
// Récupère les données brutes de l'API
Future<Map<String, dynamic>?> getProductInfo(String barcode)

// Extrait les informations utiles
Map<String, dynamic> extractProductData(Map<String, dynamic> data)
```

**URL de l'API :**
```
https://world.openfoodfacts.org/api/v0/product/{barcode}.json
```

### Scanner Screen
📁 `lib/screens/scanner_screen.dart`

**Fonctionnalités :**
- Configuration du scanner pour codes-barres uniquement
- Détection automatique et appel API
- Affichage des résultats formatés
- Gestion des erreurs

## 📝 Codes-barres de test

Voici quelques codes-barres pour tester :

| Produit | Code-barres | Description |
|---------|-------------|-------------|
| **Nutella** | `3017620422003` | Pâte à tartiner |
| Coca-Cola | `5449000000996` | Boisson gazeuse |
| Kinder Bueno | `8000500037447` | Barre chocolatée |
| Danette Chocolat | `3033490002053` | Dessert lacté |
| Lu Petit Beurre | `3017760000093` | Biscuits |

Vous pouvez entrer ces codes manuellement en modifiant la fonction `_testWithNutellaBarcode()`.

## 🐛 Dépannage

### Le produit n'est pas trouvé
- Vérifiez que le code-barres est correct
- Tous les produits ne sont pas dans la base OpenFoodFacts
- Essayez avec un produit alimentaire courant

### Erreur de connexion
- Vérifiez votre connexion Internet
- L'émulateur doit avoir accès à Internet

### La caméra ne s'ouvre pas
- Vérifiez les permissions dans les paramètres Android
- Redémarrez l'application

### L'image code-barre.png ne s'affiche pas
- Vérifiez que le fichier est bien à la racine du projet
- Relancez : `flutter pub get`
- Redémarrez l'app : `flutter run`

## 🎨 Personnalisation

### Modifier le code-barres de test
Dans `lib/screens/scanner_screen.dart`, ligne 80 :
```dart
void _testWithNutellaBarcode() {
  const nutellaBarcode = '3017620422003'; // ← Changez ce code
  // ...
}
```

### Ajouter d'autres types de codes-barres
Dans `lib/screens/scanner_screen.dart`, ligne 14 :
```dart
MobileScannerController cameraController = MobileScannerController(
  formats: [
    BarcodeFormat.ean8, 
    BarcodeFormat.ean13, 
    BarcodeFormat.upcA, 
    BarcodeFormat.upcE,
    BarcodeFormat.qrCode, // ← Ajoutez d'autres formats
  ],
);
```

## 🌐 API OpenFoodFacts

**Documentation complète :** https://openfoodfacts.github.io/api-documentation/

**Exemple de requête :**
```
GET https://world.openfoodfacts.org/api/v0/product/3017620422003.json
```

**Structure de la réponse :**
```json
{
  "status": 1,
  "product": {
    "product_name": "Nutella",
    "brands": "Ferrero",
    "quantity": "400g",
    "nutriscore_grade": "e",
    "nutriments": { ... },
    "ingredients_text": "...",
    ...
  }
}
```

## ✅ Checklist de test

- [ ] L'application démarre sans erreur
- [ ] Bouton "Test avec Nutella" fonctionne
- [ ] Les informations du Nutella s'affichent
- [ ] L'image du produit est visible
- [ ] Le Nutri-Score est affiché (E en rouge)
- [ ] Les ingrédients sont lisibles
- [ ] Les informations nutritionnelles s'affichent
- [ ] Le scanner de caméra s'ouvre
- [ ] Le cadre vert est visible sur la caméra
- [ ] Un code-barres peut être scanné avec la caméra
- [ ] L'icône 📷 affiche l'image code-barre.png
- [ ] Les erreurs sont gérées (produit non trouvé, etc.)

## 📞 Support

Pour plus d'informations sur l'API OpenFoodFacts :
- Site web : https://world.openfoodfacts.org/
- GitHub : https://github.com/openfoodfacts
- Documentation : https://openfoodfacts.github.io/api-documentation/




