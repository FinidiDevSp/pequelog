import 'package:flutter/material.dart';
import 'package:pequelog/domain/baby_actions/entities/stool_texture.dart';
import 'package:pequelog/l10n/app_localizations.dart';
import 'package:pequelog/presentation/features/baby_actions/action_pickers.dart';
import 'package:pequelog/presentation/features/baby_actions/baby_actions_state.dart';
import 'package:pequelog/presentation/features/babies/new_baby_screen.dart';
import 'package:provider/provider.dart';

/// Form that registers diaper changes with stool details.
class DiaperActionScreen extends StatefulWidget {
  /// Creates the diaper form with optional pickers (useful in tests).
  const DiaperActionScreen({
    super.key,
    this.datePicker,
    this.timePicker,
  });

  final DatePickerLauncher? datePicker;
  final TimePickerLauncher? timePicker;

  @override
  State<DiaperActionScreen> createState() => _DiaperActionScreenState();
}

class _DiaperActionScreenState extends State<DiaperActionScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _dateController;
  late final TextEditingController _timeController;
  late final TextEditingController _notesController;

  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  StoolTexture _texture = StoolTexture.soft;
  bool _hadPee = false;
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
    _notesController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_hydratedInitialFields) {
      return;
    }
    final material = MaterialLocalizations.of(context);
    _dateController.text = material.formatMediumDate(_selectedDate);
    _timeController.text = material.formatTimeOfDay(
      _selectedTime,
      alwaysUse24HourFormat: true,
    );
    _hydratedInitialFields = true;
  }

  @override
  void dispose() {
    _dateController.dispose();
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

    final occurredAt = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final l10n = AppLocalizations.of(context)!;
    final notes = _notesController.text.trim().isEmpty
        ? null
        : _notesController.text.trim();

    setState(() => _isSaving = true);
    try {
      await context.read<BabyActionsState>().logDiaper(
            occurredAt: occurredAt,
            texture: _texture,
            hadPee: _hadPee,
            notes: notes,
          );
      if (!mounted) {
        return;
      }
      Navigator.of(context).pop(l10n.diaperActionSuccess);
    } catch (_) {
      if (mounted) {
        _showError(l10n.diaperActionError);
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
      appBar: AppBar(title: Text(l10n.babyActionDiaper)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  key: const Key('diaper_date'),
                  controller: _dateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: l10n.actionDateLabel,
                    hintText: l10n.actionDateHint,
                  ),
                  onTap: _pickDate,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  key: const Key('diaper_time'),
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
                  l10n.diaperTextureLabel,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  children: StoolTexture.values
                      .map(
                        (texture) => ChoiceChip(
                          label: Text(_textureLabel(texture, l10n)),
                          selected: _texture == texture,
                          onSelected: (selected) {
                            if (!selected) {
                              return;
                            }
                            setState(() => _texture = texture);
                          },
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 16),
                SwitchListTile.adaptive(
                  value: _hadPee,
                  onChanged: (value) => setState(() => _hadPee = value),
                  title: Text(l10n.diaperPeeLabel),
                  contentPadding: EdgeInsets.zero,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  key: const Key('diaper_notes'),
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
                    key: const Key('diaper_submit'),
                    onPressed: _isSaving ? null : _submit,
                    child: _isSaving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(l10n.diaperActionSubmit),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _textureLabel(StoolTexture texture, AppLocalizations l10n) {
    switch (texture) {
      case StoolTexture.liquid:
        return l10n.diaperTextureLiquid;
      case StoolTexture.soft:
        return l10n.diaperTextureSoft;
      case StoolTexture.solid:
        return l10n.diaperTextureSolid;
    }
  }
}
