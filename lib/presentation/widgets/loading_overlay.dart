import 'package:flutter/material.dart';

/// A fullscreen loading overlay with a circular spinner and fade animation.
///
/// Displays a semi-transparent background with a centered circular progress
/// indicator. The overlay fades in and out smoothly over 250ms.
class LoadingOverlay extends StatelessWidget {
  /// Creates a loading overlay.
  const LoadingOverlay({
    super.key,
    this.message,
  });

  /// Optional message to display below the spinner.
  final String? message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentColor = theme.colorScheme.primary;

    return Container(
      color: Colors.black54,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(accentColor),
            ),
            if (message != null) ...[
              const SizedBox(height: 16),
              Text(
                message!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Shows the loading overlay with a fade-in animation.
  ///
  /// Returns a function that can be called to dismiss the overlay.
  static VoidCallback show(BuildContext context, {String? message}) {
    final overlayState = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => _AnimatedLoadingOverlay(
        message: message,
        onDismiss: () => overlayEntry.remove(),
      ),
    );

    overlayState.insert(overlayEntry);

    return () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    };
  }
}

class _AnimatedLoadingOverlay extends StatefulWidget {
  const _AnimatedLoadingOverlay({
    this.message,
    required this.onDismiss,
  });

  final String? message;
  final VoidCallback onDismiss;

  @override
  State<_AnimatedLoadingOverlay> createState() =>
      _AnimatedLoadingOverlayState();
}

class _AnimatedLoadingOverlayState extends State<_AnimatedLoadingOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _dismiss() async {
    await _controller.reverse();
    widget.onDismiss();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: LoadingOverlay(message: widget.message),
    );
  }
}
