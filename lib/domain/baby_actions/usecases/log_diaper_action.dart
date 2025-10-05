import '../entities/baby_action.dart';
import '../entities/baby_action_draft.dart';
import '../entities/baby_action_kind.dart';
import '../entities/stool_texture.dart';
import '../repositories/baby_action_repository.dart';

/// Logs a diaper change that included stool.
class LogDiaperAction {
  /// Creates the logger backed by [repository].
  LogDiaperAction({required BabyActionRepository repository})
      : _repository = repository;

  final BabyActionRepository _repository;

  /// Persists the diaper action with the provided data.
  Future<BabyAction> call({
    required int babyId,
    required DateTime occurredAt,
    required StoolTexture texture,
    bool? hadPee,
    String? notes,
  }) {
    final draft = BabyActionDraft(
      babyId: babyId,
      kind: BabyActionKind.diaper,
      occurredAt: occurredAt,
      notes: notes,
      details: <String, Object?>{
        'texture': texture.name,
        if (hadPee != null) 'hadPee': hadPee,
      },
    );
    return _repository.logAction(draft);
  }
}
