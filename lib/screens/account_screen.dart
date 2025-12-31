import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../providers/theme_provider.dart';
import 'profile_screen.dart';
import 'digestive_profile_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final AuthService _authService = AuthService();
  final DatabaseService _dbService = DatabaseService();
  User? _currentUser;
  bool _statsLoading = true;
  int _totalScans = 0;
  int _scans7d = 0;
  String _topFodmap = '-';
  int _topFodmapCount = 0;
  String _topSymptom = '-';
  int _topSymptomCount = 0;

  @override
  void initState() {
    super.initState();
    // Écouter les changements d'état de connexion
    _authService.authStateChanges.listen((User? user) {
      setState(() {
        _currentUser = user;
      });
    });
    // Initialiser avec l'utilisateur actuel
    _currentUser = _authService.currentUser;
    _loadStats();
  }


  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _loadStats() async {
    try {
      final scans = await _dbService.getAllScans();
      int total = scans.length;

      final symptoms = await _dbService.getAllSymptomLogs();
      final now = DateTime.now();
      final sevenDaysAgo = now.subtract(const Duration(days: 7));
      
      // Compter chaque type de symptôme sur les 7 derniers jours
      final Map<String, int> symptomCounts = {
        'Ballonnements': 0,
        'Douleurs': 0,
        'Gaz': 0,
        'Diarrhée': 0,
        'Irritabilité': 0,
      };
      
      for (final log in symptoms) {
        final d = DateTime(log.date.year, log.date.month, log.date.day);
        final inRange = d.isAfter(sevenDaysAgo) || d.isAtSameMomentAs(sevenDaysAgo);
        if (!inRange || log.hasNoSymptoms) continue;
        
        if (log.hasBloating) symptomCounts['Ballonnements'] = symptomCounts['Ballonnements']! + 1;
        if (log.hasPain) symptomCounts['Douleurs'] = symptomCounts['Douleurs']! + 1;
        if (log.hasGas) symptomCounts['Gaz'] = symptomCounts['Gaz']! + 1;
        if (log.hasDiarrhea) symptomCounts['Diarrhée'] = symptomCounts['Diarrhée']! + 1;
        if (log.hasIrritability) symptomCounts['Irritabilité'] = symptomCounts['Irritabilité']! + 1;
      }
      
      // Trouver le symptôme le plus récurrent
      String topSymptom = '-';
      int topSymptomCnt = 0;
      symptomCounts.forEach((name, count) {
        if (count > topSymptomCnt) {
          topSymptomCnt = count;
          topSymptom = name;
        }
      });
      
      int scansCount7d = scans.where((s) {
        final d = DateTime(s.scannedAt.year, s.scannedAt.month, s.scannedAt.day);
        return d.isAfter(sevenDaysAgo) || d.isAtSameMomentAs(sevenDaysAgo);
      }).length;

      // Calculer le FODMAP le plus problématique (associé aux symptômes)
      final feedbacks = await _dbService.getAllFeedbacks();
      final scansById = {for (var s in scans) if (s.id != null) s.id!: s};
      final Map<String, int> fodmapSymptomCount = {};
      int feedbacksWithSymptoms = 0;

      for (final fb in feedbacks) {
        // Ignorer les feedbacks explicitement sans symptômes
        if (fb.hasNoSymptoms) continue;
        // Vérifier s'il y a au moins un symptôme coché
        if (!fb.hasBloating && !fb.hasPain && !fb.hasGas) continue;
        
        feedbacksWithSymptoms++;
        
        final scan = scansById[fb.scanHistoryId];
        if (scan == null) continue;
        
        // Si fodmapTypes est vide, utiliser highFodmapCount/moderateFodmapCount pour estimer
        if (scan.fodmapTypes == null || scan.fodmapTypes!.isEmpty) {
          if (scan.highFodmapCount > 0 || scan.moderateFodmapCount > 0) {
            // Compter comme "Non identifié" si on sait qu'il y a des FODMAPs mais pas le type
            fodmapSymptomCount['Non identifié'] = (fodmapSymptomCount['Non identifié'] ?? 0) + 1;
          }
          continue;
        }

        // Parser les types de FODMAP (JSON array ou comma-separated)
        List<String> types = [];
        try {
          final decoded = jsonDecode(scan.fodmapTypes!);
          if (decoded is List) {
            types = decoded.cast<String>();
          }
        } catch (_) {
          // Fallback: comma-separated
          types = scan.fodmapTypes!.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
        }

        for (final type in types) {
          fodmapSymptomCount[type] = (fodmapSymptomCount[type] ?? 0) + 1;
        }
      }

      // Trouver le FODMAP le plus fréquent
      String topFodmap = '-';
      int topCount = 0;
      fodmapSymptomCount.forEach((type, count) {
        if (count > topCount) {
          topCount = count;
          topFodmap = type;
        }
      });
      
      // Si aucun type trouvé mais des feedbacks avec symptômes existent
      if (topFodmap == '-' && feedbacksWithSymptoms > 0) {
        topFodmap = 'Données manquantes';
        topCount = feedbacksWithSymptoms;
      }

      if (!mounted) return;
      setState(() {
        _totalScans = total;
        _scans7d = scansCount7d;
        _topFodmap = topFodmap;
        _topFodmapCount = topCount;
        _topSymptom = topSymptom;
        _topSymptomCount = topSymptomCnt;
        _statsLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _statsLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isConnected = _currentUser != null;
    final String userName = _currentUser?.displayName ?? 'Utilisateur';
    final String userEmail = _currentUser?.email ?? '';
    final String? photoUrl = _currentUser?.photoURL;

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
          'Compte',
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
      body: ListView(
        children: [
          // En-tête du profil
          Container(
            padding: const EdgeInsets.all(20),
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
                  child: photoUrl == null
                      ? Icon(
                          isConnected ? Icons.person : Icons.person_outline,
                          size: 60,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : null,
                ),
                const SizedBox(height: 16),
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (userEmail.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    userEmail,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                
                // Bouton de connexion si non connecté
                if (!isConnected) ...[
                  const Text(
                    'Connectez-vous pour synchroniser vos données',
                    style: TextStyle(fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  
                  // Bouton Google (Android uniquement)
                  if (Platform.isAndroid)
                    ElevatedButton.icon(
                      onPressed: () {
                        _connectWithGoogle();
                      },
                      icon: const Icon(Icons.login, size: 20),
                      label: const Text('Se connecter avec Google'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        elevation: 2,
                      ),
                    ),
                  
                  // Bouton Apple (iOS uniquement)
                  if (Platform.isIOS)
                    ElevatedButton.icon(
                      onPressed: () {
                        _connectWithApple();
                      },
                      icon: const Icon(Icons.apple, size: 20),
                      label: const Text('Se connecter avec Apple'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        elevation: 2,
                      ),
                    ),
                  const SizedBox(height: 8),
                  Text(
                    'Connexion optionnelle',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          const SizedBox(height: 8),

          // Stats
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Statistiques',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                _statsLoading
                    ? const Center(child: CircularProgressIndicator())
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          final itemWidth = (constraints.maxWidth - 12) / 2;
                          return Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              SizedBox(
                                width: itemWidth,
                                child: _buildStatCard(
                                  icon: Icons.qr_code_scanner,
                                  title: 'Scans total',
                                  value: '$_totalScans',
                                  color: const Color(0xFFFF9800),
                                ),
                              ),
                              SizedBox(
                                width: itemWidth,
                                child: _buildTopFodmapCard(),
                              ),
                              SizedBox(
                                width: itemWidth,
                                child: _buildTopSymptomCard(),
                              ),
                              SizedBox(
                                width: itemWidth,
                                child: _buildStatCard(
                                  icon: Icons.history_toggle_off,
                                  title: 'Scans sur 7 jours',
                                  value: '$_scans7d',
                                  color: Colors.indigo,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Santé digestive
          _buildSection('Santé digestive'),
          _buildMenuItem(
            icon: Icons.health_and_safety_outlined,
            title: 'Profil digestif',
            subtitle: 'Analyse de tes tolérances FODMAP',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DigestiveProfileScreen(),
                ),
              );
            },
          ),
          const Divider(),

          // Profil
          if (isConnected) ...[
            _buildSection('Profil'),
            _buildMenuItem(
              icon: Icons.person_outline,
              title: 'Informations personnelles',
              subtitle: 'Nom, prénom, email',
              onTap: () {
                _showProfileDialog();
              },
            ),
            const Divider(),
          ],

          // Préférences
          _buildSection('Préférences'),
          _buildMenuItem(
            icon: Icons.language,
            title: 'Langue',
            subtitle: 'Français',
            onTap: () {
              _showLanguageDialog();
            },
          ),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return _buildMenuItem(
                icon: themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                title: 'Thème',
                subtitle: themeProvider.isDarkMode ? 'Sombre' : 'Clair',
                onTap: () {
                  _showThemeDialog();
                },
              );
            },
          ),
          _buildMenuItem(
            icon: Icons.download,
            title: 'Exporter mon calendrier',
            subtitle: 'Télécharger un CSV pour votre médecin',
            onTap: () {
              _exportCalendarToCsv();
            },
          ),

          const Divider(),

          // Support
          _buildSection('Support'),
          _buildMenuItem(
            icon: Icons.help_outline,
            title: 'Aide',
            subtitle: 'FAQ et assistance',
            onTap: () {
              _showHelpDialog();
            },
          ),
          _buildMenuItem(
            icon: Icons.info_outline,
            title: 'À propos',
            subtitle: 'Version 1.0.0',
            onTap: () {
              _showAboutDialog();
            },
          ),

          const SizedBox(height: 20),

          // Bouton de déconnexion (si connecté)
          if (isConnected) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: OutlinedButton.icon(
                onPressed: () {
                  _showLogoutDialog();
                },
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text(
                  'Se déconnecter',
                  style: TextStyle(color: Colors.red),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Colors.red),
                ),
              ),
            ),
          ],

          const SizedBox(height: 20),
          
          // Logo centré en bas
          Center(
            child: Column(
              children: [
                Image.asset(
                  'Foadmap_Logo.png',
                  width: 80,
                  height: 80,
                ),
                const SizedBox(height: 12),
                Text(
                  'Foadmap Facile',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFFF6F00),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Gestion des FODMAPs',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSection(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Future<void> _connectWithGoogle() async {
    try {
      // Afficher un indicateur de chargement
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Se connecter avec Google
      final userCredential = await _authService.signInWithGoogle();

      // Fermer l'indicateur de chargement
      if (mounted) Navigator.pop(context);

      if (userCredential != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✓ Connecté avec Google'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        // L'utilisateur a annulé
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Connexion annulée'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      // Fermer l'indicateur de chargement
      if (mounted) Navigator.pop(context);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _connectWithApple() {
    // TODO: Implémenter la connexion Apple (nécessite sign_in_with_apple package)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Connexion Apple pas encore implémentée'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _showProfileDialog() {
    final user = _currentUser;
    if (user == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(user: user),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Langue'),
        children: [
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Langue : Français')),
              );
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Icon(Icons.check, color: Colors.blue),
                  SizedBox(width: 12),
                  Text('Français', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Language: English')),
              );
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  SizedBox(width: 36),
                  Text('English', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showThemeDialog() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choisir le thème'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.light_mode),
              title: const Text('Clair'),
              trailing: themeProvider.themeMode == ThemeMode.light 
                ? const Icon(Icons.check, color: Colors.blue)
                : null,
              onTap: () {
                themeProvider.setThemeMode(ThemeMode.light);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text('Sombre'),
              trailing: themeProvider.themeMode == ThemeMode.dark 
                ? const Icon(Icons.check, color: Colors.blue)
                : null,
              onTap: () {
                themeProvider.setThemeMode(ThemeMode.dark);
                Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Aide'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Comment utiliser l\'application ?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 12),
              Text('📱 Scanner : Scannez les codes-barres des produits'),
              SizedBox(height: 8),
              Text('📋 Produits : Consultez la liste des aliments FODMAP'),
              SizedBox(height: 8),
              Text('👤 Compte : Gérez vos préférences'),
              SizedBox(height: 16),
              Text(
                'Besoin d\'aide ?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text('Contactez nous a  l adresse noreply@kovaserv.fr pour toute question ou suggestion.'),
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

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('À propos'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'App Android FODMAP',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Version 1.0.0'),
            SizedBox(height: 16),
            Text(
              'Application d\'aide à la gestion du régime FODMAP pour les personnes atteintes du syndrome de l\'intestin irritable (SII).',
            ),
            SizedBox(height: 16),
            Text(
              'Fonctionnalités :',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text('• Scanner de codes-barres'),
            Text('• Analyse FODMAP automatique'),
            Text('• Base de 85+ aliments'),
            Text('• Suggestions de substitution'),
          ],
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

  Future<void> _showLogoutDialog() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              
              try {
                await _authService.signOut();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('✓ Déconnecté'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erreur: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Déconnecter'),
          ),
        ],
      ),
    );
  }

  Widget _buildTopFodmapCard() {
    final hasData = _topFodmap != '-' && _topFodmapCount > 0;
    final cardColor = hasData ? Colors.deepOrange : Colors.grey;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'FODMAP problématique',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('FODMAP problématique'),
                        content: const Text(
                          'Ce FODMAP est celui qui revient le plus souvent dans les produits '
                          'que vous avez scannés et pour lesquels vous avez signalé des symptômes. '
                          'Il peut être intéressant de limiter ce type de FODMAP dans votre alimentation.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Icon(
                  Icons.help_outline,
                  size: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: cardColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.warning_amber_rounded, color: cardColor),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _topFodmap,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: cardColor,
                      ),
                    ),
                    if (hasData)
                      Text(
                        '$_topFodmapCount occurrence${_topFodmapCount > 1 ? 's' : ''}',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopSymptomCard() {
    final hasData = _topSymptom != '-' && _topSymptomCount > 0;
    final cardColor = hasData ? Colors.red : Colors.grey;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Symptôme récurrent',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Symptôme récurrent'),
                        content: const Text(
                          'Ce symptôme est celui qui revient le plus souvent '
                          'dans vos enregistrements des 7 derniers jours. '
                          'Identifier vos symptômes récurrents peut aider à mieux cibler les aliments problématiques.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Icon(
                  Icons.help_outline,
                  size: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: cardColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.monitor_heart, color: cardColor),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _topSymptom,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: cardColor,
                      ),
                    ),
                    if (hasData)
                      Text(
                        '$_topSymptomCount fois en 7j',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _exportCalendarToCsv() async {
    try {
      // Afficher un indicateur de chargement
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Récupérer toutes les données
      final scans = await _dbService.getAllScans();
      final symptoms = await _dbService.getAllSymptomLogs();
      final feedbacks = await _dbService.getAllFeedbacks();

      // Créer un map des feedbacks par scanId
      final feedbacksByScan = {for (var fb in feedbacks) fb.scanHistoryId: fb};

      // Construire le CSV
      final StringBuffer csv = StringBuffer();
      
      // En-tête
      csv.writeln('Date,Heure,Moment,Type,Produit,Marque,Niveau FODMAP,FODMAPs détectés,Ballonnements,Douleurs,Gaz,Diarrhée,Irritabilité,Aucun symptôme');

      // Formater les dates
      final dateFormat = DateFormat('dd/MM/yyyy');
      final timeFormat = DateFormat('HH:mm');

      // Ajouter les scans
      for (final scan in scans) {
        final fb = feedbacksByScan[scan.id];
        final date = dateFormat.format(scan.dateCalendar);
        final time = timeFormat.format(scan.scannedAt);
        final moment = scan.dayPeriod ?? '';
        final product = _escapeCsv(scan.productName);
        final brand = _escapeCsv(scan.brand ?? '');
        final level = scan.riskLevel;
        
        // Parser fodmapTypes
        String fodmapTypesStr = '';
        if (scan.fodmapTypes != null && scan.fodmapTypes!.isNotEmpty) {
          try {
            final decoded = jsonDecode(scan.fodmapTypes!);
            if (decoded is List) {
              fodmapTypesStr = decoded.join('; ');
            }
          } catch (_) {
            fodmapTypesStr = scan.fodmapTypes!;
          }
        }
        
        // Symptômes du feedback
        final bloating = fb?.hasBloating == true ? 'Oui' : '';
        final pain = fb?.hasPain == true ? 'Oui' : '';
        final gas = fb?.hasGas == true ? 'Oui' : '';
        final noSymptom = fb?.hasNoSymptoms == true ? 'Oui' : '';

        csv.writeln('$date,$time,$moment,Scan,$product,$brand,$level,"$fodmapTypesStr",$bloating,$pain,$gas,,,$noSymptom');
      }

      // Ajouter les symptômes journaliers (non liés à un scan)
      for (final symptom in symptoms) {
        final date = dateFormat.format(symptom.date);
        final bloating = symptom.hasBloating ? 'Oui' : '';
        final pain = symptom.hasPain ? 'Oui' : '';
        final gas = symptom.hasGas ? 'Oui' : '';
        final diarrhea = symptom.hasDiarrhea ? 'Oui' : '';
        final irritability = symptom.hasIrritability ? 'Oui' : '';
        final noSymptom = symptom.hasNoSymptoms ? 'Oui' : '';

        // N'ajouter que si au moins un symptôme est coché
        if (symptom.hasAny) {
          csv.writeln('$date,,,Symptôme,,,,,,$bloating,$pain,$gas,$diarrhea,$irritability,$noSymptom');
        }
      }

      // Écrire le fichier
      final directory = await getTemporaryDirectory();
      final fileName = 'foadmap_suivi_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.csv';
      final file = File('${directory.path}/$fileName');
      await file.writeAsString(csv.toString(), encoding: utf8);

      // Fermer l'indicateur de chargement
      if (mounted) Navigator.pop(context);

      // Partager le fichier
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'Export Foadmap Facile',
        text: 'Voici mon suivi FODMAP exporté depuis Foadmap Facile.',
      );

    } catch (e) {
      // Fermer l'indicateur de chargement si ouvert
      if (mounted) Navigator.pop(context);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de l\'export: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _escapeCsv(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }
}
