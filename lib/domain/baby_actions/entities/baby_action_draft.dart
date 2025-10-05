import 'baby_action_kind.dart';

/// Data required to log a new baby action.
class BabyActionDraft {
  /// Creates a new draft ready to be persisted.
  const BabyActionDraft({
    required this.babyId,
    required this.kind,
    required this.occurredAt,
    required this.details,
    this.notes,
  });

  /// Identifier of the baby the action belongs to.
  final int babyId;

  /// Type of action being logged.
  final BabyActionKind kind;

  /// Instant when the action happened.
  final DateTime occurredAt;

  /// Optional caregiver notes.
  final String? notes;

  /// Structured data specific to the action kind.
  final Map<String, Object?> details;
}
