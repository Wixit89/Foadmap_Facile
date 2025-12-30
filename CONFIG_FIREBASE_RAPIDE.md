# Configuration Firebase - Guide Rapide

## 🚀 Étapes essentielles

### 1. Créer le projet Firebase (Web)

1. Allez sur https://console.firebase.google.com/
2. **"Ajouter un projet"**
3. Nom : `app-android-fodmap`
4. **Créer le projet**

### 2. Ajouter Android

1. Dans Firebase Console, cliquez sur l'icône **Android** ⚙️
2. **Package Android** : `com.example.app_android`
3. **Nom de l'application** : `App Android`
4. **SHA-1** : Obtenir avec cette commande dans le terminal :

```bash
cd android
gradlew signingReport
```

Copiez le SHA-1 qui apparaît (ressemble à : `A1:B2:C3:...`)

5. Téléchargez **`google-services.json`**
6. **Placez-le dans** : `android/app/google-services.json`

### 3. Activer Google Sign-In dans Firebase

1. Firebase Console → **Authentication**
2. **"Commencer"**
3. Onglet **"Sign-in method"**
4. Activez **"Google"**
5. Email de support : votre email
6. **Enregistrer**

### 4. Vérifier les fichiers modifiés

✅ Déjà fait automatiquement :
- `pubspec.yaml` → Dépendances ajoutées
- `lib/main.dart` → Firebase initialisé
- `lib/services/auth_service.dart` → Service créé
- `lib/screens/account_screen.dart` → Connexion Google
- `android/app/build.gradle.kts` → Plugin Google Services
- `android/settings.gradle.kts` → Plugin déclaré

⚠️ À faire MANUELLEMENT :
- Télécharger `google-services.json` depuis Firebase
- Le placer dans `android/app/google-services.json`

### 5. Lancer l'application

```bash
flutter clean
flutter pub get
flutter run
```

## 🎯 Test

1. Ouvrez l'onglet **"Compte"**
2. Cliquez sur **"Se connecter avec Google"**
3. Sélectionnez votre compte Google
4. ✓ Vous devriez voir votre nom et photo !

## 🐛 Si ça ne marche pas

### Erreur "Default FirebaseApp is not initialized"
→ Le fichier `google-services.json` n'est pas au bon endroit
→ Il doit être dans `android/app/google-services.json`

### Erreur lors de la connexion Google
→ Le SHA-1 n'est pas configuré dans Firebase Console
→ Relancez `cd android && gradlew signingReport` et ajoutez le SHA-1

### Build Gradle échoue
→ Relancez :
```bash
flutter clean
cd android && gradlew clean
cd ..
flutter pub get
flutter run
```

## 📱 Votre applicationId

Votre package Android est : `com.example.app_android`

C'est ce nom qui doit être utilisé dans Firebase Console !




