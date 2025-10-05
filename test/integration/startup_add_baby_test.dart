import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pequelog/core/services/image_picker_service.dart';
import 'package:pequelog/domain/babies/entities/baby.dart';
import 'package:pequelog/domain/babies/entities/baby_draft.dart';
import 'package:pequelog/domain/babies/entities/baby_sex.dart';
import 'package:pequelog/domain/babies/repositories/baby_repository.dart';
import 'package:pequelog/l10n/app_localizations.dart';
import 'package:pequelog/presentation/features/babies/new_baby_screen.dart';
import 'package:pequelog/presentation/features/startup/baby_home_screen.dart';
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
      birthDateTime: draft.birthDateTime,
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
  testWidgets('user can register a baby and return to home flow', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 930));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final repository = _InMemoryBabyRepository();
    final imagePicker = _FakeImagePickerService();

    DateTime? pickedDate;
    TimeOfDay? pickedTime;

    await tester.pumpWidget(
      PequeLogApp(
        repository: repository,
        imagePicker: imagePicker,
        datePicker: (context, initialDate) async {
          pickedDate = DateTime(2023, 6, 12);
          return pickedDate;
        },
        timePicker: (context, initialTime) async {
          pickedTime = const TimeOfDay(hour: 9, minute: 30);
          return pickedTime;
        },
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Configurar App'), findsOneWidget);

    await tester.pump(const Duration(seconds: 5));

    final newBabyButton = find.byKey(const Key('setup_newBaby'));
    await tester.ensureVisible(newBabyButton);
    final outlinedButton = tester.widget<OutlinedButton>(newBabyButton);
    outlinedButton.onPressed?.call();
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('newBaby_name')), 'Mateo');

    await tester.tap(find.byKey(const Key('newBaby_birthDate')));
    await tester.pump();

    await tester.tap(find.byKey(const Key('newBaby_birthTime')));
    await tester.pump();

    await tester.tap(find.byKey(const Key('newBaby_sex_male')));
    await tester.pump();

    await tester.enterText(find.byKey(const Key('newBaby_length')), '52.5');
    await tester.enterText(find.byKey(const Key('newBaby_weight')), '3.4');

    await tester.tap(find.byKey(const Key('newBaby_pickPhoto')));
    await tester.pump();

    await tester.tap(find.byKey(const Key('newBaby_submit')));
    await tester.pumpAndSettle();

    expect(find.text('Mateo'), findsOneWidget);
    expect(repository._babies.length, 1);
    final storedBaby = repository._babies.first;
    expect(storedBaby.photoPath, isNotNull);
    expect(storedBaby.birthDateTime, DateTime(2023, 6, 12, 9, 30));
    expect(pickedDate, isNotNull);
    expect(pickedTime, isNotNull);

    final context = tester.element(find.byType(BabyHomeScreen));
    final l10n = AppLocalizations.of(context)!;
    final materialLocalizations = MaterialLocalizations.of(context);
    final birthDateText = materialLocalizations.formatMediumDate(
      storedBaby.birthDateTime,
    );
    final birthTimeText = materialLocalizations.formatTimeOfDay(
      TimeOfDay.fromDateTime(storedBaby.birthDateTime),
      alwaysUse24HourFormat: true,
    );

    expect(
      find.text(l10n.babyHomeBirthSummary(birthDateText, birthTimeText)),
      findsOneWidget,
    );
  });
}
