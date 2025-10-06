import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pequelog/domain/baby_actions/entities/baby_action.dart';
import 'package:pequelog/domain/baby_actions/entities/baby_action_kind.dart';
import 'package:pequelog/l10n/app_localizations.dart';
import 'package:pequelog/presentation/features/baby_actions/action_pickers.dart';
import 'package:pequelog/presentation/features/baby_actions/baby_actions_state.dart';
import 'package:pequelog/presentation/features/baby_actions/feed_timer_state.dart';
import 'package:pequelog/presentation/features/babies/new_baby_screen.dart';
import 'package:pequelog/presentation/widgets/action_day_selector.dart';
import 'package:provider/provider.dart';

/// Form that lets caregivers log feeding sessions quickly.
class FeedActionScreen extends StatefulWidget {
  /// Creates the feed action form using the optional pickers.
  const FeedActionScreen({
    super.key,
    this.timePicker,
    this.datePicker,
    this.initialAction,
  });

  /// Optional override for the time picker (used in tests).
  final TimePickerLauncher? timePicker;
  final DatePickerLauncher? datePicker;
  final BabyAction? initialAction;

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
  DateTime? _lastSyncedTimerStart;
  Duration? _initialDuration;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);
    _selectedTime = TimeOfDay.fromDateTime(now);
    _timeController = TextEditingController();
    _amountController = TextEditingController();
    _notesController = TextEditingController();

    final initialAction = widget.initialAction;
    if (initialAction != null) {
      final occurredAt = initialAction.occurredAt;
      _selectedDate = DateTime(occurredAt.year, occurredAt.month, occurredAt.day);
      _selectedTime = TimeOfDay.fromDateTime(occurredAt);
      final amount = (initialAction.details['amountMl'] as num?)?.toDouble();
      if (amount != null) {
        _amountController.text = amount.truncateToDouble() == amount
            ? amount.toStringAsFixed(0)
            : amount.toStringAsFixed(2);
      }
      final notes = initialAction.notes;
      if (notes != null) {
        _notesController.text = notes;
      }
      final durationSeconds = initialAction.details['durationSeconds'] as int?;
      if (durationSeconds != null) {
        _initialDuration = Duration(seconds: durationSeconds);
      }
    }
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

  Future<bool> _submit({
    DateTime? occurredAtOverride,
    Duration? duration,
  }) async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return false;
    }

    final l10n = AppLocalizations.of(context)!;

    final amount = double.tryParse(
      _amountController.text.trim().replaceAll(',', '.'),
    );
    if (amount == null || amount <= 0) {
      _showError(l10n.feedAmountError);
      return false;
    }

    final timeText = _timeController.text.trim();
    final parsedTime = _parseManualTime(timeText);
    if (parsedTime == null) {
      _showError(l10n.feedTimeInvalid);
      return false;
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

    final submissionDuration =
        duration ?? (widget.initialAction != null ? _initialDuration : null);

    final notesText = _notesController.text.trim();
    final normalizedNotes = notesText.isEmpty ? null : notesText;

    setState(() => _isSaving = true);
    try {
      final actionsState = context.read<BabyActionsState>();
      if (widget.initialAction != null) {
        await actionsState.updateFeed(
          actionId: widget.initialAction!.id,
          occurredAt: occurredAt,
          amountMl: amount,
          notes: normalizedNotes,
          duration: submissionDuration,
        );
        _initialDuration = submissionDuration;
        if (!mounted) {
          return true;
        }
        Navigator.of(context).pop(l10n.feedActionUpdateSuccess);
      } else {
        await actionsState.logFeed(
          occurredAt: occurredAt,
          amountMl: amount,
          notes: normalizedNotes,
          duration: submissionDuration,
        );
        if (!mounted) {
          return true;
        }
        Navigator.of(context).pop(l10n.feedActionSuccess);
      }
      return true;
    } catch (_) {
      if (mounted) {
        _showError(l10n.feedActionError);
      }
      return false;
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _handleSubmit() async {
    await _submit();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final timerState = context.watch<FeedTimerState>();
    final actionsState = context.watch<BabyActionsState>();
    final timerStart = timerState.startedAt;
    if (timerStart != null) {
      final lastSynced = _lastSyncedTimerStart;
      if (lastSynced == null || !timerStart.isAtSameMomentAs(lastSynced)) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) {
            return;
          }
          setState(() {
            _selectedDate =
                DateTime(timerStart.year, timerStart.month, timerStart.day);
            _selectedTime = TimeOfDay.fromDateTime(timerStart);
            _updateTimeLabel();
            _lastSyncedTimerStart = timerStart;
          });
        });
      }
    } else if (_lastSyncedTimerStart != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        setState(() {
          _lastSyncedTimerStart = null;
        });
      });
    }

    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final material = MaterialLocalizations.of(context);
    final title =
        widget.initialAction == null ? l10n.babyActionFeed : l10n.feedActionEditTitle;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ActionDaySelector(
                  label: '', // Removed redundant label
                  selectedDate: _selectedDate,
                  onPickDay: _pickDate,
                  onPreviousDay: () => _changeDay(-1),
                  onNextDay: () => _changeDay(1),
                  previousTooltip: l10n.feedDayPrevious,
                  nextTooltip: l10n.feedDayNext,
                  pickerTooltip: l10n.feedDayPickerTooltip,
                  previousButtonKey: const Key('feed_day_previous'),
                  nextButtonKey: const Key('feed_day_next'),
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
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
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      flex: 0,
                      child: SizedBox(
                        height: 56,
                        child: OutlinedButton.icon(
                          key: const Key('feed_timer_start'),
                          onPressed: widget.initialAction != null || timerState.isActive
                              ? null
                              : _startTimer,
                          icon: const Icon(Icons.play_arrow_rounded),
                          label: Text(l10n.feedTimerStart),
                        ),
                      ),
                    ),
                  ],
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
                _buildTimerSection(l10n, theme, timerState),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _isSaving ? null : _handleSubmit,
                    child: _isSaving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(
                            widget.initialAction == null
                                ? l10n.feedActionSubmit
                                : l10n.feedActionUpdate,
                          ),
                  ),
                ),
                _buildFeedTimelineSection(
                  l10n,
                  theme,
                  material,
                  actionsState,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimerSection(
    AppLocalizations l10n,
    ThemeData theme,
    FeedTimerState timerState,
  ) {
    final textTheme = theme.textTheme;

    if (!timerState.isActive) {
      if (widget.initialAction != null && _initialDuration != null) {
        final durationText = _formatDuration(_initialDuration!);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.feedTimerTitle,
              style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.feedTimerRecordedDuration(durationText),
              style: textTheme.bodyMedium,
            ),
          ],
        );
      }
      return const SizedBox.shrink();
    }

    final timerText = _formatDuration(timerState.elapsed);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.feedTimerTitle,
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
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
                        onPressed: timerState.isRunning ? _pauseTimer : _resumeTimer,
                        icon: Icon(
                          timerState.isRunning
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                        ),
                        label: Text(
                          timerState.isRunning
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
    );
  }

  Widget _buildFeedTimelineSection(
    AppLocalizations l10n,
    ThemeData theme,
    MaterialLocalizations material,
    BabyActionsState actionsState,
  ) {
    final feeds = actionsState.recentActions
        .where(
          (action) =>
              action.kind == BabyActionKind.feed &&
              _isSameDay(action.occurredAt, _selectedDate),
        )
        .toList()
      ..sort((a, b) => a.occurredAt.compareTo(b.occurredAt));

    if (feeds.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.feedTimelineTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.feedTimelineEmpty,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ],
        ),
      );
    }

    final entries = <Widget>[];
    for (var index = 0; index < feeds.length; index++) {
      final action = feeds[index];
      final timeLabel = material.formatTimeOfDay(
        TimeOfDay.fromDateTime(action.occurredAt),
        alwaysUse24HourFormat: true,
      );
      final amount = (action.details['amountMl'] as num?)?.toDouble();
      final amountLabel =
          amount != null ? l10n.feedTimelineAmountLabel(_formatAmount(amount)) : null;
      final durationSeconds = action.details['durationSeconds'] as int?;
      final durationLabel = durationSeconds != null && durationSeconds > 0
          ? l10n.feedTimelineDurationLabel(
              _formatDuration(Duration(seconds: durationSeconds)),
            )
          : null;
      final notes = action.notes?.trim();
      final showConnector = index < feeds.length - 1;
      final gapLabel = showConnector
          ? _buildGapLabel(
              feeds[index + 1].occurredAt.difference(action.occurredAt),
              l10n,
            )
          : null;

      entries.add(
        _FeedTimelineEntry(
          timeLabel: timeLabel,
          amountLabel: amountLabel,
          durationLabel: durationLabel,
          notes: notes?.isEmpty ?? true ? null : notes,
          showConnector: showConnector,
          connectorLabel: gapLabel,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.feedTimelineTitle,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ...entries,
        ],
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _formatAmount(double amount) {
    final text = amount.toStringAsFixed(2);
    if (text.endsWith('.00')) {
      return text.substring(0, text.length - 3);
    }
    if (text.endsWith('0')) {
      return text.substring(0, text.length - 1);
    }
    return text;
  }

  String? _buildGapLabel(Duration gap, AppLocalizations l10n) {
    if (gap.isNegative) {
      return null;
    }
    if (gap.inSeconds < 60) {
      return l10n.feedTimelineGapLabel(l10n.feedTimelineGapShort);
    }
    final hours = gap.inHours;
    final minutes = gap.inMinutes.remainder(60);
    final parts = <String>[];
    if (hours > 0) {
      parts.add('$hours h');
    }
    if (minutes > 0) {
      parts.add('$minutes min');
    }
    final label = parts.isEmpty ? l10n.feedTimelineGapShort : parts.join(' ');
    return l10n.feedTimelineGapLabel(label);
  }

  void _hydrateInitialTimeLabel() {
    if (_timeController.text.isNotEmpty) {
      return;
    }
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
    final actionsState = context.read<BabyActionsState>();
    final babyId = actionsState.babyId;
    if (babyId == null) {
      return;
    }
    final now = DateTime.now();
    context.read<FeedTimerState>().start(babyId: babyId, startTime: now);
    setState(() {
      _selectedDate = DateTime(now.year, now.month, now.day);
      _selectedTime = TimeOfDay.fromDateTime(now);
      _initialDuration = null;
      _lastSyncedTimerStart = now;
      _updateTimeLabel();
    });
  }

  void _pauseTimer() {
    context.read<FeedTimerState>().pause();
  }

  void _resumeTimer() {
    context.read<FeedTimerState>().resume();
  }

  Future<void> _finishTimer() async {
    final timerState = context.read<FeedTimerState>();
    final snapshot = timerState.finish();
    if (snapshot == null) {
      return;
    }
    final success = await _submit(
      occurredAtOverride: snapshot.startedAt,
      duration: snapshot.elapsed,
    );
    if (!success) {
      timerState.restore(snapshot, resume: snapshot.wasRunning);
    }
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    if (hours > 0) {
      final hoursLabel = hours.toString().padLeft(2, '0');
      return '$hoursLabel:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }
}

class _FeedTimelineEntry extends StatelessWidget {
  const _FeedTimelineEntry({
    required this.timeLabel,
    this.amountLabel,
    this.durationLabel,
    this.notes,
    required this.showConnector,
    this.connectorLabel,
  });

  final String timeLabel;
  final String? amountLabel;
  final String? durationLabel;
  final String? notes;
  final bool showConnector;
  final String? connectorLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final outline = theme.colorScheme.outlineVariant;
    final notesLabel = AppLocalizations.of(context)!.actionNotesLabel;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 32,
              child: Column(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    timeLabel,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (amountLabel != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      amountLabel!,
                      style: textTheme.bodyMedium,
                    ),
                  ],
                  if (durationLabel != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      durationLabel!,
                      style: textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                  if (notes != null && notes!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      '$notesLabel: ${notes!}',
                      style: textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        if (showConnector) ...[
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 32,
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 2,
                    height: 36,
                    color: outline,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  connectorLabel ?? '',
                  style: textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ] else
          const SizedBox(height: 16),
      ],
    );
  }
}
