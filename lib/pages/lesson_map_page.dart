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
    final levels = [
      {"title": "Nivel 1", "subtitle": "Básico"},
      {"title": "Nivel 2", "subtitle": "Intermedio"},
      {"title": "Nivel 3", "subtitle": "Avanzado"},
    ];

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
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(20),
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

                    Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.star,
                        size: 30,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(width: 20),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          level["title"]!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          level["subtitle"]!,
                          style: const TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}