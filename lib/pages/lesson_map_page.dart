import 'package:flutter/material.dart';

import '../models/level_model.dart';
import '../widgets/level_card.dart';
import 'lessons/math/grade_1_2/level1_counting_page.dart';
import 'lessons/math/grade_1_2/level2_addition_page.dart';
import 'lessons/math/grade_1_2/level3_multiplication_intro_page.dart';

class LessonMapPage extends StatelessWidget {
  final String subject;
  final String grade;
  final Color color;

  const LessonMapPage({
    super.key,
    required this.subject,
    required this.grade,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final normalizedSubject = subject.toLowerCase();
    final isMathSubject = normalizedSubject.contains("matem");
    final isFirstSecondGrade = grade.contains("1") && grade.contains("2");
    final hasAvailableLevels = isMathSubject && isFirstSecondGrade;

    final activeLevels = [
      const LevelModel(
        title: "Nivel 1",
        subtitle: "Principiante",
        description: "Contar numeros explotando globos en orden",
      ),
      const LevelModel(
        title: "Nivel 2",
        subtitle: "Intermedio",
        description: "Suma y resta con problemas de manzanas",
      ),
      const LevelModel(
        title: "Nivel 3",
        subtitle: "Avanzado",
        description: "Introduccion a la multiplicacion visual",
      ),
    ];

    final pendingLevels = [
      const LevelModel(
        title: "Nivel 1",
        subtitle: "Pendiente",
        description: "Falta definir la idea para este grado",
        locked: true,
      ),
      const LevelModel(
        title: "Nivel 2",
        subtitle: "Pendiente",
        description: "Falta definir la idea para este grado",
        locked: true,
      ),
      const LevelModel(
        title: "Nivel 3",
        subtitle: "Pendiente",
        description: "Falta definir la idea para este grado",
        locked: true,
      ),
    ];

    final levels = hasAvailableLevels ? activeLevels : pendingLevels;

    Widget buildMathGradeOneTwoLevel(int index) {
      switch (index) {
        case 0:
          return Level1CountingPage(grade: grade, color: color);
        case 1:
          return Level2AdditionPage(grade: grade, color: color);
        default:
          return Level3MultiplicationIntroPage(grade: grade, color: color);
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: Text("$subject - $grade"),
        backgroundColor: color,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView.builder(
          itemCount: levels.length,
          itemBuilder: (context, index) {
            final level = levels[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: LevelCard(
                title: level.title,
                subtitle: level.subtitle,
                description: level.description,
                icon: level.locked
                    ? Icons.lock_outline
                    : index == 0
                        ? Icons.filter_1
                        : index == 1
                            ? Icons.add_circle_outline
                            : Icons.close,
                color: color,
                locked: level.locked,
                onTap: () {
                  if (!hasAvailableLevels) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Estos niveles todavia estan pendientes.",
                        ),
                      ),
                    );
                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => buildMathGradeOneTwoLevel(index),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
