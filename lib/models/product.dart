class Product {
  final String id;
  final String name;
  final String fodmapLevel; // 'Élevé', 'Modéré', 'Faible'
  final String allowedPortion;
  final String imageUrl;
  final String fodmapType; // Type de FODMAP (lactose, fructose, etc.)
  final List<String> substitutes; // Suggestions de remplacement

  Product({
    required this.id,
    required this.name,
    required this.fodmapLevel,
    required this.allowedPortion,
    required this.imageUrl,
    this.fodmapType = '',
    this.substitutes = const [],
  });

  // Conversion vers JSON (pour sauvegarder les données)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'fodmapLevel': fodmapLevel,
      'allowedPortion': allowedPortion,
      'imageUrl': imageUrl,
      'fodmapType': fodmapType,
      'substitutes': substitutes,
    };
  }

  // Création depuis JSON (pour charger les données)
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      fodmapLevel: json['fodmapLevel'],
      allowedPortion: json['allowedPortion'],
      imageUrl: json['imageUrl'],
      fodmapType: json['fodmapType'] ?? '',
      substitutes: json['substitutes'] != null 
          ? List<String>.from(json['substitutes']) 
          : [],
    );
  }
}

