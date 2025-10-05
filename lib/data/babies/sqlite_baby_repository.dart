import 'package:sqflite/sqflite.dart';
import 'package:pequelog/data/sqlite_database.dart';
import 'package:pequelog/domain/babies/entities/baby.dart';
import 'package:pequelog/domain/babies/entities/baby_draft.dart';
import 'package:pequelog/domain/babies/entities/baby_sex.dart';
import 'package:pequelog/domain/babies/repositories/baby_repository.dart';

/// SQLite-backed implementation of [BabyRepository].
class SQLiteBabyRepository implements BabyRepository {
  /// Creates a repository storing data inside the local SQLite database.
  SQLiteBabyRepository({SQLiteDatabaseProvider? database})
      : _databaseProvider = database ?? SQLiteDatabaseProvider();

  final SQLiteDatabaseProvider _databaseProvider;

  Future<Database> get _db async => _databaseProvider.database;

  @override
  Future<List<Baby>> fetchBabies() async {
    final database = await _db;
    final rows = await database.query('babies', orderBy: 'id ASC');
    return rows.map(_mapRow).toList(growable: false);
  }

  @override
  Future<Baby> createBaby(BabyDraft draft) async {
    final database = await _db;

    final birthDate = draft.birthDateTime;
    final dateOnly = birthDate.isUtc
        ? DateTime.utc(birthDate.year, birthDate.month, birthDate.day)
        : DateTime(birthDate.year, birthDate.month, birthDate.day);
    final minutes = (birthDate.hour * 60) + birthDate.minute;

    final id = await database.insert('babies', {
      'name': draft.name,
      'birth_date': dateOnly.millisecondsSinceEpoch,
      'birth_time_minutes': minutes,
      'sex': draft.sex.value,
      'birth_length_cm': draft.birthLengthCm,
      'birth_weight_kg': draft.birthWeightKg,
      'photo_path': draft.photoPath,
    });

    final rows = await database.query(
      'babies',
      where: 'id = ?',
      whereArgs: <Object>[id],
      limit: 1,
    );

    return _mapRow(rows.first);
  }

  @override
  Future<Baby> updateBaby(int id, BabyDraft draft) async {
    final database = await _db;

    final birthDate = draft.birthDateTime;
    final dateOnly = birthDate.isUtc
        ? DateTime.utc(birthDate.year, birthDate.month, birthDate.day)
        : DateTime(birthDate.year, birthDate.month, birthDate.day);
    final minutes = (birthDate.hour * 60) + birthDate.minute;

    final rowsUpdated = await database.update(
      'babies',
      {
        'name': draft.name,
        'birth_date': dateOnly.millisecondsSinceEpoch,
        'birth_time_minutes': minutes,
        'sex': draft.sex.value,
        'birth_length_cm': draft.birthLengthCm,
        'birth_weight_kg': draft.birthWeightKg,
        'photo_path': draft.photoPath,
      },
      where: 'id = ?',
      whereArgs: <Object>[id],
    );

    if (rowsUpdated == 0) {
      throw StateError('Baby with id $id not found');
    }

    final rows = await database.query(
      'babies',
      where: 'id = ?',
      whereArgs: <Object>[id],
      limit: 1,
    );

    return _mapRow(rows.first);
  }

  Baby _mapRow(Map<String, Object?> row) {
    final dateMs = row['birth_date'] as int;
    final date = DateTime.fromMillisecondsSinceEpoch(dateMs);
    final minutes = (row['birth_time_minutes'] as int?) ?? 0;
    final birthMoment = date.add(Duration(minutes: minutes));

    return Baby(
      id: row['id'] as int,
      name: row['name'] as String,
      birthDateTime: birthMoment,
      sex: babySexFromValue(row['sex'] as String),
      birthLengthCm: (row['birth_length_cm'] as num).toDouble(),
      birthWeightKg: (row['birth_weight_kg'] as num).toDouble(),
      photoPath: row['photo_path'] as String?,
    );
  }
}
