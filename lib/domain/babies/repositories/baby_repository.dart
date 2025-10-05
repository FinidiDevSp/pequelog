import '../entities/baby.dart';
import '../entities/baby_draft.dart';

/// Contract for accessing and mutating baby records.
abstract class BabyRepository {
  /// Returns all babies ordered by creation date (ascending).
  Future<List<Baby>> fetchBabies();

  /// Persists a new baby and returns the stored entity.
  Future<Baby> createBaby(BabyDraft draft);
}
