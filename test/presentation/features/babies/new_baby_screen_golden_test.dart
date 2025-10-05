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

class _FakeBabyRepository implements BabyRepository {
  @override
  Future<List<Baby>> fetchBabies() async => const <Baby>[];

  @override
  Future<Baby> createBaby(BabyDraft draft) async {
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

Future<void> _pumpNewBabyScreen(
  WidgetTester tester,
  DateTime Function(DateTime initialDate) onDate,
  TimeOfDay Function(TimeOfDay initialTime) onTime,
) async {
  await tester.pumpWidget(
    ChangeNotifierProvider<BabyState>(
      create: (_) => BabyState(repository: _FakeBabyRepository()),
      child: MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme:
              ColorScheme.fromSeed(
                seedColor: const Color(0xFF3F4C5A),
                background: const Color(0xFFFBFBF1),
                brightness: Brightness.light,
              ).copyWith(
                surface: const Color(0xFFFBFBF1),
                onSurface: Colors.black87,
                onBackground: Colors.black87,
                primary: const Color(0xFF3F4C5A),
                onPrimary: Colors.white,
              ),
          scaffoldBackgroundColor: const Color(0xFFFBFBF1),
        ),
        home: NewBabyScreen(
          imagePicker: _FakeImagePickerService(),
          datePicker: (context, initialDate) async => onDate(initialDate),
          timePicker: (context, initialTime) async => onTime(initialTime),
        ),
      ),
    ),
  );

  await tester.pumpAndSettle();
}

void main() {
  const surfaceSize = Size(390, 844);

  testWidgets('NewBabyScreen golden - initial state', (tester) async {
    await _pumpNewBabyScreen(
      tester,
      (initialDate) => initialDate,
      (initialTime) => initialTime,
    );

    await tester.binding.setSurfaceSize(surfaceSize);
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('goldens/new_baby_screen_initial.png'),
    );
  });

  testWidgets('NewBabyScreen golden - filled state', (tester) async {
    await _pumpNewBabyScreen(
      tester,
      (_) => DateTime(2022, 1, 2),
      (_) => const TimeOfDay(hour: 14, minute: 45),
    );

    await tester.binding.setSurfaceSize(surfaceSize);
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('newBaby_name')), 'Aitana');
    await tester.tap(find.byKey(const Key('newBaby_birthDate')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('newBaby_birthTime')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('newBaby_sex_female')));
    await tester.pump();
    await tester.enterText(find.byKey(const Key('newBaby_length')), '51.0');
    await tester.enterText(find.byKey(const Key('newBaby_weight')), '3.1');
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('goldens/new_baby_screen_filled.png'),
    );
  });
}
