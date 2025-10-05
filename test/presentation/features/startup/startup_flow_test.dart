import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pequelog/core/services/image_picker_service.dart';
import 'package:pequelog/domain/babies/entities/baby.dart';
import 'package:pequelog/domain/babies/entities/baby_draft.dart';
import 'package:pequelog/domain/babies/entities/baby_sex.dart';
import 'package:pequelog/domain/babies/repositories/baby_repository.dart';
import 'package:pequelog/presentation/features/startup/baby_home_screen.dart';
import 'package:pequelog/presentation/features/startup/setup_screen.dart';
import 'package:pequelog/presentation/pequelog_app.dart';

class _FakeBabyRepository implements BabyRepository {
  _FakeBabyRepository(this._babies);

  final List<Baby> _babies;

  @override
  Future<List<Baby>> fetchBabies() async => _babies;

  @override
  Future<Baby> createBaby(BabyDraft draft) async {
    throw UnimplementedError();
  }
}

class _FakeImagePickerService implements ImagePickerService {
  @override
  Future<String?> pickImage() async => null;
}

void main() {
  group('SetupScreen', () {
    testWidgets('shows minimal UI with actions and snackbar', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SetupScreen(
            onConfigure: () {},
            onCreateBaby: () {},
          ),
        ),
      );

      await tester.pump();

      expect(find.text('Configurar App'), findsOneWidget);
      expect(find.text('Nuevo bebe'), findsOneWidget);
      expect(find.text('Registra un bebe para empezar'), findsOneWidget);
    });
  });

  group('PequeLogApp startup flow', () {
    testWidgets('renders setup when repository has no babies', (tester) async {
      final repository = _FakeBabyRepository(const <Baby>[]);

      await tester.pumpWidget(
        PequeLogApp(
          repository: repository,
          imagePicker: _FakeImagePickerService(),
        ),
      );

      await tester.pump();

      expect(find.byType(SetupScreen), findsOneWidget);
    });

    testWidgets('renders baby home when repository provides babies', (tester) async {
      final baby = Baby(
        id: 1,
        name: 'Mateo',
        birthDate: DateTime.utc(2023, 6, 12),
        sex: BabySex.male,
        birthLengthCm: 52.5,
        birthWeightKg: 3.4,
        photoPath: null,
      );
      final repository = _FakeBabyRepository([baby]);

      await tester.pumpWidget(
        PequeLogApp(
          repository: repository,
          imagePicker: _FakeImagePickerService(),
        ),
      );

      await tester.pump();

      expect(find.byType(BabyHomeScreen), findsOneWidget);
      expect(find.text('Mateo'), findsOneWidget);
    });
  });
}
