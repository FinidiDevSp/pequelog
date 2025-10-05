import 'package:flutter/material.dart';
import 'package:pequelog/core/services/image_picker_service.dart';
import 'package:pequelog/domain/babies/entities/baby_draft.dart';
import 'package:pequelog/domain/babies/entities/baby_sex.dart';
import 'package:pequelog/l10n/app_localizations.dart';

import '../new_baby_screen.dart';

/// Reusable form that gathers the data required to create or edit a baby.
class NewBabyForm extends StatefulWidget {
  const NewBabyForm({
    super.key,
    required this.imagePicker,
    required this.datePicker,
    required this.timePicker,
    required this.onSubmit,
    this.initialDraft,
  });

  /// Service used to pick a photo from the device.
  final ImagePickerService imagePicker;

  /// Launcher used to show a calendar selector.
  final DatePickerLauncher datePicker;

  /// Launcher used to show a time selector.
  final TimePickerLauncher timePicker;

  /// Callback executed with the collected [BabyDraft] when the form is valid.
  final Future<void> Function(BabyDraft draft) onSubmit;

  /// Optional initial values when editing a baby.
  final BabyDraft? initialDraft;

  @override
  State<NewBabyForm> createState() => _NewBabyFormState();
}

class _NewBabyFormState extends State<NewBabyForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _birthDateController;
  late final TextEditingController _birthTimeController;
  late final TextEditingController _lengthController;
  late final TextEditingController _weightController;

  DateTime? _selectedBirthDate;
  TimeOfDay? _selectedBirthTime;
  BabySex? _selectedSex;
  String? _photoPath;
  bool _isSaving = false;
  bool _hydratedInitialControllers = false;

  @override
  void initState() {
    super.initState();
    final draft = widget.initialDraft;
    _nameController = TextEditingController(text: draft?.name ?? '');
    _birthDateController = TextEditingController();
    _birthTimeController = TextEditingController();
    _lengthController = TextEditingController(
      text: draft != null ? draft.birthLengthCm.toStringAsFixed(1) : '',
    );
    _weightController = TextEditingController(
      text: draft != null ? draft.birthWeightKg.toStringAsFixed(2) : '',
    );

    if (draft != null) {
      _selectedBirthDate = DateTime(
        draft.birthDateTime.year,
        draft.birthDateTime.month,
        draft.birthDateTime.day,
      );
      _selectedBirthTime = TimeOfDay.fromDateTime(draft.birthDateTime);
      _selectedSex = draft.sex;
      _photoPath = draft.photoPath;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_hydratedInitialControllers) {
      return;
    }
    final materialLocalizations = MaterialLocalizations.of(context);
    if (_selectedBirthDate != null) {
      _birthDateController.text = materialLocalizations.formatMediumDate(
        _selectedBirthDate!,
      );
    }
    if (_selectedBirthTime != null) {
      _birthTimeController.text = materialLocalizations.formatTimeOfDay(
        _selectedBirthTime!,
        alwaysUse24HourFormat: true,
      );
    }
    _hydratedInitialControllers = true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthDateController.dispose();
    _birthTimeController.dispose();
    _lengthController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final path = await widget.imagePicker.pickImage();
    if (!mounted) {
      return;
    }
    setState(() {
      _photoPath = path;
    });
  }

  Future<void> _pickBirthDate() async {
    FocusScope.of(context).unfocus();
    final materialLocalizations = MaterialLocalizations.of(context);
    final initial = _selectedBirthDate ?? DateTime.now();
    final picked = await widget.datePicker(context, initial);
    if (!mounted || picked == null) {
      return;
    }
    setState(() {
      _selectedBirthDate = DateTime(picked.year, picked.month, picked.day);
      _birthDateController.text = materialLocalizations.formatMediumDate(
        _selectedBirthDate!,
      );
    });
  }

  Future<void> _pickBirthTime() async {
    FocusScope.of(context).unfocus();
    final materialLocalizations = MaterialLocalizations.of(context);
    final initial = _selectedBirthTime ?? TimeOfDay.now();
    final picked = await widget.timePicker(context, initial);
    if (!mounted || picked == null) {
      return;
    }
    setState(() {
      _selectedBirthTime = picked;
      _birthTimeController.text = materialLocalizations.formatTimeOfDay(
        picked,
        alwaysUse24HourFormat: true,
      );
    });
  }

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    final l10n = AppLocalizations.of(context)!;
    final birthDate = _selectedBirthDate;
    final birthTime = _selectedBirthTime;

    if (birthDate == null) {
      _showError(l10n.newBabyBirthDateError);
      return;
    }

    if (birthTime == null) {
      _showError(l10n.newBabyBirthTimeError);
      return;
    }

    final length = double.tryParse(
      _lengthController.text.trim().replaceAll(',', '.'),
    );
    final weight = double.tryParse(
      _weightController.text.trim().replaceAll(',', '.'),
    );
    final sex = _selectedSex;

    if (length == null || length <= 0) {
      _showError(l10n.newBabyLengthInvalid);
      return;
    }

    if (weight == null || weight <= 0) {
      _showError(l10n.newBabyWeightInvalid);
      return;
    }

    if (sex == null) {
      _showError(l10n.newBabySelectSexError);
      return;
    }

    setState(() => _isSaving = true);

    final birthDateTime = DateTime(
      birthDate.year,
      birthDate.month,
      birthDate.day,
      birthTime.hour,
      birthTime.minute,
    );

    final draft = BabyDraft(
      name: _nameController.text.trim(),
      birthDateTime: birthDateTime,
      sex: sex,
      birthLengthCm: length,
      birthWeightKg: weight,
      photoPath: _photoPath,
    );

    try {
      await widget.onSubmit(draft);
    } catch (_) {
      _showError(l10n.newBabySaveError);
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            key: const Key('newBaby_name'),
            controller: _nameController,
            decoration: InputDecoration(labelText: l10n.newBabyNameLabel),
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.newBabyNameError;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            key: const Key('newBaby_birthDate'),
            controller: _birthDateController,
            decoration: InputDecoration(
              labelText: l10n.newBabyBirthDateLabel,
              hintText: l10n.newBabyBirthDateHint,
            ),
            readOnly: true,
            onTap: _pickBirthDate,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.newBabyBirthDateError;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            key: const Key('newBaby_birthTime'),
            controller: _birthTimeController,
            decoration: InputDecoration(
              labelText: l10n.newBabyBirthTimeLabel,
              hintText: l10n.newBabyBirthTimeHint,
            ),
            readOnly: true,
            onTap: _pickBirthTime,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.newBabyBirthTimeError;
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          Text(
            l10n.newBabySexLabel,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _SexOptionButton(
                  key: const Key('newBaby_sex_female'),
                  label: l10n.newBabySexFemale,
                  icon: Icons.girl_outlined,
                  isSelected: _selectedSex == BabySex.female,
                  onPressed: () =>
                      setState(() => _selectedSex = BabySex.female),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SexOptionButton(
                  key: const Key('newBaby_sex_male'),
                  label: l10n.newBabySexMale,
                  icon: Icons.boy_outlined,
                  isSelected: _selectedSex == BabySex.male,
                  onPressed: () => setState(() => _selectedSex = BabySex.male),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          TextFormField(
            key: const Key('newBaby_length'),
            controller: _lengthController,
            decoration: InputDecoration(labelText: l10n.newBabyLengthLabel),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.newBabyLengthError;
              }
              if (double.tryParse(value.trim().replaceAll(',', '.')) == null) {
                return l10n.newBabyLengthInvalid;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            key: const Key('newBaby_weight'),
            controller: _weightController,
            decoration: InputDecoration(labelText: l10n.newBabyWeightLabel),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.done,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.newBabyWeightError;
              }
              if (double.tryParse(value.trim().replaceAll(',', '.')) == null) {
                return l10n.newBabyWeightInvalid;
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            key: const Key('newBaby_pickPhoto'),
            onPressed: _pickPhoto,
            icon: const Icon(Icons.photo_camera_back_outlined),
            label: Text(
              _photoPath == null
                  ? l10n.newBabyPhotoButtonNoSelection
                  : l10n.newBabyPhotoButtonSelected,
            ),
          ),
          if (_photoPath != null) ...[
            const SizedBox(height: 8),
            Text(
              _photoPath!,
              style: theme.textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 32),
          ElevatedButton(
            key: const Key('newBaby_submit'),
            onPressed: _isSaving ? null : _submit,
            child: _isSaving
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l10n.newBabySave),
          ),
        ],
      ),
    );
  }
}

class _SexOptionButton extends StatelessWidget {
  const _SexOptionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final background = isSelected
        ? theme.colorScheme.primary.withOpacity(0.12)
        : theme.colorScheme.surfaceVariant;
    final borderColor = isSelected
        ? theme.colorScheme.primary
        : theme.colorScheme.outlineVariant;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
