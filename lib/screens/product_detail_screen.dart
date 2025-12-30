import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../services/openfoodfacts_service.dart';
import '../services/fodmap_service.dart';
import '../services/database_service.dart';
import '../models/scan_history.dart';
import '../widgets/feedback_dialog.dart';

class ProductDetailScreen extends StatefulWidget {
  final String barcode;
  final int? scanHistoryId;

  const ProductDetailScreen({
    super.key,
    required this.barcode,
    this.scanHistoryId,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final OpenFoodFactsService _foodService = OpenFoodFactsService();
  final DatabaseService _dbService = DatabaseService();
  
  bool isLoading = true;
  Map<String, dynamic>? productData;
  Map<String, dynamic>? fodmapAnalysis;
  String? errorMessage;
  int? scanHistoryId;

  @override
  void initState() {
    super.initState();
    scanHistoryId = widget.scanHistoryId;
    _fetchProductInfo();
  }

  Future<void> _showFeedbackDialog() async {
    if (scanHistoryId == null || productData == null) return;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => FeedbackDialog(
        scanHistoryId: scanHistoryId!,
        productName: productData!['name'] ?? 'Produit inconnu',
      ),
    );

    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('✓ Retour enregistré - Merci !'),
            ],
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _fetchProductInfo() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
      productData = null;
      fodmapAnalysis = null;
    });

    // Vérifier la connexion Internet
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        errorMessage = '📡 Pas de connexion Internet\n\nVeuillez activer le WiFi ou les données mobiles pour voir les détails du produit.';
        isLoading = false;
      });
      return;
    }

    try {
      final data = await _foodService.getProductInfo(widget.barcode);
      
      if (data != null) {
        final extractedData = _foodService.extractProductData(data);
        
        // Analyser les ingrédients avec la base FODMAP
        final analysis = FodmapService.analyzeIngredients(extractedData['ingredients_text']);
        
        // Si on n'a pas d'ID de scan historique (nouvelle consultation), le créer
        if (scanHistoryId == null) {
          // Extraire les types de FODMAP détectés
          Set<String> fodmapTypesSet = {};
          final ingredients = analysis['ingredients'] as List?;
          if (ingredients != null) {
            for (var ingredient in ingredients) {
              if (ingredient['isFodmap'] == true && ingredient['fodmapType'] != null) {
                final type = ingredient['fodmapType'] as String;
                if (type.isNotEmpty) {
                  fodmapTypesSet.add(type);
                }
              }
            }
          }
          
          // Sauvegarder dans l'historique
          final scanHistory = ScanHistory(
            barcode: widget.barcode,
            productName: extractedData['name'] ?? 'Produit inconnu',
            brand: extractedData['brands'],
            imageUrl: extractedData['image_url'],
            scannedAt: DateTime.now(),
            ingredientCount: (analysis['ingredients'] as List?)?.length ?? 0,
            highFodmapCount: analysis['highFodmapCount'] as int? ?? 0,
            moderateFodmapCount: analysis['moderateFodmapCount'] as int? ?? 0,
            lowFodmapCount: analysis['lowFodmapCount'] as int? ?? 0,
            fodmapTypes: fodmapTypesSet.isEmpty ? null : json.encode(fodmapTypesSet.toList()),
          );
          
          // Sauvegarder et récupérer l'ID
          scanHistoryId = await _dbService.addScan(scanHistory);
        }
        
        setState(() {
          productData = extractedData;
          fodmapAnalysis = analysis;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Produit non trouvé dans la base de données Open Food Facts.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Erreur: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  Color _getNutriScoreColor(String grade) {
    switch (grade.toUpperCase()) {
      case 'A':
        return Colors.green[700]!;
      case 'B':
        return Colors.lightGreen[600]!;
      case 'C':
        return Colors.yellow[700]!;
      case 'D':
        return Colors.orange[700]!;
      case 'E':
        return Colors.red[700]!;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Détails du produit',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black,
        actions: [
          if (scanHistoryId != null && productData != null && errorMessage == null)
            IconButton(
              icon: const Icon(Icons.feedback_outlined),
              tooltip: 'Noter mes symptômes',
              onPressed: () => _showFeedbackDialog(),
            ),
        ],
      ),
      floatingActionButton: scanHistoryId != null && productData != null && errorMessage == null
          ? FloatingActionButton.extended(
              onPressed: () => _showFeedbackDialog(),
              icon: const Icon(Icons.add_reaction_outlined),
              label: const Text('Noter mes symptômes'),
              backgroundColor: Colors.blue[600],
            )
          : null,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (errorMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error, color: Colors.red),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              errorMessage!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  
                  if (productData != null) ...[
                    _buildProductInfo(productData!),
                    const SizedBox(height: 100), // Espace pour le FAB
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildProductInfo(Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image du produit
        if (data['image_front_url'] != null && data['image_front_url'].isNotEmpty)
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                data['image_front_url'],
                height: 200,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, size: 100);
                },
              ),
            ),
          ),
        const SizedBox(height: 16),
        
        // Nom du produit
        Text(
          data['name'] ?? 'Produit inconnu',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        
        // Marque, Quantité et Nutri-Score sur la même ligne
        Row(
          children: [
            // Marque
            Expanded(
              child: Text(
                data['brands'] ?? 'Marque inconnue',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            // Quantité
            Text(
              data['quantity'] ?? '',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            // Nutri-Score
            if (data['nutriscore_grade'] != null && data['nutriscore_grade'].isNotEmpty) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _getNutriScoreColor(data['nutriscore_grade']),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  data['nutriscore_grade'].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ],
        ),
        
        const Divider(height: 24),
        
        // Analyse FODMAP
        if (fodmapAnalysis != null && fodmapAnalysis!['analyzed']) ...[
          _buildFodmapAnalysisCard(fodmapAnalysis!),
          const SizedBox(height: 16),
        ],
        
        // Liste des ingrédients avec détails FODMAP
        const Text(
          'Ingrédients détectés:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        if (fodmapAnalysis != null && fodmapAnalysis!['analyzed'])
          _buildIngredientsListView(fodmapAnalysis!['ingredients'])
        else
          Text(
            data['ingredients_text'] ?? 'Non disponible',
            style: const TextStyle(fontSize: 14),
          ),
      ],
    );
  }

  Widget _buildFodmapAnalysisCard(Map<String, dynamic> analysis) {
    final int highFodmapCount = analysis['highFodmapCount'] ?? 0;
    final int moderateFodmapCount = analysis['moderateFodmapCount'] ?? 0;
    final int lowFodmapCount = analysis['lowFodmapCount'] ?? 0;

    MaterialColor recommendationColor;
    String recommendationText;
    IconData recommendationIcon;

    if (highFodmapCount > 0) {
      recommendationColor = Colors.red;
      recommendationText = 'Déconseillé';
      recommendationIcon = Icons.cancel;
    } else if (moderateFodmapCount > 0) {
      recommendationColor = Colors.orange;
      recommendationText = 'Modéré - À consommer avec précaution';
      recommendationIcon = Icons.warning;
    } else if (lowFodmapCount > 0) {
      recommendationColor = Colors.lightGreen;
      recommendationText = 'Acceptable - Faibles FODMAPs';
      recommendationIcon = Icons.check_circle_outline;
    } else {
      recommendationColor = Colors.green;
      recommendationText = 'Recommandé - Aucun FODMAP détecté';
      recommendationIcon = Icons.check_circle;
    }

    return Card(
      margin: EdgeInsets.zero,
      color: recommendationColor[50],
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: recommendationColor[200]!, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(recommendationIcon, color: recommendationColor, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    recommendationText,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: recommendationColor.shade900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildFodmapCountBadge(
                  'Élevé',
                  highFodmapCount,
                  Colors.red,
                ),
                _buildFodmapCountBadge(
                  'Modéré',
                  moderateFodmapCount,
                  Colors.orange,
                ),
                _buildFodmapCountBadge(
                  'Faible',
                  lowFodmapCount,
                  Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFodmapCountBadge(String label, int count, Color color) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: color, width: 3),
          ),
          child: Center(
            child: Text(
              count.toString(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildIngredientsListView(List<dynamic> ingredients) {
    // Trier les ingrédients par niveau FODMAP
    List<dynamic> sortedIngredients = List.from(ingredients);
    sortedIngredients.sort((a, b) {
      bool aIsFodmap = a['isFodmap'] ?? false;
      bool bIsFodmap = b['isFodmap'] ?? false;
      
      if (!aIsFodmap && !bIsFodmap) return 0;
      if (!aIsFodmap) return 1;
      if (!bIsFodmap) return -1;
      
      String aLevel = a['fodmapLevel'] ?? '';
      String bLevel = b['fodmapLevel'] ?? '';
      
      int aScore = _getFodmapLevelScore(aLevel);
      int bScore = _getFodmapLevelScore(bLevel);
      
      return bScore.compareTo(aScore);
    });

    return Column(
      children: sortedIngredients.map<Widget>((ingredient) {
        bool isFodmap = ingredient['isFodmap'] ?? false;
        String text = ingredient['text'];

        if (isFodmap) {
          String fodmapLevel = ingredient['fodmapLevel'];
          String fodmapName = ingredient['fodmapName'];
          String allowedPortion = ingredient['allowedPortion'];
          String fodmapType = ingredient['fodmapType'] ?? '';
          List<dynamic> substitutes = ingredient['substitutes'] ?? [];
          
          Color accentColor;
          IconData icon;

          switch (fodmapLevel) {
            case 'Élevé':
              accentColor = Colors.red;
              icon = Icons.warning_rounded;
              break;
            case 'Modéré':
              accentColor = Colors.orange;
              icon = Icons.info;
              break;
            case 'Faible':
              accentColor = Colors.green;
              icon = Icons.check_circle_outline;
              break;
            default:
              accentColor = Colors.grey;
              icon = Icons.help_outline;
          }

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Barre colorée sur le côté
                  Container(
                    width: 4,
                    decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                      ),
                    ),
                  ),
                  // Contenu
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Nom de l'ingrédient avec icône
                          Row(
                            children: [
                              Icon(icon, color: accentColor, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  text,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: accentColor.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  fodmapLevel,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: accentColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Correspondance FODMAP
                          Row(
                            children: [
                              Text(
                                'FODMAP : ',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                fodmapName,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          // Type de FODMAP
                          if (fodmapType.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.science_outlined, size: 13, color: Colors.grey[600]),
                                const SizedBox(width: 4),
                                Text(
                                  'Type : ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    fodmapType,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                          const SizedBox(height: 4),
                          // Portion autorisée
                          Row(
                            children: [
                              Icon(Icons.scale, size: 13, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text(
                                'Max : ',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                allowedPortion,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: accentColor,
                                ),
                              ),
                            ],
                          ),
                          // Substitutions
                          if (substitutes.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.green[50],
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Colors.green[200]!, width: 1),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.swap_horiz, size: 14, color: Colors.green[700]),
                                      const SizedBox(width: 4),
                                      Text(
                                        'À remplacer par :',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green[900],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  ...substitutes.map((substitute) => Padding(
                                    padding: const EdgeInsets.only(left: 18, top: 2),
                                    child: Row(
                                      children: [
                                        Icon(Icons.circle, size: 4, color: Colors.green[700]),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            substitute.toString(),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.green[800],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )).toList(),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          // Ingrédient non FODMAP
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!, width: 1),
            ),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      }).toList(),
    );
  }

  int _getFodmapLevelScore(String level) {
    switch (level) {
      case 'Élevé':
        return 3;
      case 'Modéré':
        return 2;
      case 'Faible':
        return 1;
      default:
        return 0;
    }
  }
}

