import 'package:flutter/material.dart';

import '../../simple_choice_lesson_page.dart';

class Level1MainIdeaPage extends StatelessWidget {
  final String grade;
  final Color color;

  const Level1MainIdeaPage({
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
      title: "Idea principal",
      subtitle: "Comprender textos",
      prompt: "Un texto habla de cuidar el agua. ¿Cuál es la idea principal?",
      explanation:
          "La idea principal dice de qué trata todo el texto. No es un detalle pequeño, es el tema central.",
      options: const ["Cuidar el agua", "Jugar fútbol", "Comprar dulces"],
      correctAnswer: "Cuidar el agua",
      color: color,
      visualType: "sentence",
      visualItems: const ["Cerrar la llave.", "No desperdiciar agua."],
    );
  }
}
