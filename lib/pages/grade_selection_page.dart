import 'package:flutter/material.dart';
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

  final List<String> grades = ['1°', '2°', '3°', '4°', '5°', '6°'];

  @override
  void initState() {
    super.initState();
    loadUserGrade();
  }

  // 📥 CARGAR grado guardado
  Future<void> loadUserGrade() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user != null) {
      final response = await Supabase.instance.client
          .from('users')
          .select('grade')
          .eq('id', user.id)
          .single();

      final savedGrade = response['grade'];

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

  // 💾 GUARDAR grado
  Future<void> saveGrade(int index) async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user != null) {
      await Supabase.instance.client
          .from('users')
          .update({'grade': grades[index]})
          .eq('id', user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            const SizedBox(height: 40),

            // 🎓 TÍTULO
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.school, color: widget.color),
                const SizedBox(width: 10),
                const Text(
                  "Selecciona tu Grado",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Text(
              "Elige el grado de ${widget.subject}",
              style: const TextStyle(color: Colors.black54),
            ),

            const SizedBox(height: 30),

            // 📦 GRID
            Expanded(
              child: GridView.builder(
                itemCount: grades.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                ),
                itemBuilder: (context, index) {
                  final isSelected = index == selectedIndex;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });

                      saveGrade(index); // guardar sin bloquear

                      // 🚀 NAVEGAR A LECCIONES
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
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [

                        // TARJETA
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: isSelected
                                ? Border.all(color: Colors.black, width: 2)
                                : null,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              Icon(Icons.school,
                                  size: 30, color: widget.color),

                              const SizedBox(height: 10),

                              Text(
                                "${grades[index]} Primaria",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 10),

                              Text(
                                grades[index].replaceAll('°', ''),
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // 🔵 ETIQUETA
                        if (isSelected)
                          Positioned(
                            top: -10,
                            left: 15,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: widget.color,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                "Tu grado",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                      ],
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