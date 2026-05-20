import 'package:flutter/material.dart';

import '../../simple_choice_lesson_page.dart';

class Level2DivisionPage extends StatelessWidget {
  final String grade;
  final Color color;

  const Level2DivisionPage({
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
      title: "División",
      subtitle: "Repartir en partes iguales",
      prompt: "Si repartes 8 rebanadas entre 4 niños, ¿cuánto recibe cada uno?",
      explanation:
          "Dividir es repartir en partes iguales. Para resolver, reparte las 8 rebanadas una por una entre 4 niños.",
      options: const ["1", "2", "4"],
      correctAnswer: "2",
      color: color,
      visualType: "groups",
      visualItems: const ["8", "4"],
    );
  }
}
