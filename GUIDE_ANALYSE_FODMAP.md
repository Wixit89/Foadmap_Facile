# Guide de l'Analyse FODMAP Automatique

## 🎯 Concept

Quand vous scannez un produit avec un code-barres, l'application :
1. 📡 Récupère les informations depuis OpenFoodFacts
2. 🔍 Analyse automatiquement la liste des ingrédients
3. 🎨 Compare chaque ingrédient avec la base de données FODMAP (85 aliments)
4. 🌈 Affiche les ingrédients avec un **code couleur** selon leur niveau FODMAP

## 🌈 Code Couleur des Ingrédients

### 🔴 Rouge - FODMAP Élevé
**Ingrédients déconseillés pour les personnes avec SII**
- Exemples : Oignons, Ail, Lait, Blé, Miel, etc.
- Portions très limitées (5g à 40g max)

### 🟠 Orange - FODMAP Modéré
**Ingrédients à consommer avec prudence**
- Exemples : Brocoli, Maïs, Banane, etc.
- Portions modérées (40g à 100g)

### 🟢 Vert - FODMAP Faible
**Ingrédients généralement bien tolérés**
- Exemples : Pommes de terre, Carottes, Riz, Fraises, etc.
- Portions généreuses (100g à 200g)

### ⚪ Gris - Non FODMAP
**Ingrédients non identifiés dans la base FODMAP**
- Peuvent être sûrs ou simplement non répertoriés
- Nécessitent une vérification manuelle

## 📊 Carte d'Analyse FODMAP

Après le scan, vous verrez une **carte colorée** qui affiche :

### Score Global
- 🔴 **DÉCONSEILLÉ** : Au moins 1 ingrédient FODMAP élevé
- 🟠 **PRUDENCE** : Plusieurs ingrédients FODMAP modérés (3+)
- 🟡 **ATTENTION** : Quelques ingrédients FODMAP
- 🟢 **OK** : Aucun FODMAP détecté

### Compteurs
Trois cercles indiquant le nombre d'ingrédients :
- **Élevé** (rouge)
- **Modéré** (orange)
- **Faible** (vert)

## 🎨 Affichage des Ingrédients

Les ingrédients sont affichés sous forme de **badges colorés** :

### Ingrédients FODMAP (cliquables)
- Badge coloré avec bordure
- Icône ℹ️ pour plus d'infos
- **Cliquez dessus** pour voir :
  - Niveau FODMAP exact
  - Portion autorisée

### Ingrédients non FODMAP
- Badge gris simple
- Pas d'icône

## 🧪 Exemple avec le Nutella

Quand vous scannez le Nutella (ou cliquez sur "Test avec Nutella") :

### Analyse attendue :
- **Sucre** → 🟢 Faible (généralement toléré)
- **Huile de palme** → ⚪ Non FODMAP
- **Noisettes** → ⚪ Non FODMAP
- **Cacao** → 🟢 Faible
- **Lait écrémé en poudre** → 🔴 Élevé ⚠️
- **Lactose** → 🔴 Élevé ⚠️
- **Etc.**

### Score global :
🔴 **DÉCONSEILLÉ** car contient du lait et du lactose (FODMAP élevé)

## 🔍 Base de Données FODMAP

La base contient **85 aliments** répartis en :
- 31 aliments FODMAP Élevé
- 10 aliments FODMAP Modéré
- 22 aliments FODMAP Faible
- + Variantes (singulier/pluriel)

### Catégories incluses :
- 🥬 Légumes
- 🍎 Fruits
- 🫘 Légumineuses
- 🥛 Produits laitiers (lait, lactose, lactosérum)
- 🌾 Céréales (blé, seigle, orge)
- 🍯 Sucres (miel, fructose, sirop de glucose-fructose, inuline)

## 🛠️ Comment ça marche ?

### 1. Récupération des données
```
Code-barres → API OpenFoodFacts → Ingrédients texte
```

### 2. Normalisation
```
"Sucre, LAIT écrémé, huile de palme."
↓
["sucre", "lait écrémé", "huile de palme"]
```

### 3. Comparaison
Chaque ingrédient est comparé avec les 85 aliments de la base :
```
"lait écrémé" → Correspond à "Lait" → FODMAP Élevé (40ml max)
```

### 4. Affichage
```
Badge rouge + bordure + icône ℹ️
```

## 🎯 Utilisation Pratique

### Au supermarché 🛒
1. Scannez le code-barres d'un produit
2. Regardez la **carte d'analyse** en haut
3. Vérifiez les **badges rouges** (à éviter)
4. Cliquez sur les ingrédients suspects pour voir les portions autorisées

### À la maison 🏠
1. Comparez plusieurs produits similaires
2. Choisissez celui avec le moins de FODMAP élevés
3. Vérifiez les portions autorisées pour chaque ingrédient

## ⚠️ Limites et Avertissements

### Limites de l'analyse automatique :
1. **Base limitée** : Seulement 85 aliments répertoriés
2. **Texte approximatif** : Les ingrédients peuvent avoir des noms différents
3. **Quantités inconnues** : L'application ne connaît pas les quantités exactes dans le produit
4. **Données OpenFoodFacts** : Dépend de la qualité des données saisies par les contributeurs

### Important :
- ⚠️ **Ce n'est pas un conseil médical**
- 👨‍⚕️ **Consultez un diététicien** pour un régime personnalisé
- 🔬 **Faites vos propres tests** : Chaque personne réagit différemment
- 📝 **Tenez un journal alimentaire** pour identifier vos sensibilités

## 🚀 Fonctionnalités Futures (idées)

- [ ] Base FODMAP étendue (200+ aliments)
- [ ] Détection des additifs (E-codes)
- [ ] Score personnalisé selon vos sensibilités
- [ ] Historique des produits scannés
- [ ] Alternatives suggérées (produits similaires sans FODMAP)
- [ ] Export des résultats en PDF
- [ ] Partage avec votre diététicien

## 📝 Exemples de Produits

### Produits DÉCONSEILLÉS (nombreux FODMAP élevés) :
- 🍕 Pizza (blé, oignons, ail)
- 🍞 Pain blanc (blé)
- 🍦 Glace au lait (lactose)
- 🍰 Gâteaux (blé, lait)

### Produits OK (peu ou pas de FODMAP) :
- 🍚 Riz nature
- 🥔 Chips de pommes de terre
- 🍓 Confiture de fraises (si sans sirop de glucose-fructose)
- 🥜 Beurre de cacahuètes (si sans additifs)

## 🔧 Personnalisation

Pour modifier la base FODMAP, éditez :
📁 `lib/services/fodmap_service.dart`

```dart
static final List<Product> fodmapDatabase = [
  Product(
    id: 'XX',
    name: 'Nom de l\'aliment',
    fodmapLevel: 'Élevé', // ou 'Modéré', 'Faible'
    allowedPortion: '10g',
    imageUrl: '🥕'
  ),
  // ... ajoutez vos aliments
];
```

## 📱 Interface

### Carte d'analyse FODMAP
- Bordure colorée selon le score
- Icône de statut
- Message clair
- 3 compteurs circulaires

### Badges d'ingrédients
- Couleur de fond
- Bordure colorée
- Texte en gras
- Icône ℹ️ (pour FODMAP)
- Cliquable (pour détails)

### Popup de détails
- Nom de l'aliment
- Badge niveau FODMAP
- Portion autorisée en gros

## ✅ Test

Pour tester l'analyse :
1. `flutter run`
2. Onglet "Scanner"
3. "Test avec Nutella"
4. Regardez les ingrédients colorés !

Vous devriez voir :
- Des badges rouges (lait, lactose)
- Des badges verts (sucre, cacao)
- Des badges gris (noisettes, huile de palme)
- Une carte rouge "DÉCONSEILLÉ"

## 🎓 En savoir plus sur les FODMAP

- Site officiel Monash University : https://www.monashfodmap.com/
- OpenFoodFacts : https://world.openfoodfacts.org/




