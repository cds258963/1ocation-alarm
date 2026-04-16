import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/alarm_model.dart';

class AlarmDatabase {
  static final AlarmDatabase instance = AlarmDatabase._init();
  static Database? _database;

  AlarmDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'location_alarm.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE alarms (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL,
        address TEXT,
        radius REAL NOT NULL,
        trigger_on_enter INTEGER DEFAULT 1,
        trigger_on_exit INTEGER DEFAULT 0,
        start_time TEXT,
        end_time TEXT,
        week_days TEXT,
        notification_sound TEXT DEFAULT 'default',
        vibration INTEGER DEFAULT 1,
        repeat_count INTEGER DEFAULT 1,
        monitoring_mode INTEGER DEFAULT 1,
        is_enabled INTEGER DEFAULT 1,
        created_at TEXT NOT NULL,
        updated_at TEXT
      )
    ''');
  }

  Future<int> insert(AlarmModel alarm) async {
    final db = await database;
    return await db.insert('alarms', alarm.toMap());
  }

  Future<List<AlarmModel>> getAll() async {
    final db = await database;
    final maps = await db.query('alarms', orderBy: 'created_at DESC');
    return maps.map((map) => AlarmModel.fromMap(map)).toList();
  }

  Future<AlarmModel?> getById(String id) async {
    final db = await database;
    final maps = await db.query(
      'alarms',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return AlarmModel.fromMap(maps.first);
    }
    return null;
  }

  Future<int> update(AlarmModel alarm) async {
    final db = await database;
    return await db.update(
      'alarms',
      alarm.toMap(),
      where: 'id = ?',
      whereArgs: [alarm.id],
    );
  }

  Future<int> delete(String id) async {
    final db = await database;
    return await db.delete(
      'alarms',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
