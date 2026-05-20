import 'package:flutter/material.dart';

import '../../simple_choice_lesson_page.dart';

class Level1FractionsPage extends StatelessWidget {
  final String grade;
  final Color color;

  const Level1FractionsPage({
    super.key,
    required this.grade,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleChoiceLessonPage(
      subjectKey: "math",
      grade: grade,
      level: 1,
      title: "Fracciones",
      subtitle: "Partes de un entero",
      prompt: "Si una pizza tiene 8 partes y comes 2, ¿qué fracción comiste?",
      explanation:
          "Una fracción muestra partes de un entero. El número de arriba dice cuántas partes tomas y el de abajo cuántas partes hay en total.",
      options: const ["2/8", "8/2", "6/8"],
      correctAnswer: "2/8",
      color: color,
      visualType: "groups",
      visualItems: const [
        "1/8",
        "1/8",
        "1/8",
        "1/8",
        "1/8",
        "1/8",
        "1/8",
        "1/8",
      ],
    );
  }
}
