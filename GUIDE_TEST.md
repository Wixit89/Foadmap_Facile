# Guide de Test - App Android

Ce guide vous permet de tester chaque module individuellement.

## 🚀 Lancement de l'Application

```bash
# Lancer l'application sur l'émulateur
flutter run -d emulator-5554

# Ou laisser Flutter choisir l'appareil
flutter run
```

---

## 📷 Module 1 : Scanner de Code-Barres

### Comment tester :
1. Lancez l'application
2. Vous êtes par défaut sur l'onglet "Scanner" (premier onglet en bas)
3. Appuyez sur le bouton **"Démarrer le scan"**
4. Autorisez l'accès à la caméra si demandé
5. Pointez la caméra vers un code-barres ou QR code
6. Le code sera automatiquement détecté et affiché en bas

### Fonctionnalités à tester :
- ✅ Démarrage du scanner
- ✅ Arrêt du scanner
- ✅ Détection de code-barres
- ✅ Détection de QR code
- ✅ Affichage du code scanné
- ✅ Copie du code (texte sélectionnable)

### Commandes de test isolé :
```bash
# Tester uniquement le scanner (modifier main.dart temporairement)
# Remplacer MainScreen() par ScannerScreen() dans main.dart
```

---

## 📦 Module 2 : Liste de Produits

### Comment tester :
1. Depuis l'écran principal, appuyez sur l'onglet **"Produits"** (au milieu)
2. Vous verrez la liste de 5 produits

### Fonctionnalités à tester :
- ✅ Affichage de la liste de produits
- ✅ Scroll de la liste
- ✅ Clic sur un produit → Affiche les détails dans une popup
- ✅ Bouton "Ajouter au panier" sur chaque produit
- ✅ Bouton "Ajouter au panier" dans la popup de détails
- ✅ Bouton recherche (barre d'outils en haut)
- ✅ Affichage du stock
- ✅ Affichage des prix

### Commandes de test isolé :
```bash
# Pour tester avec plus de produits, modifier lib/screens/products_screen.dart
# Ajouter plus d'éléments dans la liste 'products'
```

---

## 👤 Module 3 : Mon Compte

### Comment tester :
1. Appuyez sur l'onglet **"Compte"** (dernier onglet à droite)
2. Vous verrez le profil utilisateur

### Fonctionnalités à tester :
- ✅ Affichage du profil (avatar, nom, email)
- ✅ Statistiques (Commandes, Points, Favoris)
- ✅ Section "Mes informations"
  - Profil
  - Adresses
  - Moyens de paiement
- ✅ Section "Mes commandes"
  - Historique
  - Favoris
- ✅ Section "Préférences"
  - Notifications
  - Langue
  - Thème
- ✅ Section "Support"
  - Aide
  - À propos
- ✅ Bouton "Se déconnecter" → Affiche une popup de confirmation
- ✅ Bouton paramètres (icône en haut à droite)

### Commandes de test isolé :
```bash
# Pour modifier les données du profil, éditer lib/screens/account_screen.dart
# Changer les valeurs de 'Jean Dupont', 'jean.dupont@email.com', etc.
```

---

## 🔄 Navigation entre les modules

### Test de navigation :
1. Commencez sur l'onglet Scanner
2. Passez à Produits → Vérifiez que l'écran change
3. Passez à Compte → Vérifiez que l'écran change
4. Retournez au Scanner → Vérifiez que l'état est préservé

---

## 🐛 Débogage

### En cas de problème :

```bash
# Nettoyer le projet
flutter clean

# Réinstaller les dépendances
flutter pub get

# Voir les logs détaillés
flutter run -v

# Vérifier les permissions Android
# Allez dans Paramètres > Apps > app_android > Permissions
# Vérifiez que la caméra est autorisée
```

### Tester sur un appareil physique :
```bash
# Connectez votre téléphone en USB (Mode développeur activé)
# Vérifiez qu'il est détecté
flutter devices

# Lancez sur votre appareil
flutter run -d <device-id>
```

---

## 📝 Tests unitaires (à venir)

```bash
# Créer des tests pour chaque module
flutter test

# Tester uniquement le modèle Product
flutter test test/models/product_test.dart
```

---

## 🎨 Personnalisation

### Modifier les couleurs :
Éditez `lib/main.dart` ligne ~17 :
```dart
colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
```

### Ajouter des produits :
Éditez `lib/screens/products_screen.dart` dans la liste `products`

### Modifier le profil :
Éditez `lib/screens/account_screen.dart` dans la méthode `build`

---

## 🚀 Hot Reload

Pendant que l'app tourne (`flutter run`), vous pouvez :
- Appuyer sur **`r`** → Rechargement rapide (conserve l'état)
- Appuyer sur **`R`** → Rechargement complet (réinitialise l'app)
- Appuyer sur **`q`** → Quitter

---

## ✅ Checklist de test complète

- [ ] L'application démarre sans erreur
- [ ] Les 3 onglets sont visibles en bas
- [ ] Scanner : Le bouton démarre la caméra
- [ ] Scanner : Un code peut être scanné
- [ ] Produits : La liste s'affiche correctement
- [ ] Produits : On peut cliquer sur un produit
- [ ] Produits : Le bouton panier fonctionne
- [ ] Compte : Le profil s'affiche
- [ ] Compte : Toutes les sections sont cliquables
- [ ] Compte : Le bouton déconnexion affiche une popup
- [ ] Navigation : On peut passer d'un onglet à l'autre
- [ ] L'interface est fluide et réactive




