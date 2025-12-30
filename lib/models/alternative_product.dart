// Modèle simplifié pour les produits alternatifs
class AlternativeProduct {
  final int id;
  final String name;
  final String brand;
  final String category;
  final String? barcode;
  final String availability;
  final List<String> benefits;
  final String emoji;
  final String? imageUrl; // URL de l'image depuis Open Food Facts

  AlternativeProduct({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    this.barcode,
    required this.availability,
    required this.benefits,
    required this.emoji,
    this.imageUrl,
  });
}
