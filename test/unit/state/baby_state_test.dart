import 'package:flutter_test/flutter_test.dart';
import 'package:pequelog/domain/babies/entities/baby.dart';
import 'package:pequelog/domain/babies/entities/baby_draft.dart';
import 'package:pequelog/domain/babies/entities/baby_sex.dart';
import 'package:pequelog/domain/babies/repositories/baby_repository.dart';
import 'package:pequelog/presentation/features/startup/baby_state.dart';

class _FakeBabyRepository implements BabyRepository {
  _FakeBabyRepository({List<Baby>? initialBabies})
    : _babies = List.of(initialBabies ?? const <Baby>[]),
      _nextId =
          (initialBabies
                  ?.map((b) => b.id)
                  .fold<int>(0, (prev, id) => id > prev ? id : prev) ??
              0) +
          1;

  final List<Baby> _babies;
  int _nextId;

  @override
  Future<List<Baby>> fetchBabies() async => List<Baby>.unmodifiable(_babies);

  @override
  Future<Baby> createBaby(BabyDraft draft) async {
    final baby = Baby(
      id: _nextId++,
      name: draft.name,
      birthDateTime: draft.birthDateTime,
      sex: draft.sex,
      birthLengthCm: draft.birthLengthCm,
      birthWeightKg: draft.birthWeightKg,
      photoPath: draft.photoPath,
    );
    _babies.add(baby);
    return baby;
  }

  @override
  Future<Baby> updateBaby(int id, BabyDraft draft) async {
    final index = _babies.indexWhere((baby) => baby.id == id);
    if (index == -1) {
      throw StateError('Baby not found');
    }
    final updated = Baby(
      id: id,
      name: draft.name,
      birthDateTime: draft.birthDateTime,
      sex: draft.sex,
      birthLengthCm: draft.birthLengthCm,
      birthWeightKg: draft.birthWeightKg,
      photoPath: draft.photoPath,
    );
    _babies[index] = updated;
    return updated;
  }
}

void main() {
  group('BabyState', () {
    test('loads as missing when repository is empty', () async {
      final repository = _FakeBabyRepository();
      final state = BabyState(repository: repository);

      await state.load();

      expect(state.status, BabyStatus.missingBaby);
      expect(state.selectedBaby, isNull);
    });

    test('selects the first baby returned by the repository', () async {
      final birthDateTime = DateTime(2024, 1, 10, 8, 45);
      final baby = Baby(
        id: 1,
        name: 'Lucia',
        birthDateTime: birthDateTime,
        sex: BabySex.female,
        birthLengthCm: 50.0,
        birthWeightKg: 3.2,
        photoPath: null,
      );
      final repository = _FakeBabyRepository(initialBabies: [baby]);
      final state = BabyState(repository: repository);

      await state.load();

      expect(state.status, BabyStatus.ready);
      expect(state.selectedBaby, equals(baby));
      expect(state.selectedBaby?.birthDateTime, equals(birthDateTime));
    });

    test('addBaby persists and selects the new baby', () async {
      final repository = _FakeBabyRepository();
      final state = BabyState(repository: repository);

      await state.load();
      expect(state.status, BabyStatus.missingBaby);

      await state.addBaby(
        BabyDraft(
          name: 'Noa',
          birthDateTime: DateTime(2024, 5, 4, 3, 15),
          sex: BabySex.other,
          birthLengthCm: 49.0,
          birthWeightKg: 3.0,
          photoPath: 'photo.png',
        ),
      );

      expect(state.status, BabyStatus.ready);
      expect(state.selectedBaby?.name, 'Noa');
      expect(state.selectedBaby?.birthDateTime.hour, 3);
      expect(state.babies.length, 1);
      expect(state.babies.first.photoPath, 'photo.png');
    });

    test('updateBaby persists the changes and refreshes selection', () async {
      final initial = Baby(
        id: 1,
        name: 'Ines',
        birthDateTime: DateTime(2024, 2, 10, 14, 0),
        sex: BabySex.female,
        birthLengthCm: 49.0,
        birthWeightKg: 3.1,
        photoPath: 'photo.png',
      );
      final repository = _FakeBabyRepository(initialBabies: [initial]);
      final state = BabyState(repository: repository);

      await state.load();
      expect(state.selectedBaby?.name, 'Ines');

      await state.updateBaby(
        initial,
        BabyDraft(
          name: 'Inés Renata',
          birthDateTime: DateTime(2024, 2, 10, 16, 30),
          sex: BabySex.female,
          birthLengthCm: 50.0,
          birthWeightKg: 3.2,
          photoPath: 'updated.png',
        ),
      );

      expect(state.selectedBaby?.name, 'Inés Renata');
      expect(state.selectedBaby?.photoPath, 'updated.png');
      expect(state.babies, hasLength(1));
      expect(state.babies.first.birthDateTime.hour, 16);
    });
  });
}
