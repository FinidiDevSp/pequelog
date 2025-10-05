import '../entities/baby_action.dart';
import '../entities/baby_action_draft.dart';

/// Contract to persist and retrieve baby actions.
abstract class BabyActionRepository {
  /// Persists a new action and returns the stored entity.
  Future<BabyAction> logAction(BabyActionDraft draft);

  /// Returns the most recent actions for the given [babyId].
  Future<List<BabyAction>> fetchRecentActions(int babyId, {int limit = 10});

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
