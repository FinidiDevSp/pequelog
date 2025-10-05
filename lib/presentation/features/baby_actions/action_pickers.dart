import 'package:flutter/material.dart';
import 'package:pequelog/l10n/app_localizations.dart';

/// Default launcher for action date pickers.
Future<DateTime?> defaultActionDatePicker(
  BuildContext context,
  DateTime initialDate,
) {
  final now = DateTime.now();
  final l10n = AppLocalizations.of(context)!;
  return showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: now.subtract(const Duration(days: 30)),
    lastDate: now,
    helpText: l10n.actionDatePickerHelp,
    locale: Localizations.localeOf(context),
    initialEntryMode: DatePickerEntryMode.calendarOnly,
  );
}

/// Default launcher for action time pickers.
Future<TimeOfDay?> defaultActionTimePicker(
  BuildContext context,
  TimeOfDay initialTime,
) {
  final l10n = AppLocalizations.of(context)!;
  return showTimePicker(
    context: context,
    initialTime: initialTime,
    helpText: l10n.actionTimePickerHelp,
    builder: (context, child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child ?? const SizedBox.shrink(),
      );
    },
  );
}
