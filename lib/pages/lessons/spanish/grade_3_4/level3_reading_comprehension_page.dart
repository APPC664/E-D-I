import 'package:flutter/material.dart';

import '../../simple_choice_lesson_page.dart';

class Level3ReadingComprehensionPage extends StatelessWidget {
  final String grade;
  final Color color;

  const Level3ReadingComprehensionPage({
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
      title: "Comprensión",
      subtitle: "Lectura breve",
      prompt: "Lía lee un cuento antes de dormir. ¿Qué hizo Lía?",
      explanation:
          "Para comprender un texto, busca la acción principal. Pregúntate: ¿qué hizo el personaje?",
      options: const ["Leyó", "Corrió", "Cantó"],
      correctAnswer: "Leyó",
      color: color,
      visualType: "sentence",
      visualItems: const ["Lía lee un cuento.", "Es de noche."],
    );
  }
}
