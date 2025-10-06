import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:pequelog/data/sqlite_database.dart';
import 'package:pequelog/domain/baby_actions/entities/baby_action.dart';
import 'package:pequelog/domain/baby_actions/entities/baby_action_draft.dart';
import 'package:pequelog/domain/baby_actions/entities/baby_action_kind.dart';
import 'package:pequelog/domain/baby_actions/repositories/baby_action_repository.dart';

/// SQLite-backed implementation of [BabyActionRepository].
class SQLiteBabyActionRepository implements BabyActionRepository {
  /// Creates a repository using the shared [SQLiteDatabaseProvider].
  SQLiteBabyActionRepository({SQLiteDatabaseProvider? database})
      : _databaseProvider = database ?? SQLiteDatabaseProvider();

  final SQLiteDatabaseProvider _databaseProvider;

  Future<Database> get _db async => _databaseProvider.database;

  @override
  Future<List<BabyAction>> fetchRecentActions(int babyId, {int limit = 10}) async {
    final database = await _db;
    final rows = await database.query(
      'baby_actions',
      where: 'baby_id = ?',
      whereArgs: <Object>[babyId],
      orderBy: 'occurred_at DESC, id DESC',
      limit: limit,
    );
    return rows.map(_mapRow).toList(growable: false);
  }

  @override
  Future<BabyAction> logAction(BabyActionDraft draft) async {
    final database = await _db;
    final id = await database.insert('baby_actions', {
      'baby_id': draft.babyId,
      'kind': draft.kind.name,
      'occurred_at': draft.occurredAt.millisecondsSinceEpoch,
      'notes': draft.notes,
      'details': jsonEncode(draft.details),
      'created_at': DateTime.now().millisecondsSinceEpoch,
    });

    final rows = await database.query(
      'baby_actions',
      where: 'id = ?',
      whereArgs: <Object>[id],
      limit: 1,
    );

    return _mapRow(rows.first);
  }

  @override
  Future<BabyAction> updateAction({
    required int id,
    required DateTime occurredAt,
    String? notes,
    required Map<String, Object?> details,
  }) async {
    final database = await _db;
    await database.update(
      'baby_actions',
      {
        'occurred_at': occurredAt.millisecondsSinceEpoch,
        'notes': notes,
        'details': jsonEncode(details),
      },
      where: 'id = ?',
      whereArgs: <Object>[id],
    );

    final rows = await database.query(
      'baby_actions',
      where: 'id = ?',
      whereArgs: <Object>[id],
      limit: 1,
    );

    if (rows.isEmpty) {
      throw StateError('Unable to find baby action with id $id');
    }

    return _mapRow(rows.first);
  }

  @override
  Future<void> deleteAction(int id) async {
    final database = await _db;
    await database.delete(
      'baby_actions',
      where: 'id = ?',
      whereArgs: <Object>[id],
    );
  }

  @override
  Future<List<BabyAction>> fetchFilteredActions(
    int babyId, {
    List<BabyActionKind>? kinds,
    DateTime? startDate,
    DateTime? endDate,
    int limit = 100,
    int offset = 0,
  }) async {
    final database = await _db;
    
    final whereClauses = <String>['baby_id = ?'];
    final whereArgs = <Object>[babyId];

    // Filter by action kinds
    if (kinds != null && kinds.isNotEmpty) {
      final placeholders = List.filled(kinds.length, '?').join(', ');
      whereClauses.add('kind IN ($placeholders)');
      whereArgs.addAll(kinds.map((k) => k.name));
    }

    // Filter by date range
    if (startDate != null) {
      whereClauses.add('occurred_at >= ?');
      whereArgs.add(startDate.millisecondsSinceEpoch);
    }
    if (endDate != null) {
      // Add 1 day to make it inclusive of the entire end date
      final endOfDay = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59, 999);
      whereClauses.add('occurred_at <= ?');
      whereArgs.add(endOfDay.millisecondsSinceEpoch);
    }

    final rows = await database.query(
      'baby_actions',
      where: whereClauses.join(' AND '),
      whereArgs: whereArgs,
      orderBy: 'occurred_at DESC, id DESC',
      limit: limit,
      offset: offset,
    );

    return rows.map(_mapRow).toList(growable: false);
  }

  BabyAction _mapRow(Map<String, Object?> row) {
    final detailsRaw = row['details'] as String?;
    final Map<String, Object?> details;
    if (detailsRaw == null || detailsRaw.isEmpty) {
      details = const <String, Object?>{};
    } else {
      final dynamic decoded = jsonDecode(detailsRaw);
      if (decoded is Map<String, Object?>) {
        details = Map<String, Object?>.unmodifiable(decoded);
      } else {
        details = const <String, Object?>{};
      }
    }

    return BabyAction(
      id: row['id'] as int,
      babyId: row['baby_id'] as int,
      kind: BabyActionKind.values.byName(row['kind'] as String),
      occurredAt: DateTime.fromMillisecondsSinceEpoch(row['occurred_at'] as int),
      notes: row['notes'] as String?,
      details: details,
    );
  }
}
