import 'package:flutter/material.dart';

import '../../simple_choice_lesson_page.dart';

class Level2InitialSoundsPage extends StatelessWidget {
  final String grade;
  final Color color;

  const Level2InitialSoundsPage({
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
      title: "Letras y palabras",
      subtitle: "Relacionar sonido inicial",
      prompt: "¿Con qué letra empieza la palabra casa?",
      explanation:
          "Muchas palabras se reconocen por su sonido inicial. Escucha la primera parte de casa: ca.",
      options: const ["C", "S", "M"],
      correctAnswer: "C",
      color: color,
      visualType: "letters",
      visualItems: const ["casa", "cama", "conejo"],
    );
  }
}
