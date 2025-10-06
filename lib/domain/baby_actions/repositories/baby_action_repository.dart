import '../entities/baby_action.dart';
import '../entities/baby_action_draft.dart';
import '../entities/baby_action_kind.dart';

/// Contract to persist and retrieve baby actions.
abstract class BabyActionRepository {
  /// Persists a new action and returns the stored entity.
  Future<BabyAction> logAction(BabyActionDraft draft);

  /// Returns the most recent actions for the given [babyId].
  Future<List<BabyAction>> fetchRecentActions(int babyId, {int limit = 10});

  /// Returns actions for the given [babyId] with optional filters.
  /// 
  /// - [kinds]: Filter by specific action types. If empty or null, returns all.
  /// - [startDate]: Include only actions on or after this date (inclusive).
  /// - [endDate]: Include only actions on or before this date (inclusive).
  /// - [limit]: Maximum number of results to return.
  /// - [offset]: Number of results to skip (for pagination).
  Future<List<BabyAction>> fetchFilteredActions(
    int babyId, {
    List<BabyActionKind>? kinds,
    DateTime? startDate,
    DateTime? endDate,
    int limit = 100,
    int offset = 0,
  });

  /// Updates an existing action identified by [id].
  Future<BabyAction> updateAction({
    required int id,
    required DateTime occurredAt,
    String? notes,
    required Map<String, Object?> details,
  });

  /// Deletes the action identified by [id].
  Future<void> deleteAction(int id);
}
