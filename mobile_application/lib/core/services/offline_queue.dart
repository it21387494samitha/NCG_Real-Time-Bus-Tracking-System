// core/services/offline_queue.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class OfflineQueueService {
  static const _databaseName = 'tracking.db';
  static const _databaseVersion = 1;
  static const _table = 'location_queue';
  
  Database? _database;
  
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
  
  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }
  
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_table (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL,
        timestamp INTEGER NOT NULL,
        bus_id TEXT NOT NULL,
        sent INTEGER DEFAULT 0
      )
    ''');
  }
  
  Future<int> addLocation({
    required double latitude,
    required double longitude,
    required String busId,
  }) async {
    final db = await database;
    return await db.insert(_table, {
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'bus_id': busId,
      'sent': 0,
    });
  }
  
  Future<List<Map<String, dynamic>>> getPendingLocations() async {
    final db = await database;
    return await db.query(
      _table,
      where: 'sent = ?',
      whereArgs: [0],
      limit: 50,
    );
  }
  
  Future<void> markAsSent(List<int> ids) async {
    if (ids.isEmpty) return;
    
    final db = await database;
    final placeholders = ids.map((_) => '?').join(',');
    await db.update(
      _table,
      {'sent': 1},
      where: 'id IN ($placeholders)',
      whereArgs: ids,
    );
    
    // Clean up old sent records (older than 7 days)
    await db.delete(
      _table,
      where: 'sent = ? AND timestamp < ?',
      whereArgs: [1, DateTime.now().subtract(const Duration(days: 7)).millisecondsSinceEpoch],
    );
  }
}