import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pequelog/core/services/image_picker_service.dart';
import 'package:pequelog/domain/babies/entities/baby.dart';
import 'package:pequelog/domain/babies/entities/baby_draft.dart';
import 'package:pequelog/domain/babies/entities/baby_sex.dart';
import 'package:pequelog/domain/babies/repositories/baby_repository.dart';
import 'package:pequelog/l10n/app_localizations.dart';
import 'package:pequelog/presentation/features/babies/new_baby_screen.dart';
import 'package:pequelog/presentation/features/startup/baby_state.dart';
import 'package:provider/provider.dart';

class _SpyBabyRepository implements BabyRepository {
  BabyDraft? lastDraft;

  @override
  Future<List<Baby>> fetchBabies() async => const <Baby>[];

  @override
  Future<Baby> createBaby(BabyDraft draft) async {
    lastDraft = draft;
    return Baby(
      id: 1,
      name: draft.name,
      birthDateTime: draft.birthDateTime,
      sex: draft.sex,
      birthLengthCm: draft.birthLengthCm,
      birthWeightKg: draft.birthWeightKg,
      photoPath: draft.photoPath,
    );
  }
}

class _FakeImagePickerService implements ImagePickerService {
  @override
  Future<String?> pickImage() async => null;
}

void main() {
  testWidgets(
    'NewBabyScreen collects birth date, time and sex with dedicated selectors',
    (tester) async {
      final repository = _SpyBabyRepository();

      await tester.binding.setSurfaceSize(const Size(430, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        ChangeNotifierProvider<BabyState>(
          create: (_) => BabyState(repository: repository),
          child: MaterialApp(
            locale: const Locale('es'),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: NewBabyScreen(
              imagePicker: _FakeImagePickerService(),
              datePicker: (context, initialDate) async => DateTime(2022, 1, 2),
              timePicker: (context, initialTime) async =>
                  const TimeOfDay(hour: 14, minute: 45),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('newBaby_name')), 'Aitana');

      await tester.tap(find.byKey(const Key('newBaby_birthDate')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('newBaby_birthTime')));
      await tester.pumpAndSettle();

      expect(find.text('Niña'), findsOneWidget);
      expect(find.text('Niño'), findsOneWidget);

      await tester.tap(find.byKey(const Key('newBaby_sex_female')));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('newBaby_length')), '51.0');
      await tester.enterText(find.byKey(const Key('newBaby_weight')), '3.1');

      await tester.tap(find.byKey(const Key('newBaby_submit')));
      await tester.pumpAndSettle();

      final draft = repository.lastDraft;
      expect(draft, isNotNull);
      expect(draft?.birthDateTime, DateTime(2022, 1, 2, 14, 45));
      expect(draft?.sex, BabySex.female);
    },
  );
}
