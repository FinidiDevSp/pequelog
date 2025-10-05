import '../entities/baby_action.dart';
import '../repositories/baby_action_repository.dart';

/// Retrieves the latest actions for a given baby.
class GetRecentBabyActions {
  /// Creates the use case backed by the provided [repository].
  GetRecentBabyActions({required BabyActionRepository repository})
      : _repository = repository;

  final BabyActionRepository _repository;

  /// Returns the most recent actions, limited by [limit].
  Future<List<BabyAction>> call(int babyId, {int limit = 6}) {
    return _repository.fetchRecentActions(babyId, limit: limit);
  }
}
