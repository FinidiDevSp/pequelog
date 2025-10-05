import '../entities/baby_action.dart';
import '../entities/baby_action_draft.dart';

/// Contract to persist and retrieve baby actions.
abstract class BabyActionRepository {
  /// Persists a new action and returns the stored entity.
  Future<BabyAction> logAction(BabyActionDraft draft);

  /// Returns the most recent actions for the given [babyId].
  Future<List<BabyAction>> fetchRecentActions(int babyId, {int limit = 10});
}
