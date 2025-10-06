import 'package:flutter_test/flutter_test.dart';
import 'package:pequelog/data/baby_actions/legacy_action_csv_parser.dart';

void main() {
  group('LegacyActionCsvParser', () {
    test('parses feed, vomit and bath flags from UTF-8 CSV', () {
      const csv = 'Fecha,Hora,Biberón (ml),Caca,Vómito,Baño\n'
          '2025-10-02,08:20,140,,Sí,\n';
      final parser = LegacyActionCsvParser();

      final records = parser.parse(csv);

      expect(records, hasLength(1));
      final record = records.single;
      expect(record.feedAmountMl, 140);
      expect(record.didPoop, isFalse);
      expect(record.didVomit, isTrue);
      expect(record.didBath, isFalse);
      expect(record.occurredAt, DateTime(2025, 10, 2, 8, 20));
    });

    test('parses latin1 artifacts as positive flags', () {
      const csv = 'Fecha,Hora,Biberón (ml),Caca,Vómito,Baño\n'
          '2025-10-02,08:20,,SÃ­,,,\n';
      final parser = LegacyActionCsvParser();

      final records = parser.parse(csv);

      expect(records, hasLength(1));
      final record = records.single;
      expect(record.feedAmountMl, isNull);
      expect(record.didPoop, isTrue);
      expect(record.didVomit, isFalse);
      expect(record.didBath, isFalse);
    });

    test('ignores rows without actionable information', () {
      const csv = 'Fecha,Hora,Biberón (ml),Caca,Vómito,Baño\n'
          '2025-10-02,08:20,,,,\n';
      final parser = LegacyActionCsvParser();

      final records = parser.parse(csv);

      expect(records, isEmpty);
    });
  });
}
