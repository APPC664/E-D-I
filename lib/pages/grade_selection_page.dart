import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
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

  final List<String> grades = ['1° y 2°', '3° y 4°', '5° y 6°'];

  @override
  void initState() {
    super.initState();

    loadLocalGrade();   // 🟡 LOCAL (rápido)
    loadUserGrade();    // 🔵 REMOTO (actualiza)
  }

  // 🟡 CARGAR DESDE HIVE
  Future<void> loadLocalGrade() async {
    final user = Supabase.instance.client.auth.currentUser;
    final box = Hive.box('user_data');

    if (user != null) {
      final localGrade = box.get('${user.id}_${widget.subject}');

      if (localGrade != null) {
        final index = grades.indexOf(localGrade);
        if (index != -1) {
          setState(() {
            selectedIndex = index;
          });
        }
      }
    }
  }

  // 🔵 CARGAR DESDE SUPABASE
  Future<void> loadUserGrade() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user != null) {
      final response = await Supabase.instance.client
          .from('user_subjects')
          .select('grade')
          .eq('user_id', user.id)
          .eq('subject', widget.subject)
          .maybeSingle();

      final savedGrade = response?['grade'];

      if (savedGrade != null) {
        final index = grades.indexOf(savedGrade);
        if (index != -1) {
          setState(() {
            selectedIndex = index;
          });
        }
      }
    }
  }

  // 💾 GUARDAR (OFFLINE-FIRST)
  Future<void> saveGrade(int index) async {
    final user = Supabase.instance.client.auth.currentUser;
    final box = Hive.box('user_data');

    if (user != null) {
      final grade = grades[index];

      // 🟡 1. Guardar SIEMPRE local
      await box.put('${user.id}_${widget.subject}', grade);

      try {
        // 🔵 2. Intentar guardar en Supabase
        await Supabase.instance.client
            .from('user_subjects')
            .upsert({
              'user_id': user.id,
              'subject': widget.subject,
              'grade': grade,
            });

      } catch (e) {
        // 📴 3. Si falla → queda en local
        print("Guardado offline: $e");
      }
    }
  }

  // 🎯 Texto corto
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: Text(widget.subject),
        backgroundColor: widget.color,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            const SizedBox(height: 10),

            const Text(
              "Selecciona tu nivel",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: grades.length,
                itemBuilder: (context, index) {
                  final isSelected = index == selectedIndex;

                  return Column(
                    children: [

                      GestureDetector(
                        onTap: () async {
                          setState(() {
                            selectedIndex = index;
                          });

                          await saveGrade(index);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => LessonMapPage(
                                subject: widget.subject,
                                grade: grades[index],
                                color: widget.color,
                              ),
                            ),
                          );
                        },
                        child: Column(
                          children: [

                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: widget.color,
                                shape: BoxShape.circle,
                                border: isSelected
                                    ? Border.all(color: Colors.black, width: 3)
                                    : Border.all(color: Colors.transparent),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  getShortLabel(index),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 5),

                            Text(
                              "${grades[index]} Primaria",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      if (index != grades.length - 1)
                        Container(
                          width: 3,
                          height: 50,
                          color: Colors.grey,
                        ),
                    ],
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