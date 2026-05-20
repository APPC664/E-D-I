import 'package:flutter/material.dart';

import '../widgets/subject_card.dart';
import 'grade_selection_page.dart';
import 'profile_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text("EDI"),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfilePage()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 18),
              const Text(
                "EDI",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 46, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Aprender y jugar, para todos por igual!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 34),
              SubjectCard(
                title: "MATEMATICAS",
                subtitle: "Numeros, operaciones y problemas",
                color: Colors.red,
                icon: Icons.calculate,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const GradeSelectionPage(
                        subject: "Matematicas",
                        color: Colors.red,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              SubjectCard(
                title: "ESPAÑOL",
                subtitle: "Lectura, letras y comprension",
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
