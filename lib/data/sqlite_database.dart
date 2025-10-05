import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

/// Shared database provider ensuring all SQLite repositories use the same file.
class SQLiteDatabaseProvider {
  /// Creates a provider targeting the given [databaseName].
  SQLiteDatabaseProvider({String databaseName = 'pequelog.db'})
      : _databaseName = databaseName;

  final String _databaseName;
  Database? _database;

  /// Lazily opens the database, creating the required tables when missing.
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    final basePath = await getDatabasesPath();
    final dbPath = p.join(basePath, _databaseName);
    _database = await openDatabase(
      dbPath,
      version: 3,
      onCreate: (db, version) async {
        await _createBabiesTable(db);
        await _createBabyActionsTable(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            'ALTER TABLE babies ADD COLUMN birth_time_minutes INTEGER NOT NULL DEFAULT 0',
          );
        }
        if (oldVersion < 3) {
          await _createBabyActionsTable(db);
        }
      },
    );

    return _database!;
  }

  static Future<void> _createBabiesTable(Database db) async {
    await db.execute('''
      CREATE TABLE babies (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        birth_date INTEGER NOT NULL,
        birth_time_minutes INTEGER NOT NULL DEFAULT 0,
        sex TEXT NOT NULL,
        birth_length_cm REAL NOT NULL,
        birth_weight_kg REAL NOT NULL,
        photo_path TEXT
      )
    ''');
  }

  static Future<void> _createBabyActionsTable(Database db) async {
    await db.execute('''
      CREATE TABLE baby_actions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        baby_id INTEGER NOT NULL,
        kind TEXT NOT NULL,
        occurred_at INTEGER NOT NULL,
        notes TEXT,
        details TEXT,
        created_at INTEGER NOT NULL,
        FOREIGN KEY (baby_id) REFERENCES babies(id) ON DELETE CASCADE
      )
    ''');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_baby_actions_baby ON baby_actions(baby_id, occurred_at DESC)');
  }
}
