import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pequelog/core/services/image_picker_service.dart';
import 'package:pequelog/domain/babies/entities/baby.dart';
import 'package:pequelog/domain/babies/entities/baby_draft.dart';
import 'package:pequelog/domain/babies/entities/baby_sex.dart';
import 'package:pequelog/domain/babies/repositories/baby_repository.dart';
import 'package:pequelog/presentation/pequelog_app.dart';

class _InMemoryBabyRepository implements BabyRepository {
  final List<Baby> _babies = <Baby>[];
  int _nextId = 1;

  @override
  Future<List<Baby>> fetchBabies() async => List<Baby>.unmodifiable(_babies);

  @override
  Future<Baby> createBaby(BabyDraft draft) async {
    final baby = Baby(
      id: _nextId++,
      name: draft.name,
      birthDate: draft.birthDate,
      sex: draft.sex,
      birthLengthCm: draft.birthLengthCm,
      birthWeightKg: draft.birthWeightKg,
      photoPath: draft.photoPath,
    );
    _babies.add(baby);
    return baby;
  }
}

class _FakeImagePickerService implements ImagePickerService {
  _FakeImagePickerService({this.path});

  final String? path;

  @override
  Future<String?> pickImage() async => path ?? 'test/photo.png';
}

void main() {
  testWidgets('user can register a baby and return to home flow', (tester) async {
    final repository = _InMemoryBabyRepository();
    final imagePicker = _FakeImagePickerService();

    await tester.pumpWidget(
      PequeLogApp(
        repository: repository,
        imagePicker: imagePicker,
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Configurar App'), findsOneWidget);

    await tester.tap(find.text('Nuevo bebe'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('newBaby_name')), 'Mateo');
    await tester.enterText(find.byKey(const Key('newBaby_birthDate')), '2023-06-12');

    await tester.tap(find.byKey(const Key('newBaby_sex')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Nino').last);
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('newBaby_length')), '52.5');
    await tester.enterText(find.byKey(const Key('newBaby_weight')), '3.4');

    await tester.tap(find.byKey(const Key('newBaby_pickPhoto')));
    await tester.pump();

    await tester.tap(find.byKey(const Key('newBaby_submit')));
    await tester.pumpAndSettle();

    expect(find.text('Mateo'), findsOneWidget);
    expect(repository._babies.length, 1);
    expect(repository._babies.first.photoPath, isNotNull);
  });
}
