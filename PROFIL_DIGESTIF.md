# Profil Digestif - Documentation

## 📋 Vue d'ensemble

La fonctionnalité "Profil digestif" analyse automatiquement la tolérance de l'utilisateur aux différents types de FODMAP en se basant sur son historique de scans et ses retours après consommation.

⚠️ **Important** : Cette fonctionnalité est **purement informative** et ne fournit **aucun diagnostic médical**.

---

## 🎯 Fonctionnalités

### 1. Analyse automatique
- Calcule la tolérance pour chaque type de FODMAP (Fructanes, Lactose, Polyols, GOS, Fructose excès)
- Se base sur les scans réels et les retours utilisateur
- Met à jour en temps réel

### 2. Statuts possibles
- 🟢 **Bien toléré** : < 30% de symptômes après 3+ expositions
- 🟠 **Sensibilité possible** : 30-60% de symptômes
- 🔴 **Sensibilité probable** : ≥ 60% de symptômes
- ⚪ **Données insuffisantes** : < 3 expositions avec retours

### 3. Système de feedback
- Notation des symptômes après chaque scan (optionnel)
- 3 types de symptômes : Ballonnements, Douleurs, Gaz
- Option "Aucun symptôme"
- Champ notes libre

---

## 🏗️ Architecture

### Modèles

#### `ScanHistory`
```dart
- fodmapTypes: String? // JSON des types FODMAP détectés
- hasFeedback: bool // Indique si un feedback existe
```

#### `FodmapFeedback`
```dart
- scanHistoryId: int
- feedbackDate: DateTime
- hasBloating: bool
- hasPain: bool
- hasGas: bool
- hasNoSymptoms: bool
- notes: String?
```

### Services

#### `DigestiveProfileService`
- `analyzeProfile()` : Analyse complète de tous les types de FODMAP
- `_analyzeFodmapType()` : Analyse d'un type spécifique
- Logique de calcul avec pondération selon niveau FODMAP

#### `DatabaseService`
- Tables : `scan_history` et `fodmap_feedback`
- Migration automatique de v1 à v2
- Relations : feedback → scan (foreign key)

### Écrans

#### `DigestiveProfileScreen`
- Liste des 5 types de FODMAP avec statuts
- Synthèse globale (nombre d'aliments analysés)
- Encart informatif
- Pull-to-refresh

#### `FodmapDetailScreen`
- Détail d'un type de FODMAP
- Statistiques personnelles
- Explication du statut
- Recommandations adaptées
- Avertissement médical

#### `FeedbackDialog`
- Formulaire de retour post-consommation
- 4 checkboxes de symptômes
- Champ notes optionnel
- Design moderne et accessible

---

## 🔄 Flux utilisateur

1. **Scanner un produit**
   - L'app détecte les types de FODMAP présents
   - Sauvegarde automatique dans l'historique

2. **Noter les symptômes** (optionnel)
   - Bouton "Noter mes symptômes" après le scan
   - FloatingActionButton visible
   - Feedback lié au scan

3. **Consulter le profil**
   - Onglet Compte → "Profil digestif"
   - Vue synthétique des tolérances
   - Clic sur un FODMAP → détails

4. **Amélioration continue**
   - Plus de scans + feedbacks = profil plus précis
   - Minimum 3 expositions pour un statut fiable

---

## 📊 Logique de calcul

### Pondération
```
Niveau élevé → poids x2
Niveau modéré → poids x1
Niveau faible → poids x1
```

### Formule
```
Taux de symptômes = (Nombre de symptômes pondérés) / (Nombre d'expositions)
```

### Seuils
```
< 3 expositions → Données insuffisantes
≥ 60% → Sensibilité probable
30-60% → Sensibilité possible
< 30% → Bien toléré
```

---

## 🎨 Design

### Principes
- Couleurs cohérentes (Vert/Orange/Rouge/Gris)
- Vocabulaire neutre et non médical
- Icons explicites (🟢🟠🔴⚪)
- Encarts informatifs et avertissements clairs

### Accessibilité
- Contraste élevé
- Icônes + texte
- Messages clairs
- Pas de jargon médical

---

## ⚠️ Disclaimers

### Dans l'app
1. **Profil digestif** : "Ce profil est basé uniquement sur ton utilisation de l'app. Il ne remplace pas un avis médical."

2. **Détail FODMAP** : "Cette analyse ne constitue pas un diagnostic médical. Pour tout symptôme persistant, consultez un professionnel."

3. **Feedback dialog** : "Ces données améliorent ton profil digestif"

### Vocabulaire
✅ À utiliser :
- "sensibilité probable"
- "tolérance observée"
- "d'après ton historique"
- "profil digestif"

❌ À éviter :
- "diagnostic"
- "maladie"
- "pathologie"
- "traitement"

---

## 🧪 Tests recommandés

### Scénarios
1. Utilisateur sans scans → Message "données insuffisantes"
2. Utilisateur avec 3+ scans + feedbacks → Statuts calculés
3. Mélange scans avec/sans feedback → Ignore les scans sans feedback
4. Ajout feedback → Recalcul immédiat du profil

### Edge cases
- Scan sans FODMAP détectés
- Parsing JSON fodmapTypes échoue
- Database migration v1→v2
- Suppression d'un scan avec feedback (cascade delete)

---

## 🚀 Améliorations futures possibles

1. **Graphiques temporels** : Évolution des tolérances dans le temps
2. **Export PDF** : Partage avec médecin/diététicien
3. **Notifications** : "Pensez à noter vos symptômes"
4. **Suggestions produits** : Basé sur le profil
5. **Comparaison communautaire** : Stats anonymisées
6. **IA prédictive** : Anticiper les réactions

---

## 📱 Accès

**Navigation** : Onglet Compte → Section "Santé digestive" → "Profil digestif"

**Feedback** : Après un scan → Bouton "Noter mes symptômes" (AppBar + FAB)

---

## 🔒 Confidentialité

- Toutes les données stockées **localement** (SQLite)
- Aucune transmission serveur (sauf Firebase Auth optionnel)
- Pas de tracking analytics sur les symptômes
- Suppression d'un scan → suppression automatique du feedback

---

## 📞 Support

Pour toute question ou amélioration, ce profil est conçu pour :
- Être facilement compréhensible
- Respecter les règles médicales
- Rester informatif et non prescriptif
- Encourager la consultation médicale si besoin

**Dernière mise à jour** : Décembre 2025




