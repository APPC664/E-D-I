import 'package:flutter/material.dart';

import '../../simple_choice_lesson_page.dart';

class Level1SyllablesPage extends StatelessWidget {
  final String grade;
  final Color color;

  const Level1SyllablesPage({
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
      title: "Sílabas",
      subtitle: "Formar palabras",
      prompt: "¿Qué palabra se forma con ca + sa?",
      explanation:
          "Las sílabas se pueden unir para formar palabras. Si juntas ca y sa, lees casa.",
      options: const ["casa", "saco", "mesa"],
      correctAnswer: "casa",
      color: color,
      visualType: "letters",
      visualItems: const ["ca", "sa"],
    );
  }
}
