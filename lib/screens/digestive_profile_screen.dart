import 'package:flutter/material.dart';
import '../services/digestive_profile_service.dart';
import '../services/database_service.dart';
import '../models/user_fodmap_preference.dart';
import 'fodmap_detail_screen.dart';

class DigestiveProfileScreen extends StatefulWidget {
  const DigestiveProfileScreen({super.key});

  @override
  State<DigestiveProfileScreen> createState() => _DigestiveProfileScreenState();
}

class _DigestiveProfileScreenState extends State<DigestiveProfileScreen> {
  final DigestiveProfileService _service = DigestiveProfileService();
  final DatabaseService _db = DatabaseService();
  Map<String, FodmapTypeProfile>? _profiles;
  Map<String, UserFodmapPreference> _userPreferences = {};
  bool _isLoading = true;
  int _totalScans = 0;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    if (!mounted) return;
    
    setState(() => _isLoading = true);
    
    try {
      // Ajouter un timeout de 10 secondes pour éviter le blocage infini
      final profiles = await _service.analyzeProfile().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          debugPrint('Timeout lors de l\'analyse du profil');
          return <String, FodmapTypeProfile>{};
        },
      );
      
      final total = await _service.getTotalScansAnalyzed().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          debugPrint('Timeout lors de la récupération du nombre de scans');
          return 0;
        },
      );
      
      final preferences = await _db.getAllUserPreferences().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          debugPrint('Timeout lors de la récupération des préférences');
          return <String, UserFodmapPreference>{};
        },
      );
      
      if (!mounted) return;
      
      setState(() {
        _profiles = profiles;
        _totalScans = total;
        _userPreferences = preferences;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Erreur lors du chargement du profil: $e');
      if (!mounted) return;
      
      setState(() {
        _profiles = <String, FodmapTypeProfile>{};
        _totalScans = 0;
        _userPreferences = <String, UserFodmapPreference>{};
        _isLoading = false;
      });
      
      // Afficher un message d'erreur à l'utilisateur
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors du chargement: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Profil digestif',
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
            icon: const Icon(Icons.refresh),
            onPressed: _loadProfile,
            tooltip: 'Actualiser',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadProfile,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // En-tête avec statistiques
                    _buildHeader(),
                    
                    const SizedBox(height: 30),

                    // Liste des FODMAP
                    const Text(
                      'Analyse par type de FODMAP',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    const SizedBox(height: 16),

                    if (_profiles != null)
                      ..._profiles!.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildFodmapCard(entry.key, entry.value),
                        );
                      }),

                    const SizedBox(height: 30),

                    // Encart informatif
                    _buildInfoBox(),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[50]!, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.blue[200]!,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.health_and_safety_outlined,
            size: 48,
            color: Colors.blue[700],
          ),
          const SizedBox(height: 12),
          const Text(
            'Profil digestif',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  'Le profil digestif évalue votre sensibilité aux FODMAPs en fonction :',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.qr_code_scanner, size: 16, color: Colors.blue[600]),
                    const SizedBox(width: 6),
                    Text(
                      'Vos scans',
                      style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.add, size: 14, color: Colors.grey[400]),
                    const SizedBox(width: 12),
                    Icon(Icons.feedback_outlined, size: 16, color: Colors.blue[600]),
                    const SizedBox(width: 6),
                    Text(
                      'Vos notes',
                      style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Plus vous notez vos symptômes, plus le profil devient précis',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Basé sur $_totalScans aliment${_totalScans > 1 ? 's' : ''} analysé${_totalScans > 1 ? 's' : ''}',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[700],
              fontWeight: FontWeight.w600,
            ),
          ),
          if (_totalScans < 3) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.orange[900], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Scannez plus de produits pour obtenir un profil plus précis',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.orange[900],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFodmapCard(String type, FodmapTypeProfile profile) {
    final userPref = _userPreferences[type];
    final isManual = userPref?.isManual ?? false;
    
    // Override le profil si préférence manuelle
    String displayStatus = profile.statusLabel;
    String displayEmoji = profile.statusEmoji;
    int displayColor = profile.color;
    
    if (isManual && userPref!.manualStatus != null) {
      switch (userPref.manualStatus) {
        case 'tolerated':
          displayStatus = 'Bien toléré (manuel)';
          displayEmoji = '🟢';
          displayColor = 0xFF4CAF50;
          break;
        case 'caution':
          displayStatus = 'Sensibilité possible (manuel)';
          displayEmoji = '🟠';
          displayColor = 0xFFFF9800;
          break;
        case 'sensitive':
          displayStatus = 'Sensibilité probable (manuel)';
          displayEmoji = '🔴';
          displayColor = 0xFFE53935;
          break;
      }
    }
    
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      child: InkWell(
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FodmapDetailScreen(
                fodmapType: type,
                profile: profile,
                userPreference: userPref,
                onPreferenceChanged: _loadProfile,
              ),
            ),
          );
          if (result == true) {
            _loadProfile();
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Color(displayColor).withOpacity(0.3),
              width: isManual ? 3 : 2,
            ),
          ),
          child: Row(
            children: [
              // Emoji/Icône
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(displayColor).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  displayEmoji,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Informations
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            type,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (isManual)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.purple[100],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'PERSONNALISÉ',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple[900],
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      displayStatus,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(displayColor),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isManual 
                          ? 'Réglage manuel actif'
                          : '${profile.exposureCount} exposition${profile.exposureCount > 1 ? 's' : ''}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontStyle: isManual ? FontStyle.italic : FontStyle.normal,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Flèche
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.blue[200]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.blue[700],
                size: 24,
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'À propos de ce profil',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Ce profil est basé uniquement sur ton utilisation de l\'app et tes retours après consommation.\n\nIl ne remplace pas un avis médical et ne constitue pas un diagnostic.\n\nPour des conseils personnalisés, consulte un professionnel de santé spécialisé dans les troubles digestifs.',
            style: TextStyle(
              fontSize: 13,
              color: Colors.blue[900],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.lightbulb_outline, color: Colors.amber[700], size: 20),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Ajoutez vos retours après chaque scan pour améliorer la précision',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

