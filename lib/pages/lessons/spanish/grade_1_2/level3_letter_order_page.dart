import 'package:flutter/material.dart';

import '../../simple_choice_lesson_page.dart';

class Level3LetterOrderPage extends StatelessWidget {
  final String grade;
  final Color color;

  const Level3LetterOrderPage({
    super.key,
    required this.grade,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleChoiceLessonPage(
      subjectKey: "spanish",
      grade: grade,
      level: 3,
      title: "Motricidad",
      subtitle: "Orden de letras",
      prompt: "¿Qué letra falta en la secuencia A, B, __?",
      explanation:
          "Ordenar letras ayuda a leer y escribir. Después de A y B sigue C.",
      options: const ["C", "F", "Z"],
      correctAnswer: "C",
      color: color,
      visualType: "letters",
      visualItems: const ["A", "B", "_"],
    );
  }
}
