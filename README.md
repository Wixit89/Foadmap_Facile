# App Android - Projet Flutter

Une application Flutter basique pour Android.

## 📋 Prérequis

- Flutter SDK (installé ✓)
- Android SDK (installé ✓)
- Un émulateur Android ou un appareil physique

## 🚀 Commandes Utiles

### Démarrer l'application
```bash
# Lancer l'app sur un appareil connecté
flutter run

# Lancer l'app sur un émulateur spécifique
flutter run -d <device-id>
```

### Gestion des dépendances
```bash
# Installer les dépendances
flutter pub get

# Mettre à jour les dépendances
flutter pub upgrade

# Vérifier les dépendances obsolètes
flutter pub outdated
```

### Tests et débogage
```bash
# Exécuter les tests
flutter test

# Vérifier les problèmes du projet
flutter doctor

# Analyser le code
flutter analyze

# Lister les appareils connectés
flutter devices
```

### Build
```bash
# Créer un APK de debug
flutter build apk --debug

# Créer un APK de release
flutter build apk --release

# Créer un App Bundle pour le Play Store
flutter build appbundle --release
```

### Développement
```bash
# Nettoyer le projet
flutter clean

# Reformater le code
dart format lib/

# Recharger l'app à chaud (pendant flutter run)
# Appuyez sur 'r' dans le terminal
# Appuyez sur 'R' pour un rechargement complet
```

## 📁 Structure du Projet

```
app_android/
├── lib/
│   ├── main.dart                 # Point d'entrée et navigation
│   ├── models/
│   │   └── product.dart          # Modèle de données Produit
│   └── screens/
│       ├── scanner_screen.dart   # Écran scanner de code-barres
│       ├── products_screen.dart  # Écran liste de produits
│       └── account_screen.dart   # Écran compte utilisateur
├── android/                      # Configuration Android native
├── ios/                          # Configuration iOS native
├── test/                         # Tests unitaires
├── pubspec.yaml                  # Dépendances et configuration
└── README.md                     # Cette documentation
```

## 📦 Dépendances

- **mobile_scanner** : Scanner de code-barres/QR codes
- **permission_handler** : Gestion des permissions (caméra)

## 🎯 Fonctionnalités de l'App

### 1. 📷 Scanner de Code-Barres
- Scanner de codes-barres et QR codes en temps réel
- Interface caméra intuitive
- Affichage du code scanné
- Boutons de contrôle (Démarrer/Arrêter le scan)

### 2. 📦 Liste de Produits
- Catalogue de produits avec détails
- Affichage du prix, stock, et description
- Fonction d'ajout au panier
- Vue détaillée de chaque produit
- Barre de recherche

### 3. 👤 Mon Compte
- Profil utilisateur
- Statistiques (Commandes, Points, Favoris)
- Gestion des informations personnelles
- Adresses de livraison
- Moyens de paiement
- Historique des commandes
- Préférences (Notifications, Langue, Thème)
- Support et aide

### Navigation
- Barre de navigation en bas avec 3 onglets
- Interface Material Design 3
- Animations fluides

## 📱 Tester l'Application

1. Connectez un appareil Android ou démarrez un émulateur
2. Vérifiez qu'il est détecté : `flutter devices`
3. Lancez l'application : `flutter run`
4. Utilisez 'r' pour recharger à chaud après modifications

## 🛠️ Résolution de Problèmes

Si vous rencontrez des erreurs :
```bash
flutter clean
flutter pub get
flutter doctor -v
```

