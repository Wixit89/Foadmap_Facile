import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenFoodFactsService {
  static const String baseUrl = 'https://world.openfoodfacts.org/api/v0/product';

  /// Récupère les informations d'un produit depuis OpenFoodFacts
  Future<Map<String, dynamic>?> getProductInfo(String barcode) async {
    try {
      final url = Uri.parse('$baseUrl/$barcode.json');
      
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Vérifier si le produit existe
        if (data['status'] == 1) {
          return data;
        } else {
          return null; // Produit non trouvé
        }
      } else {
        throw Exception('Erreur lors de la requête: ${response.statusCode}');
      }
    } catch (e) {
      // Erreur lors de la récupération du produit
      rethrow;
    }
  }

  /// Extrait les informations principales du produit
  Map<String, dynamic> extractProductData(Map<String, dynamic> data) {
    final product = data['product'] ?? {};
    
    return {
      'name': product['product_name'] ?? 'Nom inconnu',
      'brands': product['brands'] ?? 'Marque inconnue',
      'quantity': product['quantity'] ?? 'Non spécifié',
      'categories': product['categories'] ?? 'Non catégorisé',
      'ingredients_text': product['ingredients_text'] ?? 'Ingrédients non disponibles',
      'image_url': product['image_url'] ?? '',
      'image_front_url': product['image_front_url'] ?? '',
      'nutriscore_grade': product['nutriscore_grade'] ?? '',
      'nutriments': product['nutriments'] ?? {},
      'allergens': product['allergens'] ?? 'Non spécifié',
      'labels': product['labels'] ?? '',
      'stores': product['stores'] ?? '',
      'countries': product['countries'] ?? '',
    };
  }
}

