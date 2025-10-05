import '../entities/baby_action.dart';
import '../entities/baby_action_draft.dart';
import '../entities/baby_action_kind.dart';
import '../repositories/baby_action_repository.dart';

/// Records a bath session for the selected baby.
class LogBathAction {
  /// Creates a logger backed by the given [repository].
  LogBathAction({required BabyActionRepository repository})
      : _repository = repository;

  final BabyActionRepository _repository;

  /// Saves a bath event with optional extra metadata.
  Future<BabyAction> call({
    required int babyId,
    required DateTime occurredAt,
    int? durationMinutes,
    String? notes,
  }) {
    final draft = BabyActionDraft(
      babyId: babyId,
      kind: BabyActionKind.bath,
      occurredAt: occurredAt,
      notes: notes,
      details: <String, Object?>{
        if (durationMinutes != null) 'durationMinutes': durationMinutes,
      },
    );
    return _repository.logAction(draft);
  }
}
