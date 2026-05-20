import 'package:flutter/material.dart';

import '../../simple_choice_lesson_page.dart';

class Level1MultiplicationPage extends StatelessWidget {
  final String grade;
  final Color color;

  const Level1MultiplicationPage({
    super.key,
    required this.grade,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleChoiceLessonPage(
      subjectKey: "math",
      grade: grade,
      level: 1,
      title: "Multiplicación",
      subtitle: "Cajas con tomates",
      prompt: "Hay 3 cajas con 3 tomates cada una. ¿Cuántos tomates hay?",
      explanation:
          "Multiplicar ayuda a contar grupos iguales. Si hay 3 cajas y cada caja tiene 3 tomates, puedes sumar 3 + 3 + 3 o usar 3 x 3.",
      options: const ["6", "9", "12"],
      correctAnswer: "9",
      color: color,
      visualType: "groups",
      visualItems: const ["3", "3", "3"],
    );
  }
}
