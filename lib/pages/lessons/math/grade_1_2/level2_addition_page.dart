import 'package:flutter/material.dart';

import '../../../../services/progress_service.dart';
import '../../../../widgets/lesson_button.dart';

class Level2AdditionPage extends StatefulWidget {
  final String grade;
  final Color color;

  const Level2AdditionPage({
    super.key,
    required this.grade,
    required this.color,
  });

  @override
  State<Level2AdditionPage> createState() => _Level2AdditionPageState();
}

class _Level2AdditionPageState extends State<Level2AdditionPage> {
  String message = "";
  bool completed = false;

  Future<void> checkAnswer(int answer) async {
    if (answer == 3) {
      await ProgressService.completeLevel(
        subject: "math",
        grade: widget.grade,
        level: 2,
      );

      if (!mounted) return;
      setState(() {
        completed = true;
        message = "Respuesta correcta.";
      });
    } else {
      setState(() {
        message = "Casi. Cuenta las manzanas otra vez.";
      });
    }
  }

  Widget buildAppleRow(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (_) => Container(
          width: 42,
          height: 42,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: Colors.red.shade400,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.eco,
            color: Colors.white,
            size: 22,
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
        title: const Text("Nivel 2"),
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
                      "Intermedio",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Suma y resta con manzanas",
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
                      "Christian tiene 2 manzanas y Angel le da 1 mas.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Cuantas manzanas tiene Christian?",
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 22),
                    buildAppleRow(2),
                    const SizedBox(height: 12),
                    const Icon(Icons.add, size: 34),
                    const SizedBox(height: 12),
                    buildAppleRow(1),
                    const SizedBox(height: 22),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 12,
                      children: [2, 3, 4]
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
