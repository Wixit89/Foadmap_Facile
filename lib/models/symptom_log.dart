class SymptomLog {
  final int? id;
  final DateTime date;
  final bool hasBloating;
  final bool hasPain;
  final bool hasGas;
  final bool hasDiarrhea;
  final bool hasIrritability;
  final bool hasNoSymptoms;

  SymptomLog({
    this.id,
    required this.date,
    this.hasBloating = false,
    this.hasPain = false,
    this.hasGas = false,
    this.hasDiarrhea = false,
    this.hasIrritability = false,
    this.hasNoSymptoms = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'hasBloating': hasBloating ? 1 : 0,
      'hasPain': hasPain ? 1 : 0,
      'hasGas': hasGas ? 1 : 0,
      'hasDiarrhea': hasDiarrhea ? 1 : 0,
      'hasIrritability': hasIrritability ? 1 : 0,
      'hasNoSymptoms': hasNoSymptoms ? 1 : 0,
    };
  }

  factory SymptomLog.fromMap(Map<String, dynamic> map) {
    int _asInt(dynamic v) {
      if (v is int) return v;
      if (v is bool) return v ? 1 : 0;
      if (v is String) return int.tryParse(v) ?? 0;
      return 0;
    }

    return SymptomLog(
      id: map['id'] as int?,
      date: DateTime.parse(map['date'] as String),
      hasBloating: _asInt(map['hasBloating']) == 1,
      hasPain: _asInt(map['hasPain']) == 1,
      hasGas: _asInt(map['hasGas']) == 1,
      hasDiarrhea: _asInt(map['hasDiarrhea']) == 1,
      hasIrritability: _asInt(map['hasIrritability']) == 1,
      hasNoSymptoms: _asInt(map['hasNoSymptoms']) == 1,
    );
  }

  bool get hasAny => hasBloating || hasPain || hasGas || hasDiarrhea || hasIrritability || hasNoSymptoms;
}

