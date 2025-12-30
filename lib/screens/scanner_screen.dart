import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../services/openfoodfacts_service.dart';
import '../services/fodmap_service.dart';
import '../services/database_service.dart';
import '../models/scan_history.dart';
import '../widgets/feedback_dialog.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  MobileScannerController cameraController = MobileScannerController(
    formats: [BarcodeFormat.ean8, BarcodeFormat.ean13, BarcodeFormat.upcA, BarcodeFormat.upcE],
  );
  
  String? scannedCode;
  bool isScanning = false;
  bool isLoading = false;
  bool showResults = false;
  Map<String, dynamic>? productData;
  Map<String, dynamic>? fodmapAnalysis;
  String? errorMessage;
  int? lastScanHistoryId; // Pour stocker l'ID du dernier scan

  final OpenFoodFactsService _foodService = OpenFoodFactsService();
  final DatabaseService _dbService = DatabaseService();

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  void _startScanning() {
    setState(() {
      isScanning = true;
      showResults = false;
      scannedCode = null;
      productData = null;
      fodmapAnalysis = null;
      errorMessage = null;
    });
  }

  void _stopScanning() {
    setState(() {
      isScanning = false;
    });
  }

  void _backToScanner() {
    setState(() {
      showResults = false;
      scannedCode = null;
      productData = null;
      fodmapAnalysis = null;
      errorMessage = null;
      lastScanHistoryId = null;
    });
  }

  Future<void> _showFeedbackDialog() async {
    if (lastScanHistoryId == null || productData == null) return;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => FeedbackDialog(
        scanHistoryId: lastScanHistoryId!,
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

  Future<void> _fetchProductInfo(String barcode) async {
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
        errorMessage = '📡 Pas de connexion Internet\n\nVeuillez activer le WiFi ou les données mobiles pour scanner des produits.';
        isLoading = false;
        showResults = true;
      });
      return;
    }

    try {
      final data = await _foodService.getProductInfo(barcode);
      
      if (data != null) {
        final extractedData = _foodService.extractProductData(data);
        
        // Analyser les ingrédients avec la base FODMAP
        final analysis = FodmapService.analyzeIngredients(extractedData['ingredients_text']);
        
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
          barcode: barcode,
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
        final scanId = await _dbService.addScan(scanHistory);
        
        setState(() {
          productData = extractedData;
          fodmapAnalysis = analysis;
          isLoading = false;
          showResults = true; // Afficher les résultats en plein écran
          lastScanHistoryId = scanId;
        });
      } else {
        setState(() {
          errorMessage = 'Produit non trouvé dans la base OpenFoodFacts';
          isLoading = false;
          showResults = true;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Erreur: ${e.toString()}';
        isLoading = false;
        showResults = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Si on affiche les résultats, afficher la vue résultats en plein écran
    if (showResults) {
      return _buildResultsView();
    }
    
    // Sinon, afficher la vue scanner
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Scanner',
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
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: isScanning
                ? Stack(
                    children: [
                      MobileScanner(
                        controller: cameraController,
                        onDetect: (capture) {
                          final List<Barcode> barcodes = capture.barcodes;
                          for (final barcode in barcodes) {
                            if (barcode.rawValue != null) {
                              setState(() {
                                scannedCode = barcode.rawValue;
                                isScanning = false;
                              });
                              _fetchProductInfo(barcode.rawValue!);
                              break;
                            }
                          }
                        },
                      ),
                      // Overlay moderne avec cadre arrondi
                      Center(
                        child: Container(
                          width: 280,
                          height: 180,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Coins animés
                      Center(
                        child: SizedBox(
                          width: 280,
                          height: 180,
                          child: Stack(
                            children: [
                              // Coin haut-gauche
                              Positioned(
                                top: 0,
                                left: 0,
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      top: BorderSide(color: Colors.blue, width: 4),
                                      left: BorderSide(color: Colors.blue, width: 4),
                                    ),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                    ),
                                  ),
                                ),
                              ),
                              // Coin haut-droit
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      top: BorderSide(color: Colors.blue, width: 4),
                                      right: BorderSide(color: Colors.blue, width: 4),
                                    ),
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20),
                                    ),
                                  ),
                                ),
                              ),
                              // Coin bas-gauche
                              Positioned(
                                bottom: 0,
                                left: 0,
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(color: Colors.blue, width: 4),
                                      left: BorderSide(color: Colors.blue, width: 4),
                                    ),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                    ),
                                  ),
                                ),
                              ),
                              // Coin bas-droit
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(color: Colors.blue, width: 4),
                                      right: BorderSide(color: Colors.blue, width: 4),
                                    ),
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(20),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 40,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.center_focus_strong,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Placez le code-barres dans le cadre',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.blue[50]!,
                          Colors.white,
                        ],
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(30),
                            decoration: BoxDecoration(
                              color: Colors.blue[100],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.qr_code_scanner,
                              size: 80,
                              color: Colors.blue[700],
                            ),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            'Prêt à scanner',
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Appuyez sur "Démarrer le scan" ci-dessous',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
          
          // Bouton de test avec Nutella
          if (!isScanning)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: OutlinedButton.icon(
                onPressed: () => _fetchProductInfo('3017620422003'),
                icon: const Icon(Icons.science_outlined, size: 20),
                label: const Text('Test avec Nutella'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.orange[700],
                  side: BorderSide(color: Colors.orange[300]!),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isScanning
                    ? [Colors.red[400]!, Colors.red[600]!]
                    : [Colors.blue[400]!, Colors.blue[600]!],
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: (isScanning ? Colors.red : Colors.blue).withOpacity(0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: isScanning ? _stopScanning : _startScanning,
              icon: Icon(
                isScanning ? Icons.stop_circle_outlined : Icons.qr_code_scanner,
                size: 28,
              ),
              label: Text(
                isScanning ? 'Arrêter le scan' : 'Démarrer le scan',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultsView() {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (!didPop) {
          _backToScanner();
        }
      },
      child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _backToScanner,
        ),
        title: const Text('Résultats'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // Bouton Scanner un autre
          TextButton.icon(
            onPressed: () {
              setState(() {
                showResults = false;
                scannedCode = null;
                productData = null;
                fodmapAnalysis = null;
                errorMessage = null;
                isScanning = true;
              });
            },
            icon: const Icon(Icons.qr_code_scanner, size: 20),
            label: const Text('Scanner un autre'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
            ),
          ),
          if (lastScanHistoryId != null && productData != null)
            IconButton(
              icon: const Icon(Icons.feedback_outlined),
              tooltip: 'Noter mes symptômes',
              onPressed: () => _showFeedbackDialog(),
            ),
        ],
      ),
      floatingActionButton: lastScanHistoryId != null && productData != null && errorMessage == null
          ? FloatingActionButton.extended(
              onPressed: () => _showFeedbackDialog(),
              icon: const Icon(Icons.add_reaction_outlined),
              label: const Text('Noter mes symptômes'),
              backgroundColor: Colors.blue[600],
            )
          : null,
      body: SingleChildScrollView(
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
              
              // Bouton "Scanner un autre" en bas
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      showResults = false;
                      scannedCode = null;
                      productData = null;
                      fodmapAnalysis = null;
                      errorMessage = null;
                      isScanning = true;
                    });
                  },
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text('Scanner un autre produit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 100), // Espace pour le FAB
            ],
          ],
        ),
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
          data['name'],
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
                data['brands'],
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
              data['quantity'],
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
        
        // Catégories
        _buildInfoRow('Catégories', data['categories']),
        
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
            data['ingredients_text'],
            style: const TextStyle(fontSize: 14),
          ),
        
        const Divider(height: 24),
        
        // Informations nutritionnelles
        if (data['nutriments'] != null && data['nutriments'].isNotEmpty) ...[
          const Text(
            'Informations nutritionnelles (pour 100g/100ml):',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          _buildNutrimentInfo(data['nutriments']),
        ],
        
        const Divider(height: 24),
        
        // Allergènes
        if (data['allergens'] != 'Non spécifié' && data['allergens'].isNotEmpty)
          _buildAllergensSection(data['allergens']),
        
        // Code-barres en bas
        if (scannedCode != null) ...[
          const SizedBox(height: 20),
          Center(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.barcode_reader, size: 20, color: Colors.grey[700]),
                  const SizedBox(width: 8),
                  SelectableText(
                    scannedCode!,
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'monospace',
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildNutrimentInfo(Map<String, dynamic> nutriments) {
    final List<MapEntry<String, String>> nutrientsList = [
      MapEntry('Énergie', '${nutriments['energy-kcal_100g'] ?? nutriments['energy_100g'] ?? 'N/A'} kcal'),
      MapEntry('Matières grasses', '${nutriments['fat_100g'] ?? 'N/A'} g'),
      MapEntry('dont acides gras saturés', '${nutriments['saturated-fat_100g'] ?? 'N/A'} g'),
      MapEntry('Glucides', '${nutriments['carbohydrates_100g'] ?? 'N/A'} g'),
      MapEntry('dont sucres', '${nutriments['sugars_100g'] ?? 'N/A'} g'),
      MapEntry('Fibres', '${nutriments['fiber_100g'] ?? 'N/A'} g'),
      MapEntry('Protéines', '${nutriments['proteins_100g'] ?? 'N/A'} g'),
      MapEntry('Sel', '${nutriments['salt_100g'] ?? 'N/A'} g'),
    ];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: nutrientsList.map((entry) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(entry.key),
                Text(
                  entry.value,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Color _getNutriScoreColor(String grade) {
    switch (grade.toLowerCase()) {
      case 'a':
        return Colors.green;
      case 'b':
        return Colors.lightGreen;
      case 'c':
        return Colors.yellow[700]!;
      case 'd':
        return Colors.orange;
      case 'e':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildFodmapAnalysisCard(Map<String, dynamic> analysis) {
    String overallScore = analysis['overallScore'];
    int highCount = analysis['highFodmapCount'];
    int moderateCount = analysis['moderateFodmapCount'];
    int lowCount = analysis['lowFodmapCount'];

    Color cardColor;
    Color textColor;
    String message;
    IconData icon;

    switch (overallScore) {
      case 'high':
        cardColor = Colors.red[50]!;
        textColor = Colors.red;
        message = '⚠️ DÉCONSEILLÉ pour les personnes avec SII';
        icon = Icons.cancel;
        break;
      case 'moderate':
        cardColor = Colors.orange[50]!;
        textColor = Colors.orange[800]!;
        message = '⚡ PRUDENCE - Plusieurs ingrédients à risque';
        icon = Icons.warning;
        break;
      case 'caution':
        cardColor = Colors.yellow[50]!;
        textColor = Colors.orange[700]!;
        message = '⚠️ ATTENTION - Contient des FODMAPs';
        icon = Icons.info;
        break;
      case 'safe':
        cardColor = Colors.green[50]!;
        textColor = Colors.green;
        message = '✓ Aucun FODMAP détecté';
        icon = Icons.check_circle;
        break;
      default:
        cardColor = Colors.grey[100]!;
        textColor = Colors.grey;
        message = 'Analyse impossible';
        icon = Icons.help;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: textColor, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: textColor, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildFodmapCount('Élevé', highCount, Colors.red),
              _buildFodmapCount('Modéré', moderateCount, Colors.orange),
              _buildFodmapCount('Faible', lowCount, Colors.green),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFodmapCount(String label, int count, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: Text(
            count.toString(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildAllergensSection(String allergens) {
    // Nettoyer les allergènes (enlever "en:", "fr:", etc.)
    List<String> allergensList = allergens
        .split(',')
        .map((a) => a.trim())
        .map((a) {
          // Enlever les préfixes de langue
          if (a.contains(':')) {
            return a.split(':').last.trim();
          }
          return a;
        })
        .where((a) => a.isNotEmpty)
        .toList();

    if (allergensList.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Allergènes:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: allergensList.map((allergen) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.orange, width: 1.5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.warning_amber_rounded, size: 16, color: Colors.orange),
                  const SizedBox(width: 4),
                  Text(
                    allergen,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
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
