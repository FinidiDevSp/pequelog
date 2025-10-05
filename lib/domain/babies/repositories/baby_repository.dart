import '../entities/baby.dart';

/// Contract for accessing and mutating baby records.
abstract class BabyRepository {
  /// Returns all babies ordered by creation date (ascending).
  Future<List<Baby>> fetchBabies();
}
