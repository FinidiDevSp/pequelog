import 'baby_sex.dart';

/// Describes the data required to create a new baby entry.
class BabyDraft {
  /// Creates a new draft with the provided attributes.
  const BabyDraft({
    required this.name,
    required this.birthDate,
    required this.sex,
    required this.birthLengthCm,
    required this.birthWeightKg,
    required this.photoPath,
  });

  final String name;
  final DateTime birthDate;
  final BabySex sex;
  final double birthLengthCm;
  final double birthWeightKg;
  final String? photoPath;
}
