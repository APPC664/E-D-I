import 'package:flutter/material.dart';

import '../../simple_choice_lesson_page.dart';

class Level2SentenceOrderPage extends StatelessWidget {
  final String grade;
  final Color color;

  const Level2SentenceOrderPage({
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
      title: "Oraciones",
      subtitle: "Ordenar ideas",
      prompt: "¿Cuál oración está en orden?",
      explanation:
          "Una oración clara suele decir quién hace algo y qué hace. Busca la opción que se pueda leer naturalmente.",
      options: const ["El perro corre", "Corre perro el", "Perro el corre"],
      correctAnswer: "El perro corre",
      color: color,
      visualType: "sentence",
      visualItems: const ["El", "perro", "corre"],
    );
  }
}
