import 'package:flutter/material.dart';
import 'package:pequelog/core/services/image_picker_service.dart';
import 'package:pequelog/domain/babies/entities/baby_draft.dart';
import 'package:pequelog/domain/babies/entities/baby_sex.dart';
import 'package:pequelog/presentation/features/startup/baby_state.dart';
import 'package:provider/provider.dart';

/// Form that lets caregivers register a new baby quickly.
class NewBabyScreen extends StatefulWidget {
  /// Creates the new baby screen with a provided [imagePicker].
  const NewBabyScreen({super.key, required this.imagePicker});

  /// Service in charge of picking and storing the photo locally.
  final ImagePickerService imagePicker;

  @override
  State<NewBabyScreen> createState() => _NewBabyScreenState();
}

class _NewBabyScreenState extends State<NewBabyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _lengthController = TextEditingController();
  final _weightController = TextEditingController();

  BabySex? _selectedSex;
  String? _photoPath;
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _birthDateController.dispose();
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

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    final birthDate = DateTime.tryParse(_birthDateController.text.trim());
    if (birthDate == null) {
      _showError('La fecha debe tener formato AAAA-MM-DD');
      return;
    }

    final length = double.tryParse(_lengthController.text.trim());
    final weight = double.tryParse(_weightController.text.trim());
    final sex = _selectedSex;

    if (length == null || length <= 0) {
      _showError('Introduce una estatura valida');
      return;
    }

    if (weight == null || weight <= 0) {
      _showError('Introduce un peso valido');
      return;
    }

    if (sex == null) {
      _showError('Selecciona el sexo');
      return;
    }

    setState(() => _isSaving = true);

    final draft = BabyDraft(
      name: _nameController.text.trim(),
      birthDate: birthDate,
      sex: sex,
      birthLengthCm: length,
      birthWeightKg: weight,
      photoPath: _photoPath,
    );

    try {
      await context.read<BabyState>().addBaby(draft);
      if (!mounted) {
        return;
      }
      Navigator.of(context).pop();
    } catch (error) {
      _showError('No se pudo guardar. Intenta de nuevo.');
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message)),
      );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo bebe'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  key: const Key('newBaby_name'),
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Introduce un nombre';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  key: const Key('newBaby_birthDate'),
                  controller: _birthDateController,
                  decoration: const InputDecoration(
                    labelText: 'Fecha de nacimiento (AAAA-MM-DD)',
                  ),
                  keyboardType: TextInputType.datetime,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Introduce la fecha de nacimiento';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<BabySex>(
                  key: const Key('newBaby_sex'),
                  value: _selectedSex,
                  items: const [
                    DropdownMenuItem(value: BabySex.female, child: Text('Nina')),
                    DropdownMenuItem(value: BabySex.male, child: Text('Nino')),
                    DropdownMenuItem(value: BabySex.other, child: Text('Otro')),
                  ],
                  onChanged: (value) => setState(() => _selectedSex = value),
                  decoration: const InputDecoration(labelText: 'Sexo'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  key: const Key('newBaby_length'),
                  controller: _lengthController,
                  decoration: const InputDecoration(labelText: 'Estatura al nacer (cm)'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Introduce la estatura';
                    }
                    if (double.tryParse(value.trim()) == null) {
                      return 'Introduce un numero valido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  key: const Key('newBaby_weight'),
                  controller: _weightController,
                  decoration: const InputDecoration(labelText: 'Peso al nacer (kg)'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Introduce el peso';
                    }
                    if (double.tryParse(value.trim()) == null) {
                      return 'Introduce un numero valido';
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
                    _photoPath == null ? 'Adjuntar foto (opcional)' : 'Foto seleccionada',
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
                      : const Text('Guardar bebe'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
