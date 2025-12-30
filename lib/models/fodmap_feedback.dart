class FodmapFeedback {
  final int? id;
  final int scanHistoryId;
  final DateTime feedbackDate;
  final bool hasBloating;
  final bool hasPain;
  final bool hasGas;
  final bool hasNoSymptoms;
  final String? notes;

  FodmapFeedback({
    this.id,
    required this.scanHistoryId,
    required this.feedbackDate,
    this.hasBloating = false,
    this.hasPain = false,
    this.hasGas = false,
    this.hasNoSymptoms = false,
    this.notes,
  });

  bool get hasSymptoms => hasBloating || hasPain || hasGas;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'scanHistoryId': scanHistoryId,
      'feedbackDate': feedbackDate.toIso8601String(),
      'hasBloating': hasBloating ? 1 : 0,
      'hasPain': hasPain ? 1 : 0,
      'hasGas': hasGas ? 1 : 0,
      'hasNoSymptoms': hasNoSymptoms ? 1 : 0,
      'notes': notes,
    };
  }

  factory FodmapFeedback.fromMap(Map<String, dynamic> map) {
    return FodmapFeedback(
      id: map['id'] as int?,
      scanHistoryId: map['scanHistoryId'] as int,
      feedbackDate: DateTime.parse(map['feedbackDate'] as String),
      hasBloating: map['hasBloating'] == 1,
      hasPain: map['hasPain'] == 1,
      hasGas: map['hasGas'] == 1,
      hasNoSymptoms: map['hasNoSymptoms'] == 1,
      notes: map['notes'] as String?,
    );
  }

  List<String> getSymptomsList() {
    List<String> symptoms = [];
    if (hasBloating) symptoms.add('Ballonnements');
    if (hasPain) symptoms.add('Douleurs');
    if (hasGas) symptoms.add('Gaz');
    if (hasNoSymptoms) symptoms.add('Aucun symptôme');
    return symptoms;
  }
}



