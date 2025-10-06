import 'package:flutter/material.dart';
import 'package:pequelog/domain/baby_actions/entities/vomit_severity.dart';
import 'package:pequelog/l10n/app_localizations.dart';
import 'package:pequelog/presentation/features/baby_actions/action_pickers.dart';
import 'package:pequelog/presentation/features/baby_actions/baby_actions_state.dart';
import 'package:pequelog/presentation/features/babies/new_baby_screen.dart';
import 'package:pequelog/presentation/widgets/action_day_selector.dart';
import 'package:provider/provider.dart';

/// Form used to capture vomit events and their severity.
class VomitActionScreen extends StatefulWidget {
  /// Creates the vomit action form using optional pickers for tests.
  const VomitActionScreen({
    super.key,
    this.datePicker,
    this.timePicker,
  });

  final DatePickerLauncher? datePicker;
  final TimePickerLauncher? timePicker;

  @override
  State<VomitActionScreen> createState() => _VomitActionScreenState();
}

class _VomitActionScreenState extends State<VomitActionScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _timeController;
  late final TextEditingController _notesController;

  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  VomitSeverity _severity = VomitSeverity.moderate;
  bool _hydratedInitialFields = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);
    _selectedTime = TimeOfDay.fromDateTime(now);
    _timeController = TextEditingController();
    _notesController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_hydratedInitialFields) {
      return;
    }
    final material = MaterialLocalizations.of(context);
    _timeController.text = material.formatTimeOfDay(
      _selectedTime,
      alwaysUse24HourFormat: true,
    );
    _hydratedInitialFields = true;
  }

  @override
  void dispose() {
    _timeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    FocusScope.of(context).unfocus();
    final launcher = widget.datePicker ?? defaultActionDatePicker;
    final picked = await launcher(context, _selectedDate);
    if (!mounted || picked == null) {
      return;
    }
    setState(() {
      _selectedDate = DateTime(picked.year, picked.month, picked.day);
    });
  }

  Future<void> _pickTime() async {
    FocusScope.of(context).unfocus();
    final launcher = widget.timePicker ?? defaultActionTimePicker;
    final picked = await launcher(context, _selectedTime);
    if (!mounted || picked == null) {
      return;
    }
    setState(() {
      _selectedTime = picked;
      final material = MaterialLocalizations.of(context);
      _timeController.text = material.formatTimeOfDay(
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

    final occurredAt = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final notes = _notesController.text.trim().isEmpty
        ? null
        : _notesController.text.trim();

    final l10n = AppLocalizations.of(context)!;

    setState(() => _isSaving = true);
    try {
      await context.read<BabyActionsState>().logVomit(
            occurredAt: occurredAt,
            severity: _severity,
            notes: notes,
          );
      if (!mounted) {
        return;
      }
      Navigator.of(context).pop(l10n.vomitActionSuccess);
    } catch (_) {
      if (mounted) {
        _showError(l10n.vomitActionError);
      }
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
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.babyActionVomited)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ActionDaySelector(
                  label: l10n.actionDateLabel,
                  selectedDate: _selectedDate,
                  onPickDay: _pickDate,
                  onPreviousDay: () => _changeDay(-1),
                  onNextDay: () => _changeDay(1),
                  previousTooltip: l10n.actionDayPrevious,
                  nextTooltip: l10n.actionDayNext,
                  pickerTooltip: l10n.actionDayPickerTooltip,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  key: const Key('vomit_time'),
                  controller: _timeController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: l10n.actionTimeLabel,
                    hintText: l10n.actionTimeHint,
                  ),
                  onTap: _pickTime,
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.vomitSeverityLabel,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  children: VomitSeverity.values
                      .map(
                        (severity) => ChoiceChip(
                          label: Text(_severityLabel(severity, l10n)),
                          selected: _severity == severity,
                          onSelected: (selected) {
                            if (!selected) {
                              return;
                            }
                            setState(() => _severity = severity);
                          },
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  key: const Key('vomit_notes'),
                  controller: _notesController,
                  decoration: InputDecoration(
                    labelText: l10n.actionNotesLabel,
                    hintText: l10n.actionNotesHint,
                  ),
                  minLines: 2,
                  maxLines: 4,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    key: const Key('vomit_submit'),
                    onPressed: _isSaving ? null : _submit,
                    child: _isSaving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(l10n.vomitActionSubmit),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _changeDay(int delta) {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: delta));
    });
  }

  String _severityLabel(VomitSeverity severity, AppLocalizations l10n) {
    switch (severity) {
      case VomitSeverity.mild:
        return l10n.vomitSeverityMild;
      case VomitSeverity.moderate:
        return l10n.vomitSeverityModerate;
      case VomitSeverity.intense:
        return l10n.vomitSeverityIntense;
    }
  }
}
