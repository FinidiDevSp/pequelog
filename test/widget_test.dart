import 'package:flutter_test/flutter_test.dart';
import 'package:pequelog/core/services/image_picker_service.dart';
import 'package:pequelog/domain/babies/entities/baby.dart';
import 'package:pequelog/domain/babies/entities/baby_draft.dart';
import 'package:pequelog/domain/babies/repositories/baby_repository.dart';
import 'package:pequelog/presentation/pequelog_app.dart';

class _FakeBabyRepository implements BabyRepository {
  @override
  Future<List<Baby>> fetchBabies() async => const <Baby>[];

  @override
  Future<Baby> createBaby(BabyDraft draft) async {
    throw UnimplementedError('Not needed for this test');
  }
}

class _FakeImagePickerService implements ImagePickerService {
  @override
  Future<String?> pickImage() async => null;
}

void main() {
  testWidgets('PequeLogApp bootstraps without issues', (tester) async {
    await tester.pumpWidget(
      PequeLogApp(
        repository: _FakeBabyRepository(),
        imagePicker: _FakeImagePickerService(),
      ),
    );
    await tester.pump();

    expect(find.text('PequeLog'), findsOneWidget);
  });
}
