import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pequelog/core/services/image_picker_service.dart';
import 'package:pequelog/domain/babies/entities/baby_draft.dart';
import 'package:pequelog/domain/babies/entities/baby_sex.dart';
import 'package:pequelog/l10n/app_localizations.dart';
import 'package:pequelog/presentation/features/babies/new_baby_screen.dart';
import 'package:pequelog/presentation/features/babies/widgets/new_baby_form.dart';

class _FakeImagePickerService implements ImagePickerService {
  _FakeImagePickerService(this.path);
  final String? path;

  @override
  Future<String?> pickImage() async => path;
}

MaterialApp _buildApp(Widget child) {
  return MaterialApp(
    locale: const Locale('es'),
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );
}

void main() {
  group('NewBabyForm', () {
    testWidgets('emits a BabyDraft with the collected values', (tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      BabyDraft? captured;

      await tester.pumpWidget(
        _buildApp(
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: NewBabyForm(
              imagePicker: _FakeImagePickerService('photo.png'),
              datePicker: (context, initialDate) async => DateTime(2023, 6, 12),
              timePicker: (context, initialTime) async => const TimeOfDay(hour: 9, minute: 30),
              onSubmit: (draft) async {
                captured = draft;
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('newBaby_name')), 'Noa');
      await tester.tap(find.byKey(const Key('newBaby_birthDate')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('newBaby_birthTime')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('newBaby_sex_female')));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('newBaby_length')), '49.0');
      await tester.enterText(find.byKey(const Key('newBaby_weight')), '3.1');
      await tester.tap(find.byKey(const Key('newBaby_pickPhoto')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('newBaby_submit')));
      await tester.pumpAndSettle();

      expect(captured, isNotNull);
      expect(captured!.name, 'Noa');
      expect(captured!.birthDateTime, DateTime(2023, 6, 12, 9, 30));
      expect(captured!.sex, BabySex.female);
      expect(captured!.photoPath, 'photo.png');
    });

    testWidgets('shows an error snackbar when submission fails', (tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        _buildApp(
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: NewBabyForm(
              imagePicker: _FakeImagePickerService(null),
              datePicker: (context, initialDate) async => DateTime(2023, 6, 12),
              timePicker: (context, initialTime) async => const TimeOfDay(hour: 9, minute: 30),
              onSubmit: (_) async {
                throw Exception('boom');
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('newBaby_name')), 'Noa');
      await tester.tap(find.byKey(const Key('newBaby_birthDate')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('newBaby_birthTime')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('newBaby_sex_male')));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('newBaby_length')), '49.0');
      await tester.enterText(find.byKey(const Key('newBaby_weight')), '3.1');
      await tester.tap(find.byKey(const Key('newBaby_submit')));
      await tester.pump();

      expect(find.text('No se pudo guardar. Intenta de nuevo.'), findsOneWidget);
    });
  });
}
