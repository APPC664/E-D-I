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
  bool showingIntro = true;
  late final ({String name, int start, int added, List<int> options}) problem;

  @override
  void initState() {
    super.initState();
    final variants = [
      (name: "Christian", start: 2, added: 1, options: [2, 3, 4]),
      (name: "Sofia", start: 3, added: 2, options: [4, 5, 6]),
      (name: "Luis", start: 1, added: 4, options: [3, 5, 6]),
    ];
    problem = variants[DateTime.now().millisecondsSinceEpoch % variants.length];
  }

  Future<void> checkAnswer(int answer) async {
    if (answer == problem.start + problem.added) {
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

  Widget buildArrowButton({
    required VoidCallback onPressed,
    required String label,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.arrow_forward),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget buildIntroCard() {
    return Container(
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
          Icon(Icons.lightbulb, color: widget.color, size: 42),
          const SizedBox(height: 12),
          const Text(
            "Sumar significa juntar cantidades. Si tienes algunas manzanas y agregas mas, cuenta todas las manzanas juntas.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 17),
          ),
          const SizedBox(height: 20),
          buildArrowButton(
            onPressed: () {
              setState(() {
                showingIntro = false;
              });
            },
            label: "Avanzar al ejercicio",
          ),
        ],
      ),
    );
  }

  Widget buildExerciseCard() {
    return Container(
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
          Text(
            "${problem.name} tiene ${problem.start} manzanas y le dan ${problem.added} mas.",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Cuantas manzanas tiene ${problem.name}?",
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 22),
          buildAppleRow(problem.start),
          const SizedBox(height: 12),
          const Icon(Icons.add, size: 34),
          const SizedBox(height: 12),
          buildAppleRow(problem.added),
          const SizedBox(height: 22),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            children: problem.options
                .map(
                  (answer) => LessonButton(
                    text: "$answer",
                    onPressed: () => checkAnswer(answer),
                    color: widget.color,
                  ),
                )
                .toList(),
          ),
          if (completed) ...[
            const SizedBox(height: 20),
            buildArrowButton(
              onPressed: () => Navigator.pop(context, true),
              label: "Avanzar",
            ),
          ],
        ],
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
              showingIntro ? buildIntroCard() : buildExerciseCard(),
              buildMessage(),
            ],
          ),
        ),
      ),
    );
  }
}
