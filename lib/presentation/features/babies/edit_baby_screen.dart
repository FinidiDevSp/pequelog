import 'package:flutter/material.dart';
import 'package:pequelog/core/services/image_picker_service.dart';
import 'package:pequelog/domain/babies/entities/baby.dart';
import 'package:pequelog/domain/babies/entities/baby_draft.dart';
import 'package:pequelog/l10n/app_localizations.dart';
import 'package:pequelog/presentation/features/babies/new_baby_screen.dart';
import 'package:pequelog/presentation/features/babies/widgets/new_baby_form.dart';
import 'package:pequelog/presentation/features/startup/baby_state.dart';
import 'package:provider/provider.dart';

/// Screen that allows editing an existing baby profile using the shared form.
class EditBabyScreen extends StatelessWidget {
  /// Builds an edit screen bound to the provided [baby].
  const EditBabyScreen({
    super.key,
    required this.baby,
    required this.imagePicker,
    this.datePicker,
    this.timePicker,
  });

  /// Baby currently being edited.
  final Baby baby;

  /// Service used to pick a replacement portrait.
  final ImagePickerService imagePicker;

  /// Optional override for the date picker launcher (primarily for tests).
  final DatePickerLauncher? datePicker;

  /// Optional override for the time picker launcher (primarily for tests).
  final TimePickerLauncher? timePicker;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.editBabyTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: NewBabyForm(
            imagePicker: imagePicker,
            datePicker: datePicker ?? defaultBabyDatePicker,
            timePicker: timePicker ?? defaultBabyTimePicker,
            initialDraft: BabyDraft.fromBaby(baby),
            submitButtonLabel: l10n.editBabySave,
            onSubmit: (draft) async {
              await context.read<BabyState>().updateBaby(baby, draft);
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
