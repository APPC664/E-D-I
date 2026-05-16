import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../screens/login_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  String name = "";
  Map<String, String> grades = {}; // materia → grado

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user != null) {
      final userData = await Supabase.instance.client
          .from('users')
          .select('name')
          .eq('id', user.id)
          .maybeSingle();

      final subjects = await Supabase.instance.client
          .from('user_subjects')
          .select()
          .eq('user_id', user.id);

      Map<String, String> tempGrades = {};

      for (var item in subjects) {
        tempGrades[item['subject']] = item['grade'];
      }

      setState(() {
        name = userData?['name'] ?? 'Sin nombre';
        grades = tempGrades;
      });
    }
  }

  // 🔐 LOGOUT
  Future<void> logout() async {
    final confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Cerrar sesión"),
        content: const Text("¿Estás seguro que deseas salir?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Salir"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await Supabase.instance.client.auth.signOut();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Perfil"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 20),

            Text(
              "👤 $name",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Tus grados:",
              style: TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 10),

            ...grades.entries.map((entry) {
              return Card(
                child: ListTile(
                  title: Text(entry.key),
                  subtitle: Text("Grado: ${entry.value}"),
                ),
              );
            }),

            const SizedBox(height: 30),

            const Text(
              "Progreso (próximamente):",
              style: TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 10),

            const Text("Aquí verás tu avance en niveles 🚀"),

            const SizedBox(height: 40),

            // 🔴 BOTÓN LOGOUT
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  "Cerrar sesión",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}