import '../entities/baby_action.dart';
import '../repositories/baby_action_repository.dart';

/// Use case that edits the details of a recorded feeding session.
class UpdateFeedAction {
  /// Creates an updater backed by the provided [repository].
  UpdateFeedAction({required BabyActionRepository repository})
      : _repository = repository;

  final BabyActionRepository _repository;

  /// Persists the edited feed action identified by [actionId].
  Future<BabyAction> call({
    required int actionId,
    required DateTime occurredAt,
    required double amountMl,
    String? notes,
    Duration? duration,
  }) {
    return _repository.updateAction(
      id: actionId,
      occurredAt: occurredAt,
      notes: notes,
      details: <String, Object?>{
        'amountMl': amountMl,
        if (duration != null) 'durationSeconds': duration.inSeconds,
      },
    );
  }
}
