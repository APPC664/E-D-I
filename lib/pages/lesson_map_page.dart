import 'package:flutter/material.dart';

import '../models/level_model.dart';
import '../services/progress_service.dart';
import '../widgets/level_card.dart';
import '../widgets/progress_bar.dart';
import 'lessons/math/grade_1_2/level1_counting_page.dart';
import 'lessons/math/grade_1_2/level2_addition_page.dart';
import 'lessons/math/grade_1_2/level3_multiplication_intro_page.dart';
import 'lessons/math/grade_3_4/level1_multiplication_page.dart';
import 'lessons/math/grade_3_4/level2_division_page.dart';
import 'lessons/math/grade_3_4/level3_math_problems_page.dart';
import 'lessons/math/grade_5_6/level1_fractions_page.dart';
import 'lessons/math/grade_5_6/level2_decimals_page.dart';
import 'lessons/math/grade_5_6/level3_multi_step_problems_page.dart';
import 'lessons/spanish/grade_1_2/level1_alphabet_page.dart';
import 'lessons/spanish/grade_1_2/level2_initial_sounds_page.dart';
import 'lessons/spanish/grade_1_2/level3_letter_order_page.dart';
import 'lessons/spanish/grade_3_4/level1_syllables_page.dart';
import 'lessons/spanish/grade_3_4/level2_sentence_order_page.dart';
import 'lessons/spanish/grade_3_4/level3_reading_comprehension_page.dart';
import 'lessons/spanish/grade_5_6/level1_main_idea_page.dart';
import 'lessons/spanish/grade_5_6/level2_accents_page.dart';
import 'lessons/spanish/grade_5_6/level3_grammar_page.dart';

class LessonMapPage extends StatefulWidget {
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
  State<LessonMapPage> createState() => _LessonMapPageState();
}

class _LessonMapPageState extends State<LessonMapPage> {
  @override
  void initState() {
    super.initState();
    syncProgress();
  }

  Future<void> syncProgress() async {
    await ProgressService.loadRemoteProgress(
      subject: subjectKey,
      grade: widget.grade,
    );
    await ProgressService.syncPendingProgress(
      subject: subjectKey,
      grade: widget.grade,
      totalLevels: levels.length,
    );

    if (mounted) {
      setState(() {});
    }
  }

  String get subjectKey {
    final normalizedSubject = widget.subject.toLowerCase();
    return normalizedSubject.contains("matem") ? "math" : "spanish";
  }

  String get gradeKey {
    if (widget.grade.contains("1") && widget.grade.contains("2")) {
      return "grade_1_2";
    }
    if (widget.grade.contains("3") && widget.grade.contains("4")) {
      return "grade_3_4";
    }
    return "grade_5_6";
  }

  List<LevelModel> get levels {
    if (subjectKey == "math") {
      return mathLevels();
    }

    return spanishLevels();
  }

  List<LevelModel> mathLevels() {
    switch (gradeKey) {
      case "grade_1_2":
        return const [
          LevelModel(
            title: "Nivel 1",
            subtitle: "Principiante",
            description: "Contar numeros explotando globos en orden",
          ),
          LevelModel(
            title: "Nivel 2",
            subtitle: "Intermedio",
            description: "Suma y resta con problemas de manzanas",
          ),
          LevelModel(
            title: "Nivel 3",
            subtitle: "Avanzado",
            description: "Introduccion a la multiplicacion visual",
          ),
        ];
      case "grade_3_4":
        return const [
          LevelModel(
            title: "Nivel 1",
            subtitle: "Principiante",
            description: "Multiplicacion con grupos y cajas",
          ),
          LevelModel(
            title: "Nivel 2",
            subtitle: "Intermedio",
            description: "Repartir objetos en partes iguales",
          ),
          LevelModel(
            title: "Nivel 3",
            subtitle: "Avanzado",
            description: "Problemas matematicos con operaciones",
          ),
        ];
      default:
        return const [
          LevelModel(
            title: "Nivel 1",
            subtitle: "Principiante",
            description: "Fracciones con dibujos y partes",
          ),
          LevelModel(
            title: "Nivel 2",
            subtitle: "Intermedio",
            description: "Decimales y comparacion de cantidades",
          ),
          LevelModel(
            title: "Nivel 3",
            subtitle: "Avanzado",
            description: "Problemas de varios pasos",
          ),
        ];
    }
  }

  List<LevelModel> spanishLevels() {
    switch (gradeKey) {
      case "grade_1_2":
        return const [
          LevelModel(
            title: "Nivel 1",
            subtitle: "Principiante",
            description: "Reconocimiento del abecedario",
          ),
          LevelModel(
            title: "Nivel 2",
            subtitle: "Intermedio",
            description: "Relacionar letras con palabras",
          ),
          LevelModel(
            title: "Nivel 3",
            subtitle: "Avanzado",
            description: "Motricidad y orden de letras",
          ),
        ];
      case "grade_3_4":
        return const [
          LevelModel(
            title: "Nivel 1",
            subtitle: "Principiante",
            description: "Silabas y formacion de palabras",
          ),
          LevelModel(
            title: "Nivel 2",
            subtitle: "Intermedio",
            description: "Ordenar oraciones sencillas",
          ),
          LevelModel(
            title: "Nivel 3",
            subtitle: "Avanzado",
            description: "Comprension lectora breve",
          ),
        ];
      default:
        return const [
          LevelModel(
            title: "Nivel 1",
            subtitle: "Principiante",
            description: "Idea principal de un texto",
          ),
          LevelModel(
            title: "Nivel 2",
            subtitle: "Intermedio",
            description: "Acentos y palabras correctas",
          ),
          LevelModel(
            title: "Nivel 3",
            subtitle: "Avanzado",
            description: "Partes de la oracion",
          ),
        ];
    }
  }

  IconData levelIcon(int index, bool locked) {
    if (locked) return Icons.lock_outline;

    if (subjectKey == "spanish") {
      return index == 0
          ? Icons.abc
          : index == 1
              ? Icons.menu_book
              : Icons.edit;
    }

    return index == 0
        ? Icons.filter_1
        : index == 1
            ? Icons.add_circle_outline
            : Icons.close;
  }

  bool isCompleted(int index) {
    return ProgressService.isLevelCompleted(
      subject: subjectKey,
      grade: widget.grade,
      level: index + 1,
    );
  }

  bool isLocked(int index) {
    if (index == 0) return false;
    return !isCompleted(index - 1);
  }

  Widget buildMathGradeOneTwoLevel(int index) {
    switch (index) {
      case 0:
        return Level1CountingPage(grade: widget.grade, color: widget.color);
      case 1:
        return Level2AdditionPage(grade: widget.grade, color: widget.color);
      default:
        return Level3MultiplicationIntroPage(
          grade: widget.grade,
          color: widget.color,
        );
    }
  }

  Widget buildMathGradeThreeFourLevel(int index) {
    switch (index) {
      case 0:
        return Level1MultiplicationPage(
          grade: widget.grade,
          color: widget.color,
        );
      case 1:
        return Level2DivisionPage(grade: widget.grade, color: widget.color);
      default:
        return Level3MathProblemsPage(
          grade: widget.grade,
          color: widget.color,
        );
    }
  }

  Widget buildMathGradeFiveSixLevel(int index) {
    switch (index) {
      case 0:
        return Level1FractionsPage(grade: widget.grade, color: widget.color);
      case 1:
        return Level2DecimalsPage(grade: widget.grade, color: widget.color);
      default:
        return Level3MultiStepProblemsPage(
          grade: widget.grade,
          color: widget.color,
        );
    }
  }

  Widget buildSpanishGradeOneTwoLevel(int index) {
    switch (index) {
      case 0:
        return Level1AlphabetPage(grade: widget.grade, color: widget.color);
      case 1:
        return Level2InitialSoundsPage(
          grade: widget.grade,
          color: widget.color,
        );
      default:
        return Level3LetterOrderPage(grade: widget.grade, color: widget.color);
    }
  }

  Widget buildSpanishGradeThreeFourLevel(int index) {
    switch (index) {
      case 0:
        return Level1SyllablesPage(grade: widget.grade, color: widget.color);
      case 1:
        return Level2SentenceOrderPage(
          grade: widget.grade,
          color: widget.color,
        );
      default:
        return Level3ReadingComprehensionPage(
          grade: widget.grade,
          color: widget.color,
        );
    }
  }

  Widget buildSpanishGradeFiveSixLevel(int index) {
    switch (index) {
      case 0:
        return Level1MainIdeaPage(grade: widget.grade, color: widget.color);
      case 1:
        return Level2AccentsPage(grade: widget.grade, color: widget.color);
      default:
        return Level3GrammarPage(grade: widget.grade, color: widget.color);
    }
  }

  Widget buildLevelPage(int index) {
    if (subjectKey == "math" && gradeKey == "grade_1_2") {
      return buildMathGradeOneTwoLevel(index);
    }

    if (subjectKey == "math" && gradeKey == "grade_3_4") {
      return buildMathGradeThreeFourLevel(index);
    }

    if (subjectKey == "math" && gradeKey == "grade_5_6") {
      return buildMathGradeFiveSixLevel(index);
    }

    if (subjectKey == "spanish" && gradeKey == "grade_1_2") {
      return buildSpanishGradeOneTwoLevel(index);
    }

    if (subjectKey == "spanish" && gradeKey == "grade_3_4") {
      return buildSpanishGradeThreeFourLevel(index);
    }

    if (subjectKey == "spanish" && gradeKey == "grade_5_6") {
      return buildSpanishGradeFiveSixLevel(index);
    }

    return buildSpanishGradeOneTwoLevel(index);
  }

  Future<void> openLevel(int index) async {
    if (isLocked(index)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Completa el nivel anterior para avanzar."),
        ),
      );
      return;
    }

    final page = buildLevelPage(index);

    final completed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => page),
    );

    if (mounted) {
      setState(() {});
    }

    if (completed == true && index + 1 < levels.length && mounted) {
      await openLevel(index + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = ProgressService.progressValue(
      subject: subjectKey,
      grade: widget.grade,
      totalLevels: levels.length,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: Text(widget.subject.toUpperCase()),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.subject.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Selecciona tu nivel",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 18),
            ProgressBar(value: progress, color: widget.color),
            const SizedBox(height: 8),
            Text(
              "${(progress * 100).round()}% completado",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: levels.length,
                itemBuilder: (context, index) {
                  final level = levels[index];
                  final locked = isLocked(index);
                  final completed = isCompleted(index);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: LevelCard(
                      title: level.title,
                      subtitle: level.subtitle,
                      description: level.description,
                      icon: levelIcon(index, locked),
                      color: widget.color,
                      locked: locked,
                      completed: completed,
                      onTap: () => openLevel(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
