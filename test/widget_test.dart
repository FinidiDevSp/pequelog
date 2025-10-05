import 'package:flutter_test/flutter_test.dart';
import 'package:pequelog/domain/babies/entities/baby.dart';
import 'package:pequelog/domain/babies/repositories/baby_repository.dart';
import 'package:pequelog/presentation/pequelog_app.dart';

class _FakeBabyRepository implements BabyRepository {
  @override
  Future<List<Baby>> fetchBabies() async => const <Baby>[];
}

void main() {
  testWidgets('PequeLogApp bootstraps without issues', (tester) async {
    await tester.pumpWidget(PequeLogApp(repository: _FakeBabyRepository()));
    await tester.pump();

    expect(find.text('PequeLog'), findsOneWidget);
  });
}
