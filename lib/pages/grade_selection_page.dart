import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'lesson_map_page.dart';

class GradeSelectionPage extends StatefulWidget {
  final String subject;
  final Color color;

  const GradeSelectionPage({
    super.key,
    required this.subject,
    required this.color,
  });

  @override
  State<GradeSelectionPage> createState() => _GradeSelectionPageState();
}

class _GradeSelectionPageState extends State<GradeSelectionPage> {
  int selectedIndex = 0;
  bool isOpeningLessonMap = false;

  final List<String> grades = ['1° y 2°', '3° y 4°', '5° y 6°'];

  @override
  void initState() {
    super.initState();
    loadLocalGrade();
    loadUserGrade();
  }

  Future<void> saveLocalGradeSummary({
    required String userId,
    required String grade,
  }) async {
    final box = Hive.box('user_data');
    final savedGrades = Map<String, String>.from(
      box.get('${userId}_grades') ?? {},
    );

    savedGrades[widget.subject] = grade;
    await box.put('${userId}_grades', savedGrades);
  }

  Future<void> saveGradeToSupabase({
    required String userId,
    required String grade,
  }) async {
    await Supabase.instance.client
        .from('user_subjects')
        .delete()
        .eq('user_id', userId)
        .eq('subject', widget.subject);

    await Supabase.instance.client.from('user_subjects').insert({
      'user_id': userId,
      'subject': widget.subject,
      'grade': grade,
    });
  }

  Future<void> loadLocalGrade() async {
    final user = Supabase.instance.client.auth.currentUser;
    final box = Hive.box('user_data');

    if (user == null) return;

    final localGrade = box.get('${user.id}_${widget.subject}');
    if (localGrade == null) return;

    final index = grades.indexOf(localGrade);
    if (index == -1 || !mounted) return;

    setState(() {
      selectedIndex = index;
    });
  }

  Future<void> loadUserGrade() async {
    final user = Supabase.instance.client.auth.currentUser;
    final box = Hive.box('user_data');

    if (user == null) return;

    try {
      final localGrade = box.get('${user.id}_${widget.subject}');
      final hasPendingGrade =
          box.get('pending_${user.id}_${widget.subject}') == true;

      if (hasPendingGrade && localGrade != null) {
        await saveGradeToSupabase(userId: user.id, grade: localGrade);
        await box.put('pending_${user.id}_${widget.subject}', false);
      }

      final response = await Supabase.instance.client
          .from('user_subjects')
          .select('grade')
          .eq('user_id', user.id)
          .eq('subject', widget.subject);

      final savedGrade = response.isNotEmpty ? response.last['grade'] : null;

      if (savedGrade == null) return;

      await box.put('${user.id}_${widget.subject}', savedGrade);
      await saveLocalGradeSummary(userId: user.id, grade: savedGrade);
      await box.put('pending_${user.id}_${widget.subject}', false);

      final index = grades.indexOf(savedGrade);
      if (index == -1 || !mounted) return;

      setState(() {
        selectedIndex = index;
      });
    } catch (e) {
      debugPrint("Sin conexion, usando grado local: $e");
    }
  }

  Future<void> saveGrade(int index) async {
    final user = Supabase.instance.client.auth.currentUser;
    final box = Hive.box('user_data');

    if (user == null) return;

    final grade = grades[index];
    await box.put('${user.id}_${widget.subject}', grade);
    await saveLocalGradeSummary(userId: user.id, grade: grade);
    await box.put('pending_${user.id}_${widget.subject}', true);

    try {
      await saveGradeToSupabase(userId: user.id, grade: grade);
      await box.put('pending_${user.id}_${widget.subject}', false);
    } catch (e) {
      debugPrint("Guardado offline: $e");
    }
  }

  String getShortLabel(int index) {
    switch (index) {
      case 0:
        return "1-2";
      case 1:
        return "3-4";
      case 2:
        return "5-6";
      default:
        return "";
    }
  }

  Future<void> openLessonMap(int index) async {
    if (isOpeningLessonMap) return;

    setState(() {
      selectedIndex = index;
      isOpeningLessonMap = true;
    });

    try {
      await saveGrade(index);

      if (!mounted) return;
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => LessonMapPage(
            subject: widget.subject,
            grade: grades[index],
            color: widget.color,
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isOpeningLessonMap = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: Text(widget.subject.toUpperCase()),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              Text(
                widget.subject.toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Selecciona tu grado",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 28),
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: grades.length,
                  itemBuilder: (context, index) {
                    final isSelected = index == selectedIndex;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 18),
                      child: GestureDetector(
                        onTap: () => openLessonMap(index),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? widget.color : Colors.white,
                              width: 2,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 34,
                                backgroundColor: widget.color,
                                child: Text(
                                  getShortLabel(index),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 18),
                              Expanded(
                                child: Text(
                                  "${grades[index]} de primaria",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios, size: 18),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
