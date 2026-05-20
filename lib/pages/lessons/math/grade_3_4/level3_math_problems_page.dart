import 'package:flutter/material.dart';

import '../../simple_choice_lesson_page.dart';

class Level3MathProblemsPage extends StatelessWidget {
  final String grade;
  final Color color;

  const Level3MathProblemsPage({
    super.key,
    required this.grade,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleChoiceLessonPage(
      subjectKey: "math",
      grade: grade,
      level: 3,
      title: "Problemas",
      subtitle: "Leer y resolver",
      prompt: "Juan tiene 8 monedas y compra algo de 3. ¿Cuántas monedas quedan?",
      explanation:
          "En los problemas primero lee qué tienes y luego qué cambia. Si Juan gasta monedas, debes restar.",
      options: const ["3", "5", "8"],
      correctAnswer: "5",
      color: color,
      visualType: "sentence",
      visualItems: const ["Juan tiene 8 monedas.", "Gasta 3 monedas."],
    );
  }
}
