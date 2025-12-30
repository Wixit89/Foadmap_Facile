import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import '../models/scan_history.dart';
import '../models/fodmap_feedback.dart';
import '../models/user_fodmap_preference.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    try {
      _database = await _initDatabase();
      return _database!;
    } catch (e) {
      debugPrint('Erreur lors de l\'initialisation de la base de données: $e');
      rethrow;
    }
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'scan_history.db');
    
    return await openDatabase(
      path,
      version: 3,
      onCreate: (Database db, int version) async {
        // Table scan_history
        await db.execute('''
          CREATE TABLE scan_history(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            barcode TEXT NOT NULL,
            productName TEXT NOT NULL,
            brand TEXT,
            imageUrl TEXT,
            scannedAt TEXT NOT NULL,
            ingredientCount INTEGER DEFAULT 0,
            highFodmapCount INTEGER DEFAULT 0,
            moderateFodmapCount INTEGER DEFAULT 0,
            lowFodmapCount INTEGER DEFAULT 0,
            fodmapTypes TEXT,
            hasFeedback INTEGER DEFAULT 0
          )
        ''');

        // Table fodmap_feedback
        await db.execute('''
          CREATE TABLE fodmap_feedback(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            scanHistoryId INTEGER NOT NULL,
            feedbackDate TEXT NOT NULL,
            hasBloating INTEGER DEFAULT 0,
            hasPain INTEGER DEFAULT 0,
            hasGas INTEGER DEFAULT 0,
            hasNoSymptoms INTEGER DEFAULT 0,
            notes TEXT,
            FOREIGN KEY (scanHistoryId) REFERENCES scan_history (id) ON DELETE CASCADE
          )
        ''');
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if (oldVersion < 2) {
          // Migration de v1 à v2
          await db.execute('ALTER TABLE scan_history ADD COLUMN fodmapTypes TEXT');
          await db.execute('ALTER TABLE scan_history ADD COLUMN hasFeedback INTEGER DEFAULT 0');
          
          // Créer la table feedback
          await db.execute('''
            CREATE TABLE fodmap_feedback(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              scanHistoryId INTEGER NOT NULL,
              feedbackDate TEXT NOT NULL,
              hasBloating INTEGER DEFAULT 0,
              hasPain INTEGER DEFAULT 0,
              hasGas INTEGER DEFAULT 0,
              hasNoSymptoms INTEGER DEFAULT 0,
              notes TEXT,
              FOREIGN KEY (scanHistoryId) REFERENCES scan_history (id) ON DELETE CASCADE
            )
          ''');
        }
        if (oldVersion < 3) {
          // Migration de v2 à v3 - Préférences manuelles
          await db.execute('''
            CREATE TABLE user_fodmap_preferences(
              fodmapType TEXT PRIMARY KEY,
              manualStatus TEXT,
              lastModified TEXT
            )
          ''');
        }
      },
    );
  }

  // Ajouter un scan à l'historique
  Future<int> addScan(ScanHistory scan) async {
    final db = await database;
    
    // Vérifier si le nombre de scans dépasse 100
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM scan_history')
    );
    
    // Si on a déjà 100 scans, supprimer le plus ancien
    if (count != null && count >= 100) {
      await db.delete(
        'scan_history',
        where: 'id = (SELECT id FROM scan_history ORDER BY scannedAt ASC LIMIT 1)',
      );
    }
    
    return await db.insert('scan_history', scan.toMap());
  }

  // Récupérer tous les scans (du plus récent au plus ancien)
  Future<List<ScanHistory>> getAllScans() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'scan_history',
        orderBy: 'scannedAt DESC',
      );
      
      return List.generate(maps.length, (i) {
        return ScanHistory.fromMap(maps[i]);
      });
    } catch (e) {
      debugPrint('Erreur lors de la récupération des scans: $e');
      return [];
    }
  }

  // Supprimer un scan
  Future<int> deleteScan(int id) async {
    final db = await database;
    return await db.delete(
      'scan_history',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Supprimer tout l'historique
  Future<int> clearHistory() async {
    final db = await database;
    return await db.delete('scan_history');
  }

  // Récupérer le nombre total de scans
  Future<int> getScanCount() async {
    final db = await database;
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM scan_history')
    );
    return count ?? 0;
  }

  // Rechercher dans l'historique
  Future<List<ScanHistory>> searchScans(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'scan_history',
      where: 'productName LIKE ? OR brand LIKE ? OR barcode LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
      orderBy: 'scannedAt DESC',
    );
    
    return List.generate(maps.length, (i) {
      return ScanHistory.fromMap(maps[i]);
    });
  }

  // ============ FODMAP FEEDBACK ============

  // Ajouter un feedback
  Future<int> addFeedback(FodmapFeedback feedback) async {
    final db = await database;
    final feedbackId = await db.insert('fodmap_feedback', feedback.toMap());
    
    // Mettre à jour le flag hasFeedback du scan
    await db.update(
      'scan_history',
      {'hasFeedback': 1},
      where: 'id = ?',
      whereArgs: [feedback.scanHistoryId],
    );
    
    return feedbackId;
  }

  // Récupérer le feedback d'un scan
  Future<FodmapFeedback?> getFeedbackForScan(int scanId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'fodmap_feedback',
      where: 'scanHistoryId = ?',
      whereArgs: [scanId],
      limit: 1,
    );
    
    if (maps.isEmpty) return null;
    return FodmapFeedback.fromMap(maps.first);
  }

  // Récupérer tous les feedbacks
  Future<List<FodmapFeedback>> getAllFeedbacks() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'fodmap_feedback',
        orderBy: 'feedbackDate DESC',
      );
      
      return List.generate(maps.length, (i) {
        return FodmapFeedback.fromMap(maps[i]);
      });
    } catch (e) {
      debugPrint('Erreur lors de la récupération des feedbacks: $e');
      return [];
    }
  }

  // Mettre à jour un feedback
  Future<int> updateFeedback(FodmapFeedback feedback) async {
    final db = await database;
    return await db.update(
      'fodmap_feedback',
      feedback.toMap(),
      where: 'id = ?',
      whereArgs: [feedback.id],
    );
  }

  // Supprimer un feedback
  Future<int> deleteFeedback(int id) async {
    final db = await database;
    return await db.delete(
      'fodmap_feedback',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Mettre à jour le scan history (pour ajouter fodmapTypes)
  Future<int> updateScan(ScanHistory scan) async {
    final db = await database;
    return await db.update(
      'scan_history',
      scan.toMap(),
      where: 'id = ?',
      whereArgs: [scan.id],
    );
  }

  // ============ USER FODMAP PREFERENCES ============

  // Définir une préférence manuelle
  Future<void> setUserPreference(UserFodmapPreference preference) async {
    final db = await database;
    await db.insert(
      'user_fodmap_preferences',
      preference.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Récupérer une préférence
  Future<UserFodmapPreference?> getUserPreference(String fodmapType) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'user_fodmap_preferences',
      where: 'fodmapType = ?',
      whereArgs: [fodmapType],
      limit: 1,
    );
    
    if (maps.isEmpty) return null;
    return UserFodmapPreference.fromMap(maps.first);
  }

  // Récupérer toutes les préférences
  Future<Map<String, UserFodmapPreference>> getAllUserPreferences() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query('user_fodmap_preferences');
      
      Map<String, UserFodmapPreference> preferences = {};
      for (var map in maps) {
        final pref = UserFodmapPreference.fromMap(map);
        preferences[pref.fodmapType] = pref;
      }
      return preferences;
    } catch (e) {
      debugPrint('Erreur lors de la récupération des préférences: $e');
      return {};
    }
  }

  // Réinitialiser une préférence (retour au mode auto)
  Future<void> resetUserPreference(String fodmapType) async {
    final db = await database;
    await db.delete(
      'user_fodmap_preferences',
      where: 'fodmapType = ?',
      whereArgs: [fodmapType],
    );
  }
}

