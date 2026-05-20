import 'package:flutter/material.dart';

import '../../simple_choice_lesson_page.dart';

class Level2DecimalsPage extends StatelessWidget {
  final String grade;
  final Color color;

  const Level2DecimalsPage({
    super.key,
    required this.grade,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleChoiceLessonPage(
      subjectKey: "math",
      grade: grade,
      level: 2,
      title: "Decimales",
      subtitle: "Comparar cantidades",
      prompt: "¿Cuál número es mayor?",
      explanation:
          "Los decimales también se comparan. Mira primero los décimos: 0.7 tiene más décimos que 0.5 y 0.3.",
      options: const ["0.7", "0.5", "0.3"],
      correctAnswer: "0.7",
      color: color,
      visualType: "groups",
      visualItems: const ["0.3", "0.5", "0.7"],
    );
  }
}
