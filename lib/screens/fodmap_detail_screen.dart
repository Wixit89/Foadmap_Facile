import 'package:flutter/material.dart';
import '../services/digestive_profile_service.dart';
import '../services/database_service.dart';
import '../models/user_fodmap_preference.dart';

class FodmapDetailScreen extends StatefulWidget {
  final String fodmapType;
  final FodmapTypeProfile profile;
  final UserFodmapPreference? userPreference;
  final VoidCallback? onPreferenceChanged;

  const FodmapDetailScreen({
    super.key,
    required this.fodmapType,
    required this.profile,
    this.userPreference,
    this.onPreferenceChanged,
  });

  @override
  State<FodmapDetailScreen> createState() => _FodmapDetailScreenState();
}

class _FodmapDetailScreenState extends State<FodmapDetailScreen> {
  final DatabaseService _db = DatabaseService();

  Future<void> _showManualPreferenceDialog() async {
    String? selectedStatus = widget.userPreference?.manualStatus;
    
    final result = await showDialog<String>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Réglage manuel'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Comment tolérez-vous le ${widget.fodmapType.toLowerCase()} ?',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              _buildManualOption(
                value: 'tolerated',
                label: '🟢 Je le tolère bien',
                isSelected: selectedStatus == 'tolerated',
                onTap: () => setState(() => selectedStatus = 'tolerated'),
              ),
              _buildManualOption(
                value: 'caution',
                label: '🟠 Parfois problématique',
                isSelected: selectedStatus == 'caution',
                onTap: () => setState(() => selectedStatus = 'caution'),
              ),
              _buildManualOption(
                value: 'sensitive',
                label: '🔴 Je suis sensible',
                isSelected: selectedStatus == 'sensitive',
                onTap: () => setState(() => selectedStatus = 'sensitive'),
              ),
              const Divider(height: 24),
              _buildManualOption(
                value: null,
                label: '🤖 Mode automatique',
                subtitle: 'Basé sur vos scans',
                isSelected: selectedStatus == null,
                onTap: () => setState(() => selectedStatus = null),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, selectedStatus),
              child: const Text('Valider'),
            ),
          ],
        ),
      ),
    );

    if (result != 'cancelled' && result != null || result == null && widget.userPreference?.isManual == true) {
      if (result == null) {
        // Retour au mode auto
        await _db.resetUserPreference(widget.fodmapType);
      } else {
        // Enregistrer la préférence manuelle
        await _db.setUserPreference(
          UserFodmapPreference(
            fodmapType: widget.fodmapType,
            manualStatus: result,
            lastModified: DateTime.now(),
          ),
        );
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result == null 
                  ? '✓ Retour au mode automatique' 
                  : '✓ Préférence enregistrée',
            ),
            backgroundColor: Colors.green,
          ),
        );
        widget.onPreferenceChanged?.call();
        Navigator.pop(context, true);
      }
    }
  }

  Widget _buildManualOption({
    required String? value,
    required String label,
    String? subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[50] : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.blue[300]! : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: Colors.blue[600], size: 24),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final service = DigestiveProfileService();
    final description = service.getDescription(widget.fodmapType);
    final isManual = widget.userPreference?.isManual ?? false;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.fodmapType,
          style: const TextStyle(
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
            icon: Icon(
              isManual ? Icons.edit : Icons.edit_outlined,
              color: isManual ? Colors.purple[700] : null,
            ),
            tooltip: 'Réglage manuel',
            onPressed: _showManualPreferenceDialog,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showManualPreferenceDialog,
        icon: const Icon(Icons.tune),
        label: Text(isManual ? 'Modifier' : 'Personnaliser'),
        backgroundColor: isManual ? Colors.purple[600] : Colors.blue[600],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Badge manuel si actif
            if (isManual) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.purple[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.purple[200]!, width: 2),
                ),
                child: Row(
                  children: [
                    Icon(Icons.touch_app, color: Colors.purple[700], size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Réglage manuel actif - Vous avez personnalisé cette tolérance',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.purple[900],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Carte de statut
            _buildStatusCard(),

            const SizedBox(height: 24),

            // Description
            _buildSection(
              title: 'Qu\'est-ce que c\'est ?',
              icon: Icons.info_outline,
              child: Text(
                description,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Analyse personnelle
            _buildSection(
              title: 'D\'après ton historique',
              icon: Icons.analytics_outlined,
              child:               Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatRow(
                    icon: Icons.restaurant_outlined,
                    label: 'Expositions',
                    value: '${widget.profile.exposureCount}',
                  ),
                  if (widget.profile.exposureCount > 0) ...[
                    const SizedBox(height: 12),
                    _buildStatRow(
                      icon: Icons.warning_amber_outlined,
                      label: 'Avec symptômes',
                      value: '${widget.profile.symptomCount}',
                    ),
                    const SizedBox(height: 12),
                    _buildStatRow(
                      icon: Icons.percent,
                      label: 'Taux de réaction',
                      value: '${(widget.profile.symptomRate * 100).toStringAsFixed(0)}%',
                    ),
                  ],
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(widget.profile.color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Color(widget.profile.color).withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          widget.profile.statusEmoji,
                          style: const TextStyle(fontSize: 32),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.profile.statusLabel,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(widget.profile.color),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.profile.description,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Explication
            _buildSection(
              title: 'Que signifie ce statut ?',
              icon: Icons.help_outline,
              child: Text(
                widget.profile.explanation,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Recommandations
            _buildRecommendations(),

            const SizedBox(height: 30),

            // Avertissement
            _buildWarning(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(widget.profile.color).withOpacity(0.2),
            Color(widget.profile.color).withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Color(widget.profile.color).withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Text(
            widget.profile.statusEmoji,
            style: const TextStyle(fontSize: 64),
          ),
          const SizedBox(height: 16),
          Text(
            widget.profile.statusLabel,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(widget.profile.color),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Basé sur ${widget.profile.exposureCount} consommation${widget.profile.exposureCount > 1 ? 's' : ''}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 24, color: Colors.blue[700]),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey[200]!,
              width: 1,
            ),
          ),
          child: child,
        ),
      ],
    );
  }

  Widget _buildStatRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendations() {
    List<String> recommendations;
    
    switch (widget.profile.status) {
      case 'tolerated':
        recommendations = [
          'Continue de surveiller ta tolérance',
          'Note tes retours après consommation',
          'Les quantités consommées peuvent influencer la tolérance',
        ];
        break;
      case 'caution':
        recommendations = [
          'Fais attention aux quantités consommées',
          'Évite de combiner avec d\'autres FODMAPs',
          'Note systématiquement tes symptômes',
          'Considère une consultation avec un diététicien',
        ];
        break;
      case 'probable_sensitivity':
        recommendations = [
          'Limite ta consommation de ces aliments',
          'Consulte un professionnel de santé',
          'Tiens un journal alimentaire détaillé',
          'Recherche des alternatives pauvres en FODMAPs',
        ];
        break;
      default:
        recommendations = [
          'Continue de scanner tes aliments',
          'Ajoute tes retours après consommation',
          'Au moins 3 expositions sont nécessaires pour une analyse fiable',
        ];
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.tips_and_updates_outlined, size: 24, color: Colors.amber[700]),
            const SizedBox(width: 8),
            const Text(
              'Conseils',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...recommendations.map((rec) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 6),
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.blue[700],
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  rec,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildWarning() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.red[200]!,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.medical_services_outlined,
            color: Colors.red[700],
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Avertissement médical',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[900],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Cette analyse ne constitue pas un diagnostic médical. Pour tout symptôme persistant ou préoccupant, consultez un professionnel de santé.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.red[900],
                    height: 1.4,
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

