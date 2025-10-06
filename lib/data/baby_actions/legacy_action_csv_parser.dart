import 'dart:convert';

/// Parsed information coming from the legacy CSV export.
class LegacyActionCsvRecord {
  /// Builds a row representation.
  const LegacyActionCsvRecord({
    required this.occurredAt,
    this.feedAmountMl,
    this.didPoop = false,
    this.didVomit = false,
    this.didBath = false,
  });

  /// Moment when the legacy record took place.
  final DateTime occurredAt;

  /// Optional amount of milk consumed during the feed in millilitres.
  final double? feedAmountMl;

  /// Whether the record included a stool event.
  final bool didPoop;

  /// Whether the record included vomit.
  final bool didVomit;

  /// Whether the record included a bath.
  final bool didBath;
}

/// Utility capable of parsing CSV files exported by the legacy application.
class LegacyActionCsvParser {
  /// Parses the provided [contents] and returns structured records.
  List<LegacyActionCsvRecord> parse(String contents) {
    if (contents.trim().isEmpty) {
      return const <LegacyActionCsvRecord>[];
    }

    final sanitized = contents
        .replaceAll('\r\n', '\n')
        .replaceAll('\r', '\n');
    final rawLines = sanitized.split('\n');
    if (rawLines.length <= 1) {
      return const <LegacyActionCsvRecord>[];
    }

    final result = <LegacyActionCsvRecord>[];
    var isFirstLine = true;
    for (final originalLine in rawLines) {
      if (originalLine.trim().isEmpty) {
        continue;
      }
      if (isFirstLine) {
        isFirstLine = false;
        continue; // Skip header row.
      }

      final line = originalLine.replaceAll('\ufeff', '');
      final columns = _splitCsvLine(line);
      if (columns.length < 2) {
        continue;
      }

      final dateRaw = columns[0].trim();
      final timeRaw = columns.length > 1 ? columns[1].trim() : '';
      if (dateRaw.isEmpty || timeRaw.isEmpty) {
        continue;
      }

      DateTime occurredAt;
      try {
        occurredAt = DateTime.parse('$dateRaw $timeRaw');
      } catch (_) {
        continue;
      }

      double? feedAmount;
      if (columns.length > 2) {
        final feedRaw = columns[2].trim();
        if (feedRaw.isNotEmpty) {
          final normalized = feedRaw.replaceAll(',', '.');
          feedAmount = double.tryParse(normalized);
        }
      }

      final didPoop = columns.length > 3 && _parseFlag(columns[3]);
      final didVomit = columns.length > 4 && _parseFlag(columns[4]);
      final didBath = columns.length > 5 && _parseFlag(columns[5]);

      if (feedAmount == null && !didPoop && !didVomit && !didBath) {
        continue;
      }

      result.add(
        LegacyActionCsvRecord(
          occurredAt: occurredAt,
          feedAmountMl: feedAmount,
          didPoop: didPoop,
          didVomit: didVomit,
          didBath: didBath,
        ),
      );
    }

    return result;
  }

  List<String> _splitCsvLine(String line) {
    final values = <String>[];
    final buffer = StringBuffer();
    var inQuotes = false;

    for (var i = 0; i < line.length; i++) {
      final char = line[i];
      if (char == '"') {
        final isEscapedQuote =
            inQuotes && i + 1 < line.length && line[i + 1] == '"';
        if (isEscapedQuote) {
          buffer.write('"');
          i++;
        } else {
          inQuotes = !inQuotes;
        }
        continue;
      }

      if (char == ',' && !inQuotes) {
        values.add(buffer.toString());
        buffer.clear();
        continue;
      }

      buffer.write(char);
    }

    values.add(buffer.toString());
    return values;
  }

  bool _parseFlag(String input) {
    if (input.trim().isEmpty) {
      return false;
    }

    var normalized = input.trim().toLowerCase();
    normalized = latin1.decode(latin1.encode(normalized));
    normalized = normalized
        .replaceAll(RegExp('[áàäâã]'), 'a')
        .replaceAll(RegExp('[éèëê]'), 'e')
        .replaceAll(RegExp('[íìïî]'), 'i')
        .replaceAll(RegExp('[óòöôõ]'), 'o')
        .replaceAll(RegExp('[úùüû]'), 'u')
        .replaceAll('ñ', 'n');
    normalized = normalized.replaceAll('sí', 'si').replaceAll('sÃ­', 'si');

    return <String>{'si', 's', 'y', 'yes', 'true', '1'}.contains(normalized);
  }
}
