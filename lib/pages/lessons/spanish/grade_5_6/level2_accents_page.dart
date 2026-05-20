import 'package:flutter/material.dart';

import '../../simple_choice_lesson_page.dart';

class Level2AccentsPage extends StatelessWidget {
  final String grade;
  final Color color;

  const Level2AccentsPage({
    super.key,
    required this.grade,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleChoiceLessonPage(
      subjectKey: "spanish",
      grade: grade,
      level: 2,
      title: "Acentos",
      subtitle: "Palabras correctas",
      prompt: "¿Cuál palabra está escrita correctamente?",
      explanation:
          "Algunas palabras llevan acento escrito. Árbol se escribe con acento en la a.",
      options: const ["arbol", "árbol", "arból"],
      correctAnswer: "árbol",
      color: color,
      visualType: "letters",
      visualItems: const ["arbol", "árbol", "arból"],
    );
  }
}
