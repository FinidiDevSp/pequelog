import 'package:flutter/material.dart';

/// Placeholder for the configuration hub.
class ConfigurationScreen extends StatelessWidget {
  /// Displays the configuration entry point.
  const ConfigurationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuracion'),
      ),
      body: const Center(
        child: Text('Aqui podras personalizar la app muy pronto.'),
      ),
    );
  }
}
