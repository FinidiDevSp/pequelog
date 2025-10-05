import 'package:flutter/material.dart';
import 'package:pequelog/core/services/image_picker_service.dart';
import 'package:pequelog/l10n/app_localizations.dart';
import 'package:pequelog/presentation/features/babies/widgets/new_baby_form.dart';
import 'package:pequelog/presentation/features/startup/baby_state.dart';
import 'package:provider/provider.dart';

typedef DatePickerLauncher =
    Future<DateTime?> Function(BuildContext context, DateTime initialDate);

typedef TimePickerLauncher =
    Future<TimeOfDay?> Function(BuildContext context, TimeOfDay initialTime);

Future<DateTime?> _defaultDatePicker(
  BuildContext context,
  DateTime initialDate,
) {
  final now = DateTime.now();
  final l10n = AppLocalizations.of(context)!;
  return showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: now.subtract(const Duration(days: 3650)),
    lastDate: now,
    helpText: l10n.newBabyBirthDatePickerHelp,
    locale: Localizations.localeOf(context),
    initialEntryMode: DatePickerEntryMode.calendarOnly,
  );
}

Future<TimeOfDay?> _defaultTimePicker(
  BuildContext context,
  TimeOfDay initialTime,
) {
  final l10n = AppLocalizations.of(context)!;
  return showTimePicker(
    context: context,
    initialTime: initialTime,
    helpText: l10n.newBabyBirthTimePickerHelp,
    builder: (context, child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child ?? const SizedBox.shrink(),
      );
    },
  );
}

/// Form that lets caregivers register a new baby quickly.
class NewBabyScreen extends StatelessWidget {
  /// Creates the new baby screen with the provided dependencies.
  const NewBabyScreen({
    super.key,
    required this.imagePicker,
    DatePickerLauncher? datePicker,
    TimePickerLauncher? timePicker,
  }) : datePicker = datePicker ?? _defaultDatePicker,
       timePicker = timePicker ?? _defaultTimePicker;

  /// Service in charge of picking and storing the photo locally.
  final ImagePickerService imagePicker;

  /// Launcher used to show a calendar selector.
  final DatePickerLauncher datePicker;

  /// Launcher used to show a time selector.
  final TimePickerLauncher timePicker;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.newBabyTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: NewBabyForm(
            imagePicker: imagePicker,
            datePicker: datePicker,
            timePicker: timePicker,
            onSubmit: (draft) async {
              await context.read<BabyState>().addBaby(draft);
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
        ),
      ),
    );
  }
}
