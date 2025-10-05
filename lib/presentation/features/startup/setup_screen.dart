import 'package:flutter/material.dart';
import 'package:pequelog/l10n/app_localizations.dart';

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

      final l10n = AppLocalizations.of(context)!;

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(l10n.setupSnackMessage),
            behavior: SnackBarBehavior.floating,
          ),
        );
    });

    _snackQueued = true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

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
                l10n.appTitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.setupSubtitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onBackground.withOpacity(0.72),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                key: const Key('setup_configure'),
                onPressed: widget.onConfigure,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                ),
                child: Text(l10n.setupConfigure),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                key: const Key('setup_newBaby'),
                onPressed: widget.onCreateBaby,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                ),
                child: Text(l10n.setupNewBaby),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
