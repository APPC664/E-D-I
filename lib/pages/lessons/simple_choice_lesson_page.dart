import 'package:flutter/material.dart';

import '../../services/progress_service.dart';
import '../../widgets/lesson_button.dart';

class SimpleChoiceLessonPage extends StatefulWidget {
  final String subjectKey;
  final String grade;
  final int level;
  final String title;
  final String subtitle;
  final String prompt;
  final String explanation;
  final List<String> options;
  final String correctAnswer;
  final Color color;
  final String visualType;
  final List<String> visualItems;

  const SimpleChoiceLessonPage({
    super.key,
    required this.subjectKey,
    required this.grade,
    required this.level,
    required this.title,
    required this.subtitle,
    required this.prompt,
    required this.explanation,
    required this.options,
    required this.correctAnswer,
    required this.color,
    required this.visualType,
    this.visualItems = const [],
  });

  @override
  State<SimpleChoiceLessonPage> createState() => _SimpleChoiceLessonPageState();
}

class _SimpleChoiceLessonPageState extends State<SimpleChoiceLessonPage> {
  String message = "";
  bool completed = false;
  bool showingIntro = true;

  Future<void> checkAnswer(String answer) async {
    if (answer == widget.correctAnswer) {
      await ProgressService.completeLevel(
        subject: widget.subjectKey,
        grade: widget.grade,
        level: widget.level,
      );

      if (!mounted) return;
      setState(() {
        completed = true;
        message = "Respuesta correcta. Nivel completado.";
      });
    } else {
      setState(() {
        message = "Intenta de nuevo. Observa la pista visual.";
      });
    }
  }

  Widget buildVisual() {
    switch (widget.visualType) {
      case "letters":
        return Wrap(
          alignment: WrapAlignment.center,
          spacing: 12,
          runSpacing: 12,
          children: widget.visualItems.map((letter) {
            return Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: widget.color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: widget.color),
              ),
              child: Center(
                child: Text(
                  letter,
                  style: TextStyle(
                    color: widget.color,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }).toList(),
        );
      case "groups":
        return Wrap(
          alignment: WrapAlignment.center,
          spacing: 14,
          runSpacing: 14,
          children: widget.visualItems.map((item) {
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }).toList(),
        );
      case "sentence":
        return Column(
          children: widget.visualItems.map((item) {
            return Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: widget.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                item,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),
            );
          }).toList(),
        );
      default:
        return Wrap(
          alignment: WrapAlignment.center,
          spacing: 10,
          runSpacing: 10,
          children: widget.visualItems.map((item) {
            return Chip(
              label: Text(
                item,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          }).toList(),
        );
    }
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
    required IconData icon,
    required String label,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
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
          Text(
            widget.explanation,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 17),
          ),
          const SizedBox(height: 20),
          buildArrowButton(
            onPressed: () {
              setState(() {
                showingIntro = false;
              });
            },
            icon: Icons.arrow_forward,
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
            widget.prompt,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          buildVisual(),
          const SizedBox(height: 22),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 12,
            children: widget.options.map((answer) {
              return LessonButton(
                text: answer,
                onPressed: () => checkAnswer(answer),
                color: widget.color,
              );
            }).toList(),
          ),
          if (completed) ...[
            const SizedBox(height: 20),
            buildArrowButton(
              onPressed: () => Navigator.pop(context, true),
              icon: Icons.arrow_forward,
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
        title: Text("Nivel ${widget.level}"),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.subtitle,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
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
