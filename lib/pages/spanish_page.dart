import 'package:flutter/material.dart';

class SpanishPage extends StatelessWidget {
  const SpanishPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Español"),
        backgroundColor: Colors.blue,
      ),
      body: const Center(
        child: Text("Contenido de Español"),
      ),
    );
  }
}