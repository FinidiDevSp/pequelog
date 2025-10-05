import '../entities/baby_action.dart';
import '../entities/baby_action_draft.dart';
import '../entities/baby_action_kind.dart';
import '../repositories/baby_action_repository.dart';

/// Use case that records a feeding session with structured details.
class LogFeedAction {
  /// Creates a logger backed by the given [repository].
  LogFeedAction({required BabyActionRepository repository})
      : _repository = repository;

  final BabyActionRepository _repository;

  /// Persists a feed action for the given [babyId].
  Future<BabyAction> call({
    required int babyId,
    required DateTime occurredAt,
    required double amountMl,
    String? notes,
    Duration? duration,
  }) {
    final draft = BabyActionDraft(
      babyId: babyId,
      kind: BabyActionKind.feed,
      occurredAt: occurredAt,
      notes: notes,
      details: <String, Object?>{
        'amountMl': amountMl,
        if (duration != null) 'durationSeconds': duration.inSeconds,
      },
    );
    return _repository.logAction(draft);
  }
}
