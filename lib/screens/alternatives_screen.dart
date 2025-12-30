import 'package:flutter/material.dart';
import '../services/alternatives_service.dart';
import '../models/alternative_product.dart';
import 'product_detail_screen.dart';

class AlternativesScreen extends StatefulWidget {
  const AlternativesScreen({super.key});

  @override
  State<AlternativesScreen> createState() => _AlternativesScreenState();
}

class _AlternativesScreenState extends State<AlternativesScreen> {
  String? _selectedCategory;
  List<AlternativeProduct> _displayedProducts = AlternativesService.getAllProducts();
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterByCategory(String? category) {
    setState(() {
      _selectedCategory = category;
      final searchQuery = _searchController.text;
      
      if (category == null || category == 'Tous') {
        _displayedProducts = searchQuery.isEmpty 
            ? AlternativesService.getAllProducts() 
            : AlternativesService.searchProducts(searchQuery);
      } else {
        final filtered = AlternativesService.getProductsByCategory(category);
        _displayedProducts = searchQuery.isEmpty 
            ? filtered 
            : filtered.where((p) => 
                p.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
                p.brand.toLowerCase().contains(searchQuery.toLowerCase())
              ).toList();
      }
    });
  }

  void _search(String query) {
    setState(() {
      if (_selectedCategory == null || _selectedCategory == 'Tous') {
        _displayedProducts = query.isEmpty 
            ? AlternativesService.getAllProducts() 
            : AlternativesService.searchProducts(query);
      } else {
        final filtered = AlternativesService.getProductsByCategory(_selectedCategory!);
        _displayedProducts = query.isEmpty 
            ? filtered 
            : filtered.where((p) => 
                p.name.toLowerCase().contains(query.toLowerCase()) ||
                p.brand.toLowerCase().contains(query.toLowerCase())
              ).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final categories = AlternativesService.getCategories();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Produits Alternatifs',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black,
      ),
      body: Column(
        children: [
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _search('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: _search,
            ),
          ),

          // Filtres catégories
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _buildCategoryChip('Tous', null),
                ...categories.map((cat) => _buildCategoryChip(cat, cat)),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Compteur
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Text(
                  '${_displayedProducts.length} produit${_displayedProducts.length > 1 ? 's' : ''}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Low FODMAP',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.green[900],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Liste produits
          Expanded(
            child: _displayedProducts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'Aucun produit trouvé',
                          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: _displayedProducts.length,
                    itemBuilder: (context, index) {
                      return _buildProductCard(_displayedProducts[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, String? category) {
    final isSelected = _selectedCategory == category;
    
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) => _filterByCategory(selected ? category : null),
        backgroundColor: Colors.grey[200],
        selectedColor: Colors.green[600],
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        showCheckmark: false,
      ),
    );
  }

  Widget _buildProductCard(AlternativeProduct product) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: product.barcode != null 
            ? () {
                // Navigation vers la page de détails
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailScreen(
                      barcode: product.barcode!,
                    ),
                  ),
                );
              }
            : null,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête avec emoji et nom
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image ou Emoji
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: product.imageUrl != null && product.imageUrl!.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            product.imageUrl!,
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Text(
                                  product.emoji,
                                  style: const TextStyle(fontSize: 40),
                                ),
                              );
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                child: CircularProgressIndicator(strokeWidth: 2),
                              );
                            },
                          ),
                        )
                      : Center(
                          child: Text(
                            product.emoji,
                            style: const TextStyle(fontSize: 40),
                          ),
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nom - Marque
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            height: 1.3,
                          ),
                          children: [
                            TextSpan(text: product.name),
                            TextSpan(
                              text: ' - ',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            TextSpan(
                              text: product.brand,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Catégorie
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          product.category,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.blue[900],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Avantages
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.check_circle, size: 16, color: Colors.green[700]),
                      const SizedBox(width: 6),
                      Text(
                        'Pourquoi ce produit :',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[900],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: product.benefits.map((benefit) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green[300]!),
                        ),
                        child: Text(
                          benefit,
                          style: TextStyle(fontSize: 11, color: Colors.green[900]),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Disponibilité
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.store, size: 18, color: Colors.orange[700]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      product.availability,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.orange[900],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Code-barres
            if (product.barcode != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.qr_code, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 6),
                  Text(
                    product.barcode!,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
      ),
    );
  }
}
