import 'package:flutter/material.dart';

/// Placeholder form that will handle the baby registration flow.
class NewBabyScreen extends StatelessWidget {
  /// Creates the new baby screen stub.
  const NewBabyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo bebe'),
      ),
      body: const Center(
        child: Text('Formulario de alta en construccion.'),
      ),
    );
  }
}
