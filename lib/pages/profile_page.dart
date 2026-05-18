import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
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

  Map<String, String> loadLocalGradeSummary(Box box, String userId) {
    final localGrades = Map<String, String>.from(
      box.get('${userId}_grades') ?? {},
    );
    final userPrefix = '${userId}_';

    for (final key in box.keys) {
      if (key is! String || !key.startsWith(userPrefix)) {
        continue;
      }

      if (key == '${userId}_name' || key == '${userId}_grades') {
        continue;
      }

      final value = box.get(key);
      if (value is String) {
        final subject = key.substring(userPrefix.length);
        localGrades[subject] = value;
      }
    }

    return localGrades;
  }

  Map<String, String> applyPendingLocalGrades(
    Box box,
    String userId,
    Map<String, String> remoteGrades,
  ) {
    final mergedGrades = Map<String, String>.from(remoteGrades);
    final userPrefix = '${userId}_';

    for (final key in box.keys) {
      if (key is! String || !key.startsWith(userPrefix)) {
        continue;
      }

      if (key == '${userId}_name' || key == '${userId}_grades') {
        continue;
      }

      final subject = key.substring(userPrefix.length);
      final isPending = box.get('pending_${userId}_$subject') == true;
      final value = box.get(key);

      if (isPending && value is String) {
        mergedGrades[subject] = value;
      }
    }

    return mergedGrades;
  }

  Future<void> loadProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    final box = Hive.box('user_data');

    if (user != null) {
      final localName = box.get('${user.id}_name');
      final localGrades = loadLocalGradeSummary(box, user.id);

      if (localName != null || localGrades.isNotEmpty) {
        setState(() {
          name = localName ?? 'Sin nombre';
          grades = localGrades;
        });
      }

      try {
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

        final remoteName = userData?['name'] ?? 'Sin nombre';
        tempGrades.addAll(localGrades);
        tempGrades = applyPendingLocalGrades(box, user.id, tempGrades);

        await box.put('${user.id}_name', remoteName);
        await box.put('${user.id}_grades', tempGrades);

        if (!mounted) return;
        setState(() {
          name = remoteName;
          grades = tempGrades;
        });
      } catch (e) {
        debugPrint("Perfil cargado desde datos locales: $e");
      }
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
