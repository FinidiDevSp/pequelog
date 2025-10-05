import '../entities/baby_action.dart';
import '../entities/baby_action_draft.dart';
import '../entities/baby_action_kind.dart';
import '../entities/vomit_severity.dart';
import '../repositories/baby_action_repository.dart';

/// Records a vomit event with its perceived severity.
class LogVomitAction {
  /// Creates a logger backed by the given [repository].
  LogVomitAction({required BabyActionRepository repository})
      : _repository = repository;

  final BabyActionRepository _repository;

  /// Persists the vomit action.
  Future<BabyAction> call({
    required int babyId,
    required DateTime occurredAt,
    required VomitSeverity severity,
    String? notes,
  }) {
    final draft = BabyActionDraft(
      babyId: babyId,
      kind: BabyActionKind.vomit,
      occurredAt: occurredAt,
      notes: notes,
      details: <String, Object?>{
        'severity': severity.name,
      },
    );
    return _repository.logAction(draft);
  }
}
