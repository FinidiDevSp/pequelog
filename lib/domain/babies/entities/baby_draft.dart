import 'baby.dart';
import 'baby_sex.dart';

/// Describes the data required to create a new baby entry.
class BabyDraft {
  /// Creates a new draft with the provided attributes.
  const BabyDraft({
    required this.name,
    required this.birthDateTime,
    required this.sex,
    required this.birthLengthCm,
    required this.birthWeightKg,
    required this.photoPath,
  });

  final String name;
  final DateTime birthDateTime;
  final BabySex sex;
  final double birthLengthCm;
  final double birthWeightKg;
  final String? photoPath;

  /// Creates a draft from an existing [Baby], useful when editing.
  factory BabyDraft.fromBaby(Baby baby) {
    return BabyDraft(
      name: baby.name,
      birthDateTime: baby.birthDateTime,
      sex: baby.sex,
      birthLengthCm: baby.birthLengthCm,
      birthWeightKg: baby.birthWeightKg,
      photoPath: baby.photoPath,
    );
  }
}
