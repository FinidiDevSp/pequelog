import 'package:flutter_test/flutter_test.dart';
import 'package:pequelog/domain/babies/entities/baby.dart';
import 'package:pequelog/domain/babies/entities/baby_sex.dart';
import 'package:pequelog/domain/babies/repositories/baby_repository.dart';
import 'package:pequelog/presentation/features/startup/baby_state.dart';

class _FakeBabyRepository implements BabyRepository {
  _FakeBabyRepository(this._babies);

  final List<Baby> _babies;

  @override
  Future<List<Baby>> fetchBabies() async => _babies;
}

void main() {
  group('BabyState', () {
    test('loads as missing when repository is empty', () async {
      final repository = _FakeBabyRepository(const <Baby>[]);
      final state = BabyState(repository: repository);

      await state.load();

      expect(state.status, BabyStatus.missingBaby);
      expect(state.selectedBaby, isNull);
    });

    test('selects the first baby returned by the repository', () async {
      final baby = Baby(
        id: 1,
        name: 'Lucia',
        birthDate: DateTime.utc(2024, 1, 10),
        sex: BabySex.female,
        birthLengthCm: 50.0,
        birthWeightKg: 3.2,
        photoPath: null,
      );
      final repository = _FakeBabyRepository([baby]);
      final state = BabyState(repository: repository);

      await state.load();

      expect(state.status, BabyStatus.ready);
      expect(state.selectedBaby, equals(baby));
    });
  });
}
