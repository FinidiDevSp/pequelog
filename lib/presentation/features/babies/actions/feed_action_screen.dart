import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pequelog/l10n/app_localizations.dart';
import 'package:pequelog/presentation/features/baby_actions/action_pickers.dart';
import 'package:pequelog/presentation/features/baby_actions/baby_actions_state.dart';
import 'package:pequelog/presentation/features/babies/new_baby_screen.dart';
import 'package:provider/provider.dart';

/// Form that lets caregivers log feeding sessions quickly.
class FeedActionScreen extends StatefulWidget {
  /// Creates the feed action form using the optional pickers.
  const FeedActionScreen({
    super.key,
    this.timePicker,
  });

  /// Optional override for the time picker (used in tests).
  final TimePickerLauncher? timePicker;

  @override
  State<FeedActionScreen> createState() => _FeedActionScreenState();
}

class _FeedActionScreenState extends State<FeedActionScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _timeController;
  late final TextEditingController _amountController;
  late final TextEditingController _notesController;

  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  bool _isSaving = false;
  Duration _timerElapsed = Duration.zero;
  DateTime? _timerStart;
  DateTime? _lastTick;
  Timer? _ticker;
  bool _isTimerRunning = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);
    _selectedTime = TimeOfDay.fromDateTime(now);
    _timeController = TextEditingController();
    _amountController = TextEditingController();
    _notesController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _hydrateInitialTimeLabel();
  }

  @override
  void dispose() {
    _timeController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    _ticker?.cancel();
    super.dispose();
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
      _updateTimeLabel();
    });
  }

  Future<void> _submit({
    DateTime? occurredAtOverride,
    Duration? duration,
  }) async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    final l10n = AppLocalizations.of(context)!;

    final amount = double.tryParse(
      _amountController.text.trim().replaceAll(',', '.'),
    );
    if (amount == null || amount <= 0) {
      _showError(l10n.feedAmountError);
      return;
    }

    final timeText = _timeController.text.trim();
    final parsedTime = _parseManualTime(timeText);
    if (parsedTime == null) {
      _showError(l10n.feedTimeInvalid);
      return;
    }

    _selectedTime = parsedTime;

    final occurredAt = occurredAtOverride ??
        DateTime(
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
            amountMl: amount,
            notes: _notesController.text.trim().isEmpty
                ? null
                : _notesController.text.trim(),
            duration: duration,
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
    final material = MaterialLocalizations.of(context);
    final dayLabel = material.formatMediumDate(_selectedDate);

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
                Text(
                  l10n.feedDaySelectorLabel,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: theme.colorScheme.outlineVariant,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        IconButton(
                          key: const Key('feed_day_previous'),
                          tooltip: l10n.feedDayPrevious,
                          onPressed: () => _changeDay(-1),
                          icon: const Icon(Icons.chevron_left),
                        ),
                        Expanded(
                          child: Text(
                            dayLabel,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
                        IconButton(
                          key: const Key('feed_day_next'),
                          tooltip: l10n.feedDayNext,
                          onPressed: () => _changeDay(1),
                          icon: const Icon(Icons.chevron_right),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  key: const Key('feed_time'),
                  controller: _timeController,
                  decoration: InputDecoration(
                    labelText: l10n.actionTimeLabel,
                    hintText: l10n.actionTimeHint,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.schedule),
                      tooltip: l10n.feedTimePickerTooltip,
                      onPressed: _pickTime,
                    ),
                  ),
                  keyboardType: TextInputType.datetime,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.feedTimeRequired;
                    }
                    if (_parseManualTime(value.trim()) == null) {
                      return l10n.feedTimeInvalid;
                    }
                    return null;
                  },
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
                  maxLines: 5,
                ),
                const SizedBox(height: 24),
                _buildTimerSection(l10n, theme),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
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

  Widget _buildTimerSection(AppLocalizations l10n, ThemeData theme) {
    final isActive = _timerStart != null;
    final textTheme = theme.textTheme;
    final timerText = _formatDuration(_timerElapsed);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.feedTimerTitle,
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        if (!isActive)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              key: const Key('feed_timer_start'),
              onPressed: _startTimer,
              icon: const Icon(Icons.play_arrow_rounded),
              label: Text(l10n.feedTimerStart),
            ),
          )
        else ...[
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: theme.colorScheme.primaryContainer.withOpacity(0.24),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.feedTimerRunningLabel(timerText),
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          key: const Key('feed_timer_toggle'),
                          onPressed: _isTimerRunning ? _pauseTimer : _resumeTimer,
                          icon: Icon(
                            _isTimerRunning
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                          ),
                          label: Text(
                            _isTimerRunning
                                ? l10n.feedTimerPause
                                : l10n.feedTimerResume,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton.icon(
                          key: const Key('feed_timer_finish'),
                          onPressed: _finishTimer,
                          icon: const Icon(Icons.stop_rounded),
                          label: Text(l10n.feedTimerStop),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _hydrateInitialTimeLabel() {
    final material = MaterialLocalizations.of(context);
    _timeController.text = material.formatTimeOfDay(
      _selectedTime,
      alwaysUse24HourFormat: true,
    );
  }

  void _changeDay(int delta) {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: delta));
    });
  }

  void _updateTimeLabel() {
    final material = MaterialLocalizations.of(context);
    _timeController.text = material.formatTimeOfDay(
      _selectedTime,
      alwaysUse24HourFormat: true,
    );
  }

  TimeOfDay? _parseManualTime(String value) {
    final parts = value.split(':');
    if (parts.length != 2) {
      return null;
    }
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) {
      return null;
    }
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
      return null;
    }
    return TimeOfDay(hour: hour, minute: minute);
  }

  void _startTimer() {
    final now = DateTime.now();
    setState(() {
      _timerStart = now;
      _lastTick = now;
      _timerElapsed = Duration.zero;
      _isTimerRunning = true;
      _selectedDate = DateTime(now.year, now.month, now.day);
      _selectedTime = TimeOfDay.fromDateTime(now);
      _updateTimeLabel();
    });
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!_isTimerRunning) {
        return;
      }
      final previousTick = _lastTick;
      final nowTick = DateTime.now();
      setState(() {
        if (previousTick != null) {
          _timerElapsed += nowTick.difference(previousTick);
        }
        _lastTick = nowTick;
      });
    });
  }

  void _pauseTimer() {
    setState(() {
      _isTimerRunning = false;
      _lastTick = null;
    });
  }

  void _resumeTimer() {
    setState(() {
      _isTimerRunning = true;
      _lastTick = DateTime.now();
    });
  }

  Future<void> _finishTimer() async {
    final start = _timerStart;
    final elapsed = _timerElapsed;
    _ticker?.cancel();
    setState(() {
      _isTimerRunning = false;
      _ticker = null;
      _lastTick = null;
    });
    if (start == null) {
      return;
    }
    await _submit(
      occurredAtOverride: start,
      duration: elapsed,
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _timerStart = null;
      _timerElapsed = Duration.zero;
    });
  }

  String _formatDuration(Duration duration) {
    final totalSeconds = duration.inSeconds;
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
