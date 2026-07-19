import 'package:flutter/material.dart';

class ExpedientesScreen extends StatelessWidget {
  const ExpedientesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expedientes'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      body: const Center(
        child: Text(
          'Todavía no hay expedientes',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}