import 'package:flutter/material.dart';
import 'package:pequelog/l10n/app_localizations.dart';
import 'package:pequelog/presentation/features/baby_actions/action_pickers.dart';
import 'package:pequelog/presentation/features/baby_actions/baby_actions_state.dart';
import 'package:pequelog/presentation/features/babies/new_baby_screen.dart';
import 'package:pequelog/presentation/widgets/action_day_selector.dart';
import 'package:provider/provider.dart';

/// Screen that captures bath details for the daily log.
class BathActionScreen extends StatefulWidget {
  /// Creates the bath action form using optional pickers for tests.
  const BathActionScreen({
    super.key,
    this.datePicker,
    this.timePicker,
  });

  final DatePickerLauncher? datePicker;
  final TimePickerLauncher? timePicker;

  @override
  State<BathActionScreen> createState() => _BathActionScreenState();
}

class _BathActionScreenState extends State<BathActionScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _timeController;
  late final TextEditingController _durationController;
  late final TextEditingController _notesController;

  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  bool _hydratedInitialFields = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);
    _selectedTime = TimeOfDay.fromDateTime(now);
    _timeController = TextEditingController();
    _durationController = TextEditingController();
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
    _durationController.dispose();
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

    final l10n = AppLocalizations.of(context)!;
    final durationText = _durationController.text.trim();
    int? duration;
    if (durationText.isNotEmpty) {
      duration = int.tryParse(durationText);
      if (duration == null || duration <= 0) {
        _showError(l10n.bathDurationError);
        return;
      }
    }

    final occurredAt = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    setState(() => _isSaving = true);
    try {
      await context.read<BabyActionsState>().logBath(
            occurredAt: occurredAt,
            durationMinutes: duration,
            notes: _notesController.text.trim().isEmpty
                ? null
                : _notesController.text.trim(),
          );
      if (!mounted) {
        return;
      }
      Navigator.of(context).pop(l10n.bathActionSuccess);
    } catch (_) {
      if (mounted) {
        _showError(l10n.bathActionError);
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

    return Scaffold(
      appBar: AppBar(title: Text(l10n.babyActionBath)),
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
                  key: const Key('bath_time'),
                  controller: _timeController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: l10n.actionTimeLabel,
                    hintText: l10n.actionTimeHint,
                  ),
                  onTap: _pickTime,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  key: const Key('bath_duration'),
                  controller: _durationController,
                  decoration: InputDecoration(
                    labelText: l10n.bathDurationLabel,
                    hintText: l10n.bathDurationHint,
                    helperText: l10n.bathDurationHelper,
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  key: const Key('bath_notes'),
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
                    key: const Key('bath_submit'),
                    onPressed: _isSaving ? null : _submit,
                    child: _isSaving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(l10n.bathActionSubmit),
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
}
