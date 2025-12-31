import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io';
import '../models/product.dart';
import '../services/fodmap_service.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  // Utiliser la liste centralisée du service FODMAP
  List<Product> get products => FodmapService.fodmapDatabase.where((p) => 
    p.fodmapLevel == 'Élevé' || p.fodmapLevel == 'Modéré' || p.fodmapLevel == 'Faible'
  ).toSet().toList(); // Enlever les doublons
  String _searchQuery = '';
  String _selectedFilter = 'Tous'; // 'Tous', 'Déconseillé', 'Attention', 'OK'

  // Bannières AdMob pour la liste
  final Map<int, BannerAd> _bannerAds = {};
  final Set<int> _loadedAdIndexes = {};

  static String get _bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111'; // Test Banner ID Android
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716'; // Test Banner ID iOS
    }
    throw UnsupportedError('Unsupported platform');
  }

  @override
  void dispose() {
    for (final ad in _bannerAds.values) {
      ad.dispose();
    }
    super.dispose();
  }

  void _loadBannerAd(int index) {
    if (_loadedAdIndexes.contains(index)) return;
    _loadedAdIndexes.add(index);

    final bannerAd = BannerAd(
      adUnitId: _bannerAdUnitId,
      size: AdSize.banner, // 320x50 pour s'intégrer dans la liste
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (mounted) {
            setState(() {
              _bannerAds[index] = ad as BannerAd;
            });
          }
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _loadedAdIndexes.remove(index);
        },
      ),
    );
    bannerAd.load();
  }

  // Calcule les positions des pubs : index 0, puis tous les 10 produits
  List<int> _getAdPositions(int productCount) {
    List<int> positions = [0]; // Première position = pub
    for (int i = 10; i < productCount + (productCount ~/ 10) + 1; i += 11) {
      positions.add(i);
    }
    return positions;
  }

  int _getProductIndex(int listIndex, List<int> adPositions) {
    int adsBefore = adPositions.where((pos) => pos < listIndex).length;
    return listIndex - adsBefore;
  }

  bool _isAdPosition(int index, List<int> adPositions) {
    return adPositions.contains(index);
  }

  List<Product> get filteredProducts {
    List<Product> tempProducts = products;

    // Appliquer le filtre de niveau
    if (_selectedFilter == 'Déconseillé') {
      tempProducts = tempProducts.where((p) => p.fodmapLevel == 'Élevé').toList();
    } else if (_selectedFilter == 'Attention') {
      tempProducts = tempProducts.where((p) => p.fodmapLevel == 'Modéré').toList();
    } else if (_selectedFilter == 'OK') {
      tempProducts = tempProducts.where((p) => p.fodmapLevel == 'Faible').toList();
    }

    // Appliquer la recherche
    if (_searchQuery.isNotEmpty) {
      tempProducts = tempProducts.where((product) {
        return product.name.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    return tempProducts;
  }

  void _selectFilter(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }

  Color _getFodmapColor(String level) {
    switch (level) {
      case 'Élevé':
        return Colors.red;
      case 'Modéré':
        return Colors.orange;
      case 'Faible':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'Foadmap_Logo.png',
            width: 48,
            height: 48,
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Aliments FODMAP',
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
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              _showInfoDialog(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Rechercher un aliment...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[800]
                    : Colors.grey[100],
              ),
            ),
          ),
          
          // Filtres
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('Tous', Icons.list),
                  const SizedBox(width: 8),
                  _buildFilterChip('Déconseillé', Icons.cancel, color: Colors.red),
                  const SizedBox(width: 8),
                  _buildFilterChip('Attention', Icons.warning, color: Colors.orange),
                  const SizedBox(width: 8),
                  _buildFilterChip('OK', Icons.check_circle, color: Colors.green),
                ],
              ),
            ),
          ),
          
          const Divider(),
          
          // Liste des aliments
          Expanded(
            child: filteredProducts.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 80, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'Aucun aliment trouvé',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : Builder(
                    builder: (context) {
                      final adPositions = _getAdPositions(filteredProducts.length);
                      final totalItemCount = filteredProducts.length + adPositions.length;
                      
                      return ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: totalItemCount,
                        itemBuilder: (context, index) {
                          // Vérifier si c'est une position de pub
                          if (_isAdPosition(index, adPositions)) {
                            _loadBannerAd(index);
                            
                            if (_bannerAds.containsKey(index)) {
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 6,
                                  horizontal: 4,
                                ),
                                elevation: 2,
                                child: Container(
                                  alignment: Alignment.center,
                                  height: _bannerAds[index]!.size.height.toDouble(),
                                  child: AdWidget(ad: _bannerAds[index]!),
                                ),
                              );
                            } else {
                              // Placeholder pendant le chargement
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 6,
                                  horizontal: 4,
                                ),
                                elevation: 2,
                                child: Container(
                                  height: 50,
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Chargement...',
                                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                                  ),
                                ),
                              );
                            }
                          }
                          
                          // Sinon afficher le produit
                          final productIndex = _getProductIndex(index, adPositions);
                          if (productIndex >= filteredProducts.length) {
                            return const SizedBox.shrink();
                          }
                          final product = filteredProducts[productIndex];
                          
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 4,
                            ),
                            elevation: 2,
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(12),
                              leading: CircleAvatar(
                                radius: 28,
                                backgroundColor: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.grey[800]
                                    : Colors.grey[100],
                                child: Text(
                                  product.imageUrl,
                                  style: const TextStyle(fontSize: 28),
                                ),
                              ),
                              title: Text(
                                product.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Text(
                                        'Niveau FODMAP : ',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: Theme.of(context).brightness == Brightness.dark
                                              ? Colors.grey[300]
                                              : Colors.black87,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _getFodmapColor(product.fodmapLevel)
                                              .withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: _getFodmapColor(product.fodmapLevel),
                                            width: 1.5,
                                          ),
                                        ),
                                        child: Text(
                                          product.fodmapLevel,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: _getFodmapColor(product.fodmapLevel),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.restaurant,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Portion autorisée : ${product.allowedPortion}',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Theme.of(context).brightness == Brightness.dark
                                              ? Colors.grey[300]
                                              : Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.grey[400],
                              ),
                              onTap: () {
                                _showProductDetails(context, product);
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
          
          // Compteur total en bas
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[850]
                  : Colors.grey[100],
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[700]!
                      : Colors.grey[300]!,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.food_bank, size: 20, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  '${filteredProducts.length} ingrédient${filteredProducts.length > 1 ? 's' : ''}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[200]
                        : Colors.black87,
                  ),
                ),
                if (_selectedFilter != 'Tous' || _searchQuery.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  Text(
                    '(sur ${products.length})',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[400]
                          : Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, IconData icon, {Color? color}) {
    final isSelected = _selectedFilter == label;
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: isSelected
                ? Colors.white
                : (color ?? Colors.grey[700]),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        _selectFilter(label);
      },
      backgroundColor: Colors.grey[100],
      selectedColor: color ?? Colors.blue,
      checkmarkColor: Colors.white,
      elevation: isSelected ? 3 : 1,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    );
  }

  void _showProductDetails(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Text(product.imageUrl, style: const TextStyle(fontSize: 32)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                product.name,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Niveau FODMAP
              Row(
                children: [
                  const Text(
                    'Niveau FODMAP : ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getFodmapColor(product.fodmapLevel),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      product.fodmapLevel,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              
              // Type de FODMAP
              if (product.fodmapType.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.purple[900]?.withValues(alpha: 0.3)
                        : Colors.purple[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.purple[700]!
                          : Colors.purple[200]!,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.science_outlined,
                        size: 18,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.purple[400]
                            : Colors.purple[700],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Type : ',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.purple[300]
                              : Colors.black,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          product.fodmapType,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.purple[200]
                                : Colors.purple[900],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              
              // Portion autorisée
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.blue[900]?.withValues(alpha: 0.3)
                      : Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.blue[700]!
                        : Colors.blue[200]!,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.restaurant, size: 18, color: Colors.blue),
                        SizedBox(width: 6),
                        Text(
                          'Portion autorisée',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      product.allowedPortion,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Substitutions
              if (product.substitutes.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.green[900]?.withValues(alpha: 0.3)
                        : Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.green[700]!
                          : Colors.green[300]!,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.swap_horiz, size: 20, color: Colors.green[700]),
                          const SizedBox(width: 8),
                          Text(
                            'À remplacer par :',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.green[300]
                                  : Colors.green[900],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ...product.substitutes.map((substitute) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 16,
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.green[400]
                                  : Colors.green[700],
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                substitute,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? Colors.green[200]
                                      : Colors.green[900],
                                  fontWeight: FontWeight.w500,
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
              
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.orange[900]?.withValues(alpha: 0.3)
                      : Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.orange[400]
                          : Colors.orange,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Consultez un professionnel de santé pour un régime adapté',
                        style: TextStyle(
                          fontSize: 11,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey[300]
                              : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.info, color: Colors.blue),
            SizedBox(width: 8),
            Text('FODMAP'),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Les FODMAP sont des glucides fermentescibles qui peuvent causer des troubles digestifs chez les personnes atteintes du syndrome de l\'intestin irritable (SII).',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 12),
              Text(
                '🔴 Élevé : À éviter ou consommer en très petite quantité',
                style: TextStyle(fontSize: 13),
              ),
              SizedBox(height: 6),
              Text(
                '🟠 Modéré : Peut être toléré en quantité limitée',
                style: TextStyle(fontSize: 13),
              ),
              SizedBox(height: 6),
              Text(
                '🟢 Faible : Généralement bien toléré',
                style: TextStyle(fontSize: 13),
              ),
              SizedBox(height: 12),
              Text(
                '⚠️ Les portions indiquées sont indicatives. Consultez un diététicien pour un régime personnalisé.',
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Compris'),
          ),
        ],
      ),
    );
  }
}
