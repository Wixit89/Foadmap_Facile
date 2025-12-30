import 'package:flutter/material.dart';
import '../models/fodmap_feedback.dart';
import '../services/database_service.dart';

class FeedbackDialog extends StatefulWidget {
  final int scanHistoryId;
  final String productName;

  const FeedbackDialog({
    super.key,
    required this.scanHistoryId,
    required this.productName,
  });

  @override
  State<FeedbackDialog> createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  bool _hasBloating = false;
  bool _hasPain = false;
  bool _hasGas = false;
  bool _hasNoSymptoms = false;
  final TextEditingController _notesController = TextEditingController();
  final DatabaseService _db = DatabaseService();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveFeedback() async {
    final feedback = FodmapFeedback(
      scanHistoryId: widget.scanHistoryId,
      feedbackDate: DateTime.now(),
      hasBloating: _hasBloating,
      hasPain: _hasPain,
      hasGas: _hasGas,
      hasNoSymptoms: _hasNoSymptoms,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
    );

    await _db.addFeedback(feedback);
    
    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.feedback_outlined,
                      color: Colors.blue[700],
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Ton ressenti',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Text(
                'Comment te sens-tu après avoir consommé "${widget.productName}" ?',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 24),

              // Symptômes
              const Text(
                'Symptômes ressentis',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              _buildSymptomCheckbox(
                label: '🎈 Ballonnements',
                value: _hasBloating,
                onChanged: (val) {
                  setState(() {
                    _hasBloating = val ?? false;
                    if (val == true) _hasNoSymptoms = false;
                  });
                },
              ),

              _buildSymptomCheckbox(
                label: '😣 Douleurs abdominales',
                value: _hasPain,
                onChanged: (val) {
                  setState(() {
                    _hasPain = val ?? false;
                    if (val == true) _hasNoSymptoms = false;
                  });
                },
              ),

              _buildSymptomCheckbox(
                label: '💨 Gaz',
                value: _hasGas,
                onChanged: (val) {
                  setState(() {
                    _hasGas = val ?? false;
                    if (val == true) _hasNoSymptoms = false;
                  });
                },
              ),

              const Divider(height: 32),

              _buildSymptomCheckbox(
                label: '✅ Aucun symptôme',
                value: _hasNoSymptoms,
                onChanged: (val) {
                  setState(() {
                    _hasNoSymptoms = val ?? false;
                    if (val == true) {
                      _hasBloating = false;
                      _hasPain = false;
                      _hasGas = false;
                    }
                  });
                },
                highlightColor: Colors.green[50],
              ),

              const SizedBox(height: 24),

              // Notes (optionnel)
              const Text(
                'Notes (optionnel)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: _notesController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Ex: Symptômes apparus 2h après le repas...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),

              const SizedBox(height: 24),

              // Boutons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(
                      'Plus tard',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _saveFeedback,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Enregistrer',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue[700], size: 18),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Ces données améliorent ton profil digestif',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSymptomCheckbox({
    required String label,
    required bool value,
    required ValueChanged<bool?> onChanged,
    Color? highlightColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: value ? (highlightColor ?? Colors.blue[50]) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: value ? Colors.blue[300]! : Colors.grey[300]!,
          width: value ? 2 : 1,
        ),
      ),
      child: CheckboxListTile(
        title: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: value ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: Colors.blue[600],
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}



