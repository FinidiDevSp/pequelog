import 'package:flutter_test/flutter_test.dart';
import 'package:pequelog/main.dart';

void main() {
  testWidgets('PequeLogApp bootstraps without issues', (tester) async {
    await tester.pumpWidget(const PequeLogApp());

    expect(find.text('PequeLog'), findsWidgets);
  });
}
