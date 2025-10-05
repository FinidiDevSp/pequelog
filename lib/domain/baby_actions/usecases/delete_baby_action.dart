import '../repositories/baby_action_repository.dart';

/// Use case that removes a previously logged action.
class DeleteBabyAction {
  /// Creates a deleter backed by the given [repository].
  DeleteBabyAction({required BabyActionRepository repository})
      : _repository = repository;

  final BabyActionRepository _repository;

  /// Deletes the action with the provided [id].
  Future<void> call(int id) {
    return _repository.deleteAction(id);
  }
}
