# Configuration Firebase pour l'authentification Google

## 📋 Étapes de configuration

### 1. Créer un projet Firebase

1. Allez sur https://console.firebase.google.com/
2. Cliquez sur "Ajouter un projet"
3. Nom du projet : `app-android-fodmap` (ou votre choix)
4. Désactivez Google Analytics (optionnel)
5. Cliquez sur "Créer le projet"

### 2. Ajouter Android à votre projet Firebase

1. Dans la console Firebase, cliquez sur l'icône Android
2. **Package Android** : `com.example.app_android`
   - Pour trouver le vôtre : ouvrez `android/app/build.gradle` et cherchez `applicationId`
3. **App nickname** : `App Android FODMAP`
4. **SHA-1** : Optionnel pour le développement, mais nécessaire pour Google Sign-In en production

#### Obtenir le SHA-1 (Important pour Google Sign-In) :

```bash
cd android
./gradlew signingReport
```

Ou sur Windows :
```bash
cd android
gradlew signingReport
```

Copiez le SHA-1 qui apparaît dans la section `Task :app:signingReport`

5. Téléchargez le fichier `google-services.json`
6. Placez-le dans `android/app/google-services.json`

### 3. Activer l'authentification Google

1. Dans Firebase Console → Authentication
2. Cliquez sur "Get started"
3. Onglet "Sign-in method"
4. Activez "Google"
5. Configurez l'email de support du projet
6. Enregistrez

### 4. Modifier android/app/build.gradle

Ouvrez `android/app/build.gradle` et vérifiez que vous avez :

```gradle
android {
    ...
    defaultConfig {
        ...
        minSdkVersion 21  // Au minimum 21 pour Firebase
    }
}

dependencies {
    implementation platform('com.google.firebase:firebase-bom:32.7.0')
    implementation 'com.google.firebase:firebase-analytics'
}
```

### 5. Modifier android/build.gradle

Ouvrez `android/build.gradle` et ajoutez :

```gradle
buildscript {
    dependencies {
        ...
        classpath 'com.google.gms:google-services:4.4.0'
    }
}
```

En bas du fichier `android/app/build.gradle`, ajoutez :

```gradle
apply plugin: 'com.google.gms.google-services'
```

### 6. Installer les dépendances Flutter

```bash
flutter pub get
```

### 7. Tester

```bash
flutter run
```

## 🔧 Fichiers à créer/modifier

### ✅ Déjà fait dans le code :
- `pubspec.yaml` - Dépendances ajoutées
- `lib/main.dart` - Firebase.initializeApp()
- `lib/services/auth_service.dart` - Service d'authentification
- `lib/screens/account_screen.dart` - Écran de compte avec connexion Google

### ⚠️ À faire manuellement :

1. **Télécharger `google-services.json`** depuis Firebase Console
2. **Placer dans** : `android/app/google-services.json`
3. **Modifier** : `android/build.gradle` (ajouter classpath)
4. **Modifier** : `android/app/build.gradle` (ajouter apply plugin)

## 📱 Structure après configuration

```
app_android/
├── android/
│   ├── app/
│   │   ├── google-services.json  ← NOUVEAU (depuis Firebase)
│   │   └── build.gradle           ← MODIFIÉ
│   └── build.gradle                ← MODIFIÉ
├── lib/
│   ├── services/
│   │   └── auth_service.dart      ← NOUVEAU
│   ├── screens/
│   │   └── account_screen.dart    ← MODIFIÉ
│   └── main.dart                   ← MODIFIÉ
└── pubspec.yaml                    ← MODIFIÉ
```

## 🎯 Commandes utiles

### Vérifier la configuration Firebase
```bash
flutter pub run firebase_core:config
```

### Nettoyer et reconstruire
```bash
flutter clean
flutter pub get
cd android && ./gradlew clean
cd ..
flutter run
```

### Vérifier les SHA
```bash
cd android
./gradlew signingReport
```

## 🐛 Résolution de problèmes

### Erreur "Default FirebaseApp is not initialized"
→ Vérifiez que `google-services.json` est bien dans `android/app/`

### Erreur lors de la connexion Google
→ Vérifiez que le SHA-1 est configuré dans Firebase Console

### Erreur de build Gradle
→ Vérifiez les versions dans `android/build.gradle` et `android/app/build.gradle`

### L'app ne se lance pas après les modifications
```bash
flutter clean
flutter pub get
flutter run
```

## ✅ Test final

1. Lancez l'app : `flutter run`
2. Allez dans l'onglet "Compte"
3. Cliquez sur "Se connecter avec Google"
4. Sélectionnez votre compte Google
5. Vous devriez voir votre nom et photo apparaître !

## 🔐 Sécurité

Pour la production :
- Ajoutez les SHA-1 de votre keystore de release
- Activez App Check dans Firebase
- Configurez les règles de sécurité Firestore/Database si utilisées





