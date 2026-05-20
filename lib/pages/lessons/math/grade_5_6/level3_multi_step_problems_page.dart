import 'package:flutter/material.dart';

import '../../simple_choice_lesson_page.dart';

class Level3MultiStepProblemsPage extends StatelessWidget {
  final String grade;
  final Color color;

  const Level3MultiStepProblemsPage({
    super.key,
    required this.grade,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleChoiceLessonPage(
      subjectKey: "math",
      grade: grade,
      level: 3,
      title: "Problemas",
      subtitle: "Varios pasos",
      prompt: "Ana compra 2 paquetes de 6 lápices y regala 3. ¿Cuántos quedan?",
      explanation:
          "Cuando un problema tiene varios pasos, resuelve uno por uno: primero multiplica los paquetes y luego resta lo que se regaló.",
      options: const ["9", "12", "15"],
      correctAnswer: "9",
      color: color,
      visualType: "sentence",
      visualItems: const ["2 paquetes de 6", "12 lápices", "Regala 3"],
    );
  }
}
