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
