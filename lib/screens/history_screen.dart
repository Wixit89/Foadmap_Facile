import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/scan_history.dart';
import '../services/database_service.dart';
import './product_detail_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final DatabaseService _dbService = DatabaseService();
  List<ScanHistory> _history = [];
  List<ScanHistory> _filteredHistory = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Tous'; // Tous, OK, Attention, Déconseillé

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);
    try {
      final history = await _dbService.getAllScans();
      setState(() {
        _history = history;
        _filteredHistory = history;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _applyFilters() {
    List<ScanHistory> filtered = _history;

    // Filtre par niveau de recommandation
    if (_selectedFilter == 'OK') {
      filtered = filtered.where((scan) => scan.highFodmapCount == 0 && scan.moderateFodmapCount == 0).toList();
    } else if (_selectedFilter == 'Attention') {
      filtered = filtered.where((scan) => scan.highFodmapCount == 0 && scan.moderateFodmapCount > 0).toList();
    } else if (_selectedFilter == 'Déconseillé') {
      filtered = filtered.where((scan) => scan.highFodmapCount > 0).toList();
    }

    // Filtre par recherche
    final query = _searchController.text;
    if (query.isNotEmpty) {
      filtered = filtered.where((scan) {
        return scan.productName.toLowerCase().contains(query.toLowerCase()) ||
               (scan.brand?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
               scan.barcode.contains(query);
      }).toList();
    }

    setState(() => _filteredHistory = filtered);
  }

  void _filterHistory(String query) {
    _applyFilters();
  }

  void _setFilter(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
    _applyFilters();
  }

  Future<void> _clearHistory() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Effacer l\'historique'),
        content: const Text('Supprimer tous les scans de l\'historique ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Tout effacer'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _dbService.clearHistory();
      _loadHistory();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Historique effacé')),
        );
      }
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Aujourd\'hui à ${DateFormat('HH:mm').format(date)}';
    } else if (difference.inDays == 1) {
      return 'Hier à ${DateFormat('HH:mm').format(date)}';
    } else if (difference.inDays < 7) {
      return DateFormat('EEEE à HH:mm', 'fr_FR').format(date);
    } else {
      return DateFormat('dd/MM/yyyy à HH:mm').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Historique',
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
          if (_history.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              tooltip: 'Effacer tout',
              onPressed: _clearHistory,
            ),
        ],
      ),
      body: Column(
        children: [
          // Barre de recherche
          if (_history.isNotEmpty)
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
                            _filterHistory('');
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: _filterHistory,
              ),
            ),

          // Filtres
          if (_history.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('Tous', Icons.all_inclusive),
                    const SizedBox(width: 8),
                    _buildFilterChip('OK', Icons.check_circle, color: Colors.green[600]),
                    const SizedBox(width: 8),
                    _buildFilterChip('Attention', Icons.warning, color: Colors.orange[600]),
                    const SizedBox(width: 8),
                    _buildFilterChip('Déconseillé', Icons.cancel, color: Colors.red[600]),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 12),

          // Compteur
          if (_history.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Text(
                    '${_filteredHistory.length} scan${_filteredHistory.length > 1 ? 's' : ''}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Limité à 100 scans max',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[500],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 8),

          // Liste de l'historique
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredHistory.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _searchController.text.isNotEmpty
                                  ? Icons.search_off
                                  : Icons.history,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _searchController.text.isNotEmpty
                                  ? 'Aucun résultat'
                                  : 'Aucun scan dans l\'historique',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            if (_searchController.text.isEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  'Scannez des produits pour commencer',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadHistory,
                        child: ListView.builder(
                          itemCount: _filteredHistory.length,
                          itemBuilder: (context, index) {
                            final scan = _filteredHistory[index];
                            return _buildHistoryItem(scan);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(ScanHistory scan) {
    return Dismissible(
      key: Key(scan.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Supprimer'),
            content: Text('Supprimer "${scan.productName}" ?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Annuler'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Supprimer'),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        if (scan.id != null) {
          _dbService.deleteScan(scan.id!);
          setState(() {
            _filteredHistory.remove(scan);
            _history.remove(scan);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${scan.productName} supprimé')),
          );
        }
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        elevation: 2,
        child: ListTile(
          contentPadding: const EdgeInsets.all(12),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailScreen(
                  barcode: scan.barcode,
                  scanHistoryId: scan.id,
                ),
              ),
            ).then((_) => _loadHistory()); // Recharger l'historique au retour
          },
          leading: scan.imageUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    scan.imageUrl!,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.image_not_supported),
                      );
                    },
                  ),
                )
              : Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.shopping_bag, size: 32),
                ),
          title: Text(
            scan.productName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (scan.brand != null) ...[
                const SizedBox(height: 4),
                Text(
                  scan.brand!,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
              const SizedBox(height: 4),
              Text(
                _formatDate(scan.scannedAt),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  if (scan.highFodmapCount > 0)
                    _buildBadge(
                      '${scan.highFodmapCount} Élevé',
                      Colors.red[100]!,
                      Colors.red[900]!,
                    ),
                  if (scan.moderateFodmapCount > 0)
                    _buildBadge(
                      '${scan.moderateFodmapCount} Modéré',
                      Colors.orange[100]!,
                      Colors.orange[900]!,
                    ),
                  if (scan.lowFodmapCount > 0)
                    _buildBadge(
                      '${scan.lowFodmapCount} Faible',
                      Colors.green[100]!,
                      Colors.green[900]!,
                    ),
                  if (scan.highFodmapCount == 0 &&
                      scan.moderateFodmapCount == 0 &&
                      scan.lowFodmapCount == 0)
                    _buildBadge(
                      'Aucun FODMAP',
                      Colors.grey[100]!,
                      Colors.grey[700]!,
                    ),
                ],
              ),
            ],
          ),
          trailing: SizedBox(
            width: 50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icône de recommandation
                if (scan.highFodmapCount == 0 && scan.moderateFodmapCount == 0)
                  Icon(
                    Icons.check_circle,
                    color: Colors.green[600],
                    size: 32,
                  )
                else if (scan.highFodmapCount > 0)
                  Icon(
                    Icons.cancel,
                    color: Colors.red[600],
                    size: 32,
                  )
                else
                  Icon(
                    Icons.warning,
                    color: Colors.orange[600],
                    size: 32,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, IconData icon, {Color? color}) {
    final isSelected = _selectedFilter == label;
    final chipColor = color ?? Colors.blue[600];

    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: isSelected ? Colors.white : chipColor,
          ),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          _setFilter(label);
        }
      },
      backgroundColor: Colors.grey[200],
      selectedColor: chipColor,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      showCheckmark: false,
    );
  }

  Widget _buildBadge(String label, Color bgColor, Color textColor) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

