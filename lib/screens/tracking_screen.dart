import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/database_service.dart';
import '../models/scan_history.dart';
import '../models/symptom_log.dart';
import '../models/fodmap_feedback.dart';
import 'scanner_screen.dart';
import 'product_detail_screen.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  final DatabaseService _dbService = DatabaseService();
  final DateFormat _monthFormat = DateFormat('MMMM yyyy', 'fr_FR');
  final DateFormat _dayKeyFormat = DateFormat('yyyy-MM-dd');

  DateTime _focusedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime _selectedDate = DateTime.now();
  Map<String, List<ScanHistory>> _scansByDate = {};
  Set<String> _scanDays = {};
  Map<String, SymptomLog> _symptomsByDate = {};
  Set<String> _symptomDays = {};
  List<FodmapFeedback> _feedbacks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  String _formatDayKey(DateTime date) => _dayKeyFormat.format(date);

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);
    final history = await _dbService.getAllScans();
    final symptoms = await _dbService.getAllSymptomLogs();
    final feedbacks = await _dbService.getAllFeedbacks();

    final Map<String, List<ScanHistory>> grouped = {};
    for (final scan in history) {
      final dateOnly = DateTime(scan.dateCalendar.year, scan.dateCalendar.month, scan.dateCalendar.day);
      final key = _formatDayKey(dateOnly);
      grouped.putIfAbsent(key, () => []).add(scan);
    }

    final Map<String, SymptomLog> symptomsGrouped = {
      for (final s in symptoms)
        _formatDayKey(DateTime(s.date.year, s.date.month, s.date.day)): s,
    };

    setState(() {
      _scansByDate = grouped;
      _scanDays = grouped.keys.toSet();
      _symptomsByDate = symptomsGrouped;
      _symptomDays = symptomsGrouped.keys.toSet();
      _feedbacks = feedbacks;
      _isLoading = false;
    });
  }

  void _goToPreviousMonth() {
    final previous = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
    setState(() {
      _focusedMonth = DateTime(previous.year, previous.month);
      _selectedDate = DateTime(previous.year, previous.month, 1);
    });
  }

  void _goToNextMonth() {
    final next = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
    setState(() {
      _focusedMonth = DateTime(next.year, next.month);
      _selectedDate = DateTime(next.year, next.month, 1);
    });
  }

  Future<void> _startScan() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ScannerScreen(showBackButton: true)),
    );
    // Revenir au mois courant pour voir le nouveau marqueur
    _focusedMonth = DateTime(DateTime.now().year, DateTime.now().month);
    _selectedDate = DateTime.now();
    await _loadHistory();
  }

  Future<void> _openSymptomsDialog() async {
    final key = _formatDayKey(_selectedDate);
    final existing = _symptomsByDate[key];

    bool bloating = existing?.hasBloating == true;
    bool pain = existing?.hasPain == true;
    bool gas = existing?.hasGas == true;
    bool diarrhea = existing?.hasDiarrhea == true;
    bool irritability = existing?.hasIrritability == true;
    bool noSymptoms = existing?.hasNoSymptoms == true;

    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text('Symptômes du ${DateFormat('dd/MM/yyyy').format(_selectedDate)}'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CheckboxListTile(
                    value: bloating,
                    onChanged: (v) => setStateDialog(() => bloating = v ?? false),
                    title: const Text('Ballonnements'),
                  ),
                  CheckboxListTile(
                    value: pain,
                    onChanged: (v) => setStateDialog(() => pain = v ?? false),
                    title: const Text('Douleurs abdominales'),
                  ),
                  CheckboxListTile(
                    value: gas,
                    onChanged: (v) => setStateDialog(() => gas = v ?? false),
                    title: const Text('Gaz'),
                  ),
                  CheckboxListTile(
                    value: diarrhea,
                    onChanged: (v) => setStateDialog(() => diarrhea = v ?? false),
                    title: const Text('Diarrhée'),
                  ),
                  CheckboxListTile(
                    value: irritability,
                    onChanged: (v) => setStateDialog(() => irritability = v ?? false),
                    title: const Text('Irritabilité'),
                  ),
                  const Divider(height: 16),
                  CheckboxListTile(
                    value: noSymptoms,
                    onChanged: (v) {
                      setStateDialog(() {
                        noSymptoms = v ?? false;
                        if (noSymptoms) {
                          bloating = false;
                          pain = false;
                          gas = false;
                          diarrhea = false;
                          irritability = false;
                        }
                      });
                    },
                    title: const Text('Aucun symptôme'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Annuler'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final log = SymptomLog(
                      date: DateTime(
                        _selectedDate.year,
                        _selectedDate.month,
                        _selectedDate.day,
                      ),
                      hasBloating: bloating,
                      hasPain: pain,
                      hasGas: gas,
                      hasDiarrhea: diarrhea,
                      hasIrritability: irritability,
                      hasNoSymptoms: noSymptoms,
                    );
                    try {
                      await _dbService.replaceSymptomLog(log);
                      await _loadHistory();
                      if (mounted) Navigator.pop(context);
                      if (mounted) {
                        ScaffoldMessenger.of(this.context).showSnackBar(
                          const SnackBar(content: Text('Symptômes enregistrés')),
                        );
                      }
                    } catch (e) {
                      if (mounted) Navigator.pop(context);
                      if (mounted) {
                        ScaffoldMessenger.of(this.context).showSnackBar(
                          SnackBar(content: Text('Erreur lors de l\'enregistrement: $e')),
                        );
                      }
                    }
                  },
                  child: const Text('Enregistrer'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  List<Widget> _buildDayHeaders() {
    const labels = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
    return labels
        .map(
          (label) => Center(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
        )
        .toList();
  }

  List<Widget> _buildDayCells() {
    final List<Widget> cells = [];
    final daysInMonth = DateUtils.getDaysInMonth(_focusedMonth.year, _focusedMonth.month);
    final firstWeekday = DateTime(_focusedMonth.year, _focusedMonth.month, 1).weekday; // 1 = Lundi
    final leadingEmpty = firstWeekday - 1;

    // Cases vides avant le 1er du mois
    for (int i = 0; i < leadingEmpty; i++) {
      cells.add(const SizedBox.shrink());
    }

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_focusedMonth.year, _focusedMonth.month, day);
      final key = _formatDayKey(date);
      final hasScan = _scanDays.contains(key);
      final hasSymptoms = _symptomDays.contains(key);
      final SymptomLog logSafe = _symptomsByDate[key] ??
          SymptomLog(
            date: date,
            hasBloating: false,
            hasPain: false,
            hasGas: false,
            hasDiarrhea: false,
            hasIrritability: false,
            hasNoSymptoms: false,
          );
      final bool hasNoSymptoms = logSafe.hasNoSymptoms;
      // Symptômes réels (manuels ou via produits)
      final bool hasRealSymptoms = logSafe.hasBloating || logSafe.hasPain || logSafe.hasGas || logSafe.hasDiarrhea || logSafe.hasIrritability;
      // Pastille verte si "aucun symptôme" coché et pas d'autres symptômes
      final bool showGreenDot = hasSymptoms && hasNoSymptoms && !hasRealSymptoms;
      // Pastille rouge si au moins un symptôme réel
      final bool showRedDot = hasSymptoms && hasRealSymptoms;
      final isSelected = DateUtils.isSameDay(date, _selectedDate);
      final isToday = DateUtils.isSameDay(date, DateTime.now());

      cells.add(
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedDate = date;
            });
          },
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFFFF3E0) : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected ? const Color(0xFFFF9800) : Colors.grey[300]!,
                width: isSelected ? 1.4 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: const Color(0xFFFF9800).withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Stack(
              children: [
                Center(
                  child: Text(
                    '$day',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isToday ? const Color(0xFFFF6F00) : Colors.grey[800],
                    ),
                  ),
                ),
                if (showGreenDot || showRedDot)
                  Positioned(
                    top: 6,
                    right: 8,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: showGreenDot ? const Color(0xFF4CAF50) : Colors.red,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: (showGreenDot ? const Color(0xFF4CAF50) : Colors.red).withOpacity(0.4),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                  ),
                if (hasScan)
                  Positioned(
                    bottom: 6,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: showGreenDot ? const Color(0xFF4CAF50) : const Color(0xFFFF9800),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: (showGreenDot ? const Color(0xFF4CAF50) : const Color(0xFFFF9800)).withOpacity(0.4),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    return cells;
  }

  @override
  Widget build(BuildContext context) {
    final scansForSelectedDay = _scansByDate[_formatDayKey(_selectedDate)] ?? [];
    final symptomsForSelectedDay = _symptomsByDate[_formatDayKey(_selectedDate)];
    final symptomProducts = _getSymptomProductsForDate(_selectedDate);

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
        title: const Text(
          'Suivi',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            tooltip: 'Scanner un produit',
            onPressed: _startScan,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Ajouter des symptômes',
            onPressed: _openSymptomsDialog,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.chevron_left),
                              onPressed: _goToPreviousMonth,
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  _monthFormat.format(_focusedMonth),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.chevron_right),
                              onPressed: _goToNextMonth,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        GridView.count(
                          crossAxisCount: 7,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          childAspectRatio: 1.1,
                          children: [
                            ..._buildDayHeaders(),
                            ..._buildDayCells(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Symptômes du jour en premier
                  const SizedBox(height: 16),
                  const Text(
                    'Symptômes du jour',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  () {
                    // Afficher les symptômes manuels OU ceux liés aux produits
                    final hasSymptomChips = symptomsForSelectedDay != null && symptomsForSelectedDay.hasAny;
                    if (!hasSymptomChips) {
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.sentiment_satisfied_alt, color: Colors.grey[500]),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Aucun symptôme enregistré',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ),
                            TextButton(
                              onPressed: _openSymptomsDialog,
                              child: const Text('Ajouter'),
                            ),
                          ],
                        ),
                      );
                    }
                    return Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        if (symptomsForSelectedDay.hasBloating)
                          _buildSymptomChip('Ballonnements', count: symptomProducts['Ballonnements']?.length ?? 0),
                        if (symptomsForSelectedDay.hasPain)
                          _buildSymptomChip('Douleurs abdominales', count: symptomProducts['Douleurs abdominales']?.length ?? 0),
                        if (symptomsForSelectedDay.hasGas)
                          _buildSymptomChip('Gaz', count: symptomProducts['Gaz']?.length ?? 0),
                        if (symptomsForSelectedDay.hasDiarrhea)
                          _buildSymptomChip('Diarrhée', count: symptomProducts['Diarrhée']?.length ?? 0),
                        if (symptomsForSelectedDay.hasIrritability)
                          _buildSymptomChip('Irritabilité', count: symptomProducts['Irritabilité']?.length ?? 0),
                        if (symptomsForSelectedDay.hasNoSymptoms)
                          _buildSymptomChip('Aucun symptôme', count: 1, color: Colors.green),
                        // Bouton pour modifier
                        TextButton.icon(
                          onPressed: _openSymptomsDialog,
                          icon: const Icon(Icons.edit, size: 16),
                          label: const Text('Modifier'),
                        ),
                      ],
                    );
                  }(),
                  // Scans du jour ensuite
                  const SizedBox(height: 16),
                  Text(
                    'Scans du ${DateFormat('dd/MM/yyyy').format(_selectedDate)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (scansForSelectedDay.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.event_available, color: Colors.grey[500]),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Aucun scan ce jour-là',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: scansForSelectedDay.length,
                        itemBuilder: (context, index) {
                          final scan = scansForSelectedDay[index];
                          return Dismissible(
                            key: ValueKey(scan.id ?? '${scan.barcode}_${scan.scannedAt.toIso8601String()}'),
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: const Icon(Icons.delete, color: Colors.white),
                            ),
                            secondaryBackground: Container(
                              color: Colors.blue,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: const Icon(Icons.edit_calendar, color: Colors.white),
                            ),
                            confirmDismiss: (direction) async {
                              if (direction == DismissDirection.startToEnd) {
                                if (scan.id == null) return false;
                                await _dbService.deleteScan(scan.id!);
                                await _loadHistory();
                                return true;
                              } else {
                                // Move
                                await _moveScanToDate(scan);
                                return false;
                              }
                            },
                            child: Card(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                minVerticalPadding: 8,
                                isThreeLine: true,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ProductDetailScreen(
                                        barcode: scan.barcode,
                                        scanHistoryId: scan.id,
                                      ),
                                    ),
                                  );
                                },
                                leading: CircleAvatar(
                                  backgroundColor: const Color(0xFFFFF3E0),
                                  foregroundColor: const Color(0xFFFF6F00),
                                  child: Text(
                                    scan.productName.isNotEmpty ? scan.productName[0].toUpperCase() : '?',
                                    style: const TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                ),
                                title: Text(
                                  scan.productName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  scan.brand ?? 'Marque inconnue',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: SizedBox(
                                  height: 78,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        DateFormat('HH:mm').format(scan.scannedAt),
                                        style: const TextStyle(fontWeight: FontWeight.w600),
                                      ),
                                      if (scan.dayPeriod != null && scan.dayPeriod!.isNotEmpty)
                                        Text(
                                          scan.dayPeriod!,
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey[600],
                                            fontStyle: FontStyle.italic,
                                          ),
                                        )
                                      else
                                        const SizedBox(height: 12),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: Color(scan.riskColor).withOpacity(0.12),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          scan.riskLevel,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: Color(scan.riskColor),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  Map<String, List<ScanHistory>> _getSymptomProductsForDate(DateTime date) {
    final String key = _formatDayKey(date);
    final List<ScanHistory> scans = _scansByDate[key] ?? [];
    if (scans.isEmpty) return {};

    // Associer feedbacks par scanId
    final Map<int, FodmapFeedback> feedbackByScan = {
      for (final fb in _feedbacks) fb.scanHistoryId: fb
    };

    final Map<String, List<ScanHistory>> result = {
      'Ballonnements': [],
      'Douleurs abdominales': [],
      'Gaz': [],
      'Diarrhée': [],
      'Irritabilité': [],
    };

    for (final scan in scans) {
      final fb = feedbackByScan[scan.id ?? -1];
      if (fb == null) continue;
      if (fb.hasBloating) result['Ballonnements']!.add(scan);
      if (fb.hasPain) result['Douleurs abdominales']!.add(scan);
      if (fb.hasGas) result['Gaz']!.add(scan);
      // Diarrhée / Irritabilité non gérés dans feedback, restent vides
    }
    return result;
  }

  void _showSymptomProducts(String label, List<ScanHistory> items) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '$label (${items.length})',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (items.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text('Aucun produit pour ce symptôme.'),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final scan = items[index];
                      return ListTile(
                        title: Text(
                          scan.productName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          scan.brand ?? 'Marque inconnue',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Text(
                          DateFormat('HH:mm').format(scan.scannedAt),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductDetailScreen(
                                barcode: scan.barcode,
                                scanHistoryId: scan.id,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _moveScanToDate(ScanHistory scan) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: scan.dateCalendar,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      locale: const Locale('fr', 'FR'),
    );
    if (pickedDate == null) return;

    final period = await showDialog<String>(
      context: context,
      builder: (context) {
        String? selected = scan.dayPeriod ?? '';
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Moment de la journée'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<String>(
                    value: 'Matin',
                    groupValue: selected,
                    onChanged: (v) => setStateDialog(() => selected = v),
                    title: const Text('Matin'),
                  ),
                  RadioListTile<String>(
                    value: 'Midi',
                    groupValue: selected,
                    onChanged: (v) => setStateDialog(() => selected = v),
                    title: const Text('Midi'),
                  ),
                  RadioListTile<String>(
                    value: 'Soir',
                    groupValue: selected,
                    onChanged: (v) => setStateDialog(() => selected = v),
                    title: const Text('Soir'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, null),
                  child: const Text('Annuler'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, selected ?? ''),
                  child: const Text('Valider'),
                ),
              ],
            );
          },
        );
      },
    );

    if (period == null) return;

    final updated = ScanHistory(
      id: scan.id,
      barcode: scan.barcode,
      productName: scan.productName,
      brand: scan.brand,
      imageUrl: scan.imageUrl,
      scannedAt: scan.scannedAt,
      dateCalendar: DateTime(pickedDate.year, pickedDate.month, pickedDate.day),
      dayPeriod: period,
      ingredientCount: scan.ingredientCount,
      highFodmapCount: scan.highFodmapCount,
      moderateFodmapCount: scan.moderateFodmapCount,
      lowFodmapCount: scan.lowFodmapCount,
      fodmapTypes: scan.fodmapTypes,
      hasFeedback: scan.hasFeedback,
    );

    await _dbService.updateScan(updated);

    // Si ce scan a un feedback, propager les symptômes sur la nouvelle date
    if (scan.id != null) {
      final fb = await _dbService.getFeedbackForScan(scan.id!);
      if (fb != null) {
        final log = SymptomLog(
          date: updated.dateCalendar,
          hasBloating: fb.hasBloating,
          hasPain: fb.hasPain,
          hasGas: fb.hasGas,
          hasDiarrhea: false,
          hasIrritability: false,
          hasNoSymptoms: !(fb.hasBloating || fb.hasPain || fb.hasGas),
        );
        await _dbService.upsertSymptomLog(log);
      }
    }

    await _loadHistory();
  }

  Widget _buildSymptomChip(String label, {int count = 0, Color color = Colors.red}) {
    return InkWell(
      onTap: count > 0
          ? () => _showSymptomProducts(label, _getSymptomProductsForDate(_selectedDate)[label] ?? [])
          : null,
      child: Chip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label),
            if (count > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ],
        ),
        backgroundColor: color.withOpacity(0.1),
        labelStyle: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: color),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}

