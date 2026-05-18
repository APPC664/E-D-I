import 'package:flutter/material.dart';

import '../../../../services/progress_service.dart';
import '../../../../widgets/lesson_button.dart';

class Level3MultiplicationIntroPage extends StatefulWidget {
  final String grade;
  final Color color;

  const Level3MultiplicationIntroPage({
    super.key,
    required this.grade,
    required this.color,
  });

  @override
  State<Level3MultiplicationIntroPage> createState() =>
      _Level3MultiplicationIntroPageState();
}

class _Level3MultiplicationIntroPageState
    extends State<Level3MultiplicationIntroPage> {
  String message = "";
  bool completed = false;

  Future<void> checkAnswer(int answer) async {
    if (answer == 6) {
      await ProgressService.completeLevel(
        subject: "math",
        grade: widget.grade,
        level: 3,
      );

      if (!mounted) return;
      setState(() {
        completed = true;
        message = "Respuesta correcta.";
      });
    } else {
      setState(() {
        message = "Casi. Cuenta los objetos por grupos.";
      });
    }
  }

  Widget buildGroup(int count) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          count,
          (_) => Container(
            width: 24,
            height: 44,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
              color: Colors.orange.shade400,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMessage() {
    if (message.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: completed ? Colors.green.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: completed ? Colors.green : Colors.black12,
        ),
      ),
      child: Text(
        message,
        style: TextStyle(
          color: completed ? Colors.green.shade900 : Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: const Text("Nivel 3"),
        backgroundColor: widget.color,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: widget.color,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Avanzado",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Aprende multiplicacion con grupos",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      "Hay 2 grupos con 3 objetos cada uno.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text("Cuantos objetos hay en total?"),
                    const SizedBox(height: 22),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        buildGroup(3),
                        buildGroup(3),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      "2 x 3 = ?",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 12,
                      children: [5, 6, 8]
                          .map(
                            (answer) => LessonButton(
                              text: "$answer",
                              onPressed: () => checkAnswer(answer),
                              color: widget.color,
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
              buildMessage(),
            ],
          ),
        ),
      ),
    );
  }
}
