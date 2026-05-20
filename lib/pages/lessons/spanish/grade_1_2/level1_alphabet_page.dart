import 'package:flutter/material.dart';

import '../../simple_choice_lesson_page.dart';

class Level1AlphabetPage extends StatelessWidget {
  final String grade;
  final Color color;

  const Level1AlphabetPage({
    super.key,
    required this.grade,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleChoiceLessonPage(
      subjectKey: "spanish",
      grade: grade,
      level: 1,
      title: "Abecedario",
      subtitle: "Reconocer letras",
      prompt: "¿Cuál letra aparece primero en el abecedario?",
      explanation:
          "El abecedario tiene un orden. Para reconocer letras, observa su forma y recuerda cuál aparece primero.",
      options: const ["A", "M", "Z"],
      correctAnswer: "A",
      color: color,
      visualType: "letters",
      visualItems: const ["A", "B", "C", "D"],
    );
  }
}
