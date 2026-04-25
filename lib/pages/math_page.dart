import 'package:flutter/material.dart';

class MathPage extends StatelessWidget {
  const MathPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Matemáticas"),
        backgroundColor: Colors.red,
      ),
      body: const Center(
        child: Text("Contenido de Matemáticas"),
      ),
    );
  }
}