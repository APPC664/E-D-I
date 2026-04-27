import 'package:flutter/material.dart';

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
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: Text("$subject - $grade"),
        backgroundColor: color,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView.builder(
          itemCount: 10, // 👈 simulamos 10 lecciones
          itemBuilder: (context, index) {
            return Column(
              children: [

                // CÍRCULO (lección)
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  child: Column(
                    children: [

                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
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
                            "${index + 1}",
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
                        "Lección ${index + 1}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),

                // Línea de conexión (excepto la última)
                if (index != 9)
                  Container(
                    width: 2,
                    height: 30,
                    color: Colors.grey,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}