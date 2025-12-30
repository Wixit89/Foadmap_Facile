import 'dart:convert';
import '../models/scan_history.dart';
import '../models/fodmap_feedback.dart';
import 'database_service.dart';

class FodmapTypeProfile {
  final String type;
  final int exposureCount;
  final int symptomCount;
  final double symptomRate;
  final String status;
  final String statusLabel;
  final int color;

  FodmapTypeProfile({
    required this.type,
    required this.exposureCount,
    required this.symptomCount,
    required this.symptomRate,
    required this.status,
    required this.statusLabel,
    required this.color,
  });

  String get statusEmoji {
    switch (status) {
      case 'tolerated':
        return '🟢';
      case 'caution':
        return '🟠';
      case 'probable_sensitivity':
        return '🔴';
      default:
        return '⚪';
    }
  }

  String get description {
    switch (status) {
      case 'tolerated':
        return 'Bien toléré selon ton historique';
      case 'caution':
        return 'Sensibilité possible - à surveiller';
      case 'probable_sensitivity':
        return 'Sensibilité probable observée';
      default:
        return 'Pas assez de données pour évaluer';
    }
  }

  String get explanation {
    switch (status) {
      case 'tolerated':
        return 'Cela signifie que cet élément semble généralement bien toléré par ton système digestif d\'après tes consommations enregistrées.';
      case 'caution':
        return 'Cela signifie que cet élément semble parfois associé à des inconforts chez toi. Une vigilance est conseillée.';
      case 'probable_sensitivity':
        return 'Cela signifie que cet élément est souvent associé à des inconforts dans ton historique. Il pourrait être préférable de limiter sa consommation.';
      default:
        return 'Nous avons besoin de plus de données (au moins 3 expositions avec retours) pour établir une tendance fiable.';
    }
  }
}

class DigestiveProfileService {
  final DatabaseService _db = DatabaseService();

  static const List<String> fodmapTypes = [
    'Fructanes',
    'Lactose',
    'Polyols',
    'GOS',
    'Fructose (excès)',
  ];

  static const Map<String, String> fodmapDescriptions = {
    'Fructanes': 'Présents dans : blé, oignon, ail, artichauts, asperges...',
    'Lactose': 'Présent dans : lait, yaourts, fromages frais, glaces...',
    'Polyols': 'Présents dans : pommes, poires, champignons, édulcorants (sorbitol, xylitol)...',
    'GOS': 'Présents dans : légumineuses (lentilles, pois chiches), haricots...',
    'Fructose (excès)': 'Présent dans : miel, mangue, figues, sirop de maïs...',
  };

  Future<Map<String, FodmapTypeProfile>> analyzeProfile() async {
    try {
      final scans = await _db.getAllScans();
      final feedbacks = await _db.getAllFeedbacks();

      // Créer un map des feedbacks par scanHistoryId
      final feedbackMap = <int, FodmapFeedback>{};
      for (var feedback in feedbacks) {
        feedbackMap[feedback.scanHistoryId] = feedback;
      }

      // Analyser chaque type de FODMAP
      Map<String, FodmapTypeProfile> profiles = {};

      for (String type in fodmapTypes) {
        var profile = _analyzeFodmapType(type, scans, feedbackMap);
        profiles[type] = profile;
      }

      return profiles;
    } catch (e) {
      // En cas d'erreur, retourner des profils vides
      return {};
    }
  }

  FodmapTypeProfile _analyzeFodmapType(
    String type,
    List<ScanHistory> scans,
    Map<int, FodmapFeedback> feedbackMap,
  ) {
    int exposureCount = 0;
    int symptomCount = 0;

    for (var scan in scans) {
      if (scan.fodmapTypes == null) continue;

      try {
        List<String> types = List<String>.from(json.decode(scan.fodmapTypes!));
        
        if (types.contains(type)) {
          exposureCount++;

          // Vérifier s'il y a un feedback
          if (scan.hasFeedback && scan.id != null) {
            final feedback = feedbackMap[scan.id];
            if (feedback != null && feedback.hasSymptoms) {
              // Pondérer selon le niveau FODMAP
              if (scan.highFodmapCount > 0) {
                symptomCount += 2; // Double poids pour niveau élevé
              } else if (scan.moderateFodmapCount > 0) {
                symptomCount += 1;
              } else {
                symptomCount += 1;
              }
            }
          }
        }
      } catch (e) {
        // Ignorer les erreurs de parsing
        continue;
      }
    }

    double symptomRate = exposureCount > 0 ? symptomCount / exposureCount : 0.0;

    // Déterminer le statut selon les règles
    String status;
    String statusLabel;
    int color;

    if (exposureCount < 3) {
      status = 'insufficient_data';
      statusLabel = 'Données insuffisantes';
      color = 0xFFBDBDBD; // Gris
    } else if (symptomRate >= 0.6) {
      status = 'probable_sensitivity';
      statusLabel = 'Sensibilité probable';
      color = 0xFFE53935; // Rouge
    } else if (symptomRate >= 0.3) {
      status = 'caution';
      statusLabel = 'Sensibilité possible';
      color = 0xFFFF9800; // Orange
    } else {
      status = 'tolerated';
      statusLabel = 'Bien toléré';
      color = 0xFF4CAF50; // Vert
    }

    return FodmapTypeProfile(
      type: type,
      exposureCount: exposureCount,
      symptomCount: symptomCount,
      symptomRate: symptomRate,
      status: status,
      statusLabel: statusLabel,
      color: color,
    );
  }

  Future<int> getTotalScansAnalyzed() async {
    final scans = await _db.getAllScans();
    return scans.where((s) => s.fodmapTypes != null).length;
  }

  Future<int> getTotalScansWithFeedback() async {
    final scans = await _db.getAllScans();
    return scans.where((s) => s.hasFeedback).length;
  }

  String getDescription(String type) {
    return fodmapDescriptions[type] ?? 'Information non disponible';
  }
}

