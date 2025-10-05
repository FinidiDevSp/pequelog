import 'package:flutter/material.dart';
import 'package:pequelog/domain/baby_actions/entities/feed_method.dart';
import 'package:pequelog/l10n/app_localizations.dart';
import 'package:pequelog/presentation/features/baby_actions/baby_actions_state.dart';
import 'package:pequelog/presentation/features/baby_actions/action_pickers.dart';
import 'package:pequelog/presentation/features/babies/new_baby_screen.dart';
import 'package:provider/provider.dart';

/// Form that lets caregivers log feeding sessions quickly.
class FeedActionScreen extends StatefulWidget {
  /// Creates the feed action form using the optional pickers.
  const FeedActionScreen({
    super.key,
    this.datePicker,
    this.timePicker,
  });

  /// Optional override for the date picker (used in tests).
  final DatePickerLauncher? datePicker;

  /// Optional override for the time picker (used in tests).
  final TimePickerLauncher? timePicker;

  @override
  State<FeedActionScreen> createState() => _FeedActionScreenState();
}

class _FeedActionScreenState extends State<FeedActionScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _dateController;
  late final TextEditingController _timeController;
  late final TextEditingController _amountController;
  late final TextEditingController _notesController;

  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  FeedMethod? _selectedMethod = FeedMethod.bottle;
  bool _hydratedInitialFields = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);
    _selectedTime = TimeOfDay.fromDateTime(now);
    _dateController = TextEditingController();
    _timeController = TextEditingController();
    _amountController = TextEditingController();
    _notesController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_hydratedInitialFields) {
      return;
    }
    final localizations = MaterialLocalizations.of(context);
    _dateController.text = localizations.formatMediumDate(_selectedDate);
    _timeController.text = localizations.formatTimeOfDay(
      _selectedTime,
      alwaysUse24HourFormat: true,
    );
    _hydratedInitialFields = true;
  }

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    _amountController.dispose();
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
      final material = MaterialLocalizations.of(context);
      _dateController.text = material.formatMediumDate(_selectedDate);
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
    final method = _selectedMethod;
    if (method == null) {
      _showError(l10n.feedMethodError);
      return;
    }

    final amount = double.tryParse(
      _amountController.text.trim().replaceAll(',', '.'),
    );
    if (amount == null || amount <= 0) {
      _showError(l10n.feedAmountError);
      return;
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
      await context.read<BabyActionsState>().logFeed(
            occurredAt: occurredAt,
            method: method,
            amountMl: amount,
            notes: _notesController.text.trim().isEmpty
                ? null
                : _notesController.text.trim(),
          );
      if (!mounted) {
        return;
      }
      Navigator.of(context).pop(l10n.feedActionSuccess);
    } catch (_) {
      if (mounted) {
        _showError(l10n.feedActionError);
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
      appBar: AppBar(title: Text(l10n.babyActionFeed)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  key: const Key('feed_date'),
                  controller: _dateController,
                  decoration: InputDecoration(
                    labelText: l10n.actionDateLabel,
                    hintText: l10n.actionDateHint,
                  ),
                  readOnly: true,
                  onTap: _pickDate,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  key: const Key('feed_time'),
                  controller: _timeController,
                  decoration: InputDecoration(
                    labelText: l10n.actionTimeLabel,
                    hintText: l10n.actionTimeHint,
                  ),
                  readOnly: true,
                  onTap: _pickTime,
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.feedMethodLabel,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  children: FeedMethod.values
                      .map(
                        (method) => ChoiceChip(
                          label: Text(_methodLabel(method, l10n)),
                          selected: _selectedMethod == method,
                          onSelected: (selected) {
                            if (!selected) {
                              return;
                            }
                            setState(() => _selectedMethod = method);
                          },
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  key: const Key('feed_amount'),
                  controller: _amountController,
                  decoration: InputDecoration(
                    labelText: l10n.feedAmountLabel,
                    hintText: l10n.feedAmountHint,
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.feedAmountRequired;
                    }
                    final parsed = double.tryParse(
                      value.trim().replaceAll(',', '.'),
                    );
                    if (parsed == null || parsed <= 0) {
                      return l10n.feedAmountError;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  key: const Key('feed_notes'),
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
                    key: const Key('feed_submit'),
                    onPressed: _isSaving ? null : _submit,
                    child: _isSaving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(l10n.feedActionSubmit),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _methodLabel(FeedMethod method, AppLocalizations l10n) {
    switch (method) {
      case FeedMethod.breast:
        return l10n.feedMethodBreast;
      case FeedMethod.bottle:
        return l10n.feedMethodBottle;
      case FeedMethod.mixed:
        return l10n.feedMethodMixed;
    }
  }
}
