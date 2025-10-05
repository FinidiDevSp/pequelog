import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:pequelog/domain/babies/entities/baby.dart';
import 'package:pequelog/domain/babies/entities/baby_sex.dart';
import 'package:pequelog/domain/babies/repositories/baby_repository.dart';

/// SQLite-backed implementation of [BabyRepository].
class SQLiteBabyRepository implements BabyRepository {
  /// Creates a repository storing data inside the local SQLite database.
  SQLiteBabyRepository({String databaseName = 'pequelog.db'})
      : _databaseName = databaseName;

  final String _databaseName;
  Database? _database;

  Future<Database> get _db async {
    if (_database != null) {
      return _database!;
    }

    final basePath = await getDatabasesPath();
    final dbPath = p.join(basePath, _databaseName);
    _database = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE babies (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            birth_date INTEGER NOT NULL,
            sex TEXT NOT NULL,
            birth_length_cm REAL NOT NULL,
            birth_weight_kg REAL NOT NULL,
            photo_path TEXT
          )
        ''');
      },
    );
    return _database!;
  }

  @override
  Future<List<Baby>> fetchBabies() async {
    final database = await _db;
    final rows = await database.query('babies', orderBy: 'id ASC');
    return rows.map(_mapRow).toList(growable: false);
  }

  Baby _mapRow(Map<String, Object?> row) {
    return Baby(
      id: row['id'] as int,
      name: row['name'] as String,
      birthDate: DateTime.fromMillisecondsSinceEpoch(row['birth_date'] as int),
      sex: babySexFromValue(row['sex'] as String),
      birthLengthCm: (row['birth_length_cm'] as num).toDouble(),
      birthWeightKg: (row['birth_weight_kg'] as num).toDouble(),
      photoPath: row['photo_path'] as String?,
    );
  }
}
