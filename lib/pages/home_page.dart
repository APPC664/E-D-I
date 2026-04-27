import 'package:flutter/material.dart';
import '../widgets/subject_card.dart';
import 'math_page.dart';
import 'spanish_page.dart';
import 'grade_selection_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              const Text(
                "EDI",
                style: TextStyle(
                    fontSize: 40, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              const Text("¡Aprender y jugar, para todos por igual!"),

              const SizedBox(height: 20),

              SubjectCard(
                title: "Matemáticas",
                subtitle: "Números, operaciones y más",
                color: Colors.red,
                icon: Icons.calculate,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const GradeSelectionPage(
                        subject: "Matemáticas",
                        color: Colors.red,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              SubjectCard(
                title: "Español",
                subtitle: "Lectura, escritura y literatura",
                color: Colors.blue,
                icon: Icons.menu_book,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const GradeSelectionPage(
                        subject: "Español",
                        color: Colors.blue,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}