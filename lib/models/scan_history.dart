class ScanHistory {
  final int? id;
  final String barcode;
  final String productName;
  final String? brand;
  final String? imageUrl;
  final DateTime scannedAt;
  final int ingredientCount;
  final int highFodmapCount;
  final int moderateFodmapCount;
  final int lowFodmapCount;
  final String? fodmapTypes; // JSON string: liste des types FODMAP détectés
  final bool hasFeedback;

  ScanHistory({
    this.id,
    required this.barcode,
    required this.productName,
    this.brand,
    this.imageUrl,
    required this.scannedAt,
    this.ingredientCount = 0,
    this.highFodmapCount = 0,
    this.moderateFodmapCount = 0,
    this.lowFodmapCount = 0,
    this.fodmapTypes,
    this.hasFeedback = false,
  });

  // Convertir en Map pour SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'barcode': barcode,
      'productName': productName,
      'brand': brand,
      'imageUrl': imageUrl,
      'scannedAt': scannedAt.toIso8601String(),
      'ingredientCount': ingredientCount,
      'highFodmapCount': highFodmapCount,
      'moderateFodmapCount': moderateFodmapCount,
      'lowFodmapCount': lowFodmapCount,
      'fodmapTypes': fodmapTypes,
      'hasFeedback': hasFeedback ? 1 : 0,
    };
  }

  // Créer depuis Map (SQLite)
  factory ScanHistory.fromMap(Map<String, dynamic> map) {
    return ScanHistory(
      id: map['id'] as int?,
      barcode: map['barcode'] as String,
      productName: map['productName'] as String,
      brand: map['brand'] as String?,
      imageUrl: map['imageUrl'] as String?,
      scannedAt: DateTime.parse(map['scannedAt'] as String),
      ingredientCount: map['ingredientCount'] as int? ?? 0,
      highFodmapCount: map['highFodmapCount'] as int? ?? 0,
      moderateFodmapCount: map['moderateFodmapCount'] as int? ?? 0,
      lowFodmapCount: map['lowFodmapCount'] as int? ?? 0,
      fodmapTypes: map['fodmapTypes'] as String?,
      hasFeedback: map['hasFeedback'] == 1,
    );
  }

  // Calculer le niveau de risque global
  String get riskLevel {
    if (highFodmapCount > 0) return 'Élevé';
    if (moderateFodmapCount > 0) return 'Modéré';
    if (lowFodmapCount > 0) return 'Faible';
    return 'OK';
  }

  // Couleur associée au risque
  int get riskColor {
    if (highFodmapCount > 0) return 0xFFE53935; // Rouge
    if (moderateFodmapCount > 0) return 0xFFFF9800; // Orange
    if (lowFodmapCount > 0) return 0xFF8BC34A; // Vert
    return 0xFF9E9E9E; // Gris
  }
}

