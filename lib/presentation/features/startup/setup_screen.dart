import 'package:flutter/material.dart';

/// Empty state displayed when no babies exist yet in storage.
class SetupScreen extends StatefulWidget {
  /// Creates the setup screen with the provided action callbacks.
  const SetupScreen({
    super.key,
    required this.onConfigure,
    required this.onCreateBaby,
  });

  /// Callback executed when the user taps the configure action.
  final VoidCallback onConfigure;

  /// Callback executed when the user wants to register a new baby.
  final VoidCallback onCreateBaby;

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  bool _snackQueued = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_snackQueued) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Registra un bebe para empezar'),
            behavior: SnackBarBehavior.floating,
          ),
        );
    });

    _snackQueued = true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 48),
              Text(
                'PequeLog',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Prepara la app para tu primer registro.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onBackground.withOpacity(0.72),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: widget.onConfigure,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                ),
                child: const Text('Configurar App'),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: widget.onCreateBaby,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                ),
                child: const Text('Nuevo bebe'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
