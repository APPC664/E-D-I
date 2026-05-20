import 'package:flutter/material.dart';

import '../../simple_choice_lesson_page.dart';

class Level3GrammarPage extends StatelessWidget {
  final String grade;
  final Color color;

  const Level3GrammarPage({
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
      title: "Gramática",
      subtitle: "Partes de la oración",
      prompt: "En 'María corre', ¿cuál es el verbo?",
      explanation:
          "El verbo es la acción de la oración. En este caso, pregunta qué hace María.",
      options: const ["María", "corre", "la"],
      correctAnswer: "corre",
      color: color,
      visualType: "sentence",
      visualItems: const ["María", "corre"],
    );
  }
}
