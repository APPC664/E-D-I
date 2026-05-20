import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../screens/login_screen.dart';
import '../services/progress_service.dart';
import '../widgets/progress_bar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = "";
  Map<String, String> grades = {};

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
      if (key is! String || !key.startsWith(userPrefix)) continue;
      if (key == '${userId}_name' || key == '${userId}_grades') continue;

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
      if (key is! String || !key.startsWith(userPrefix)) continue;
      if (key == '${userId}_name' || key == '${userId}_grades') continue;

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

    if (user == null) return;

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

  Future<void> logout() async {
    final confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Cerrar sesion"),
        content: const Text("Estas seguro que deseas salir?"),
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

      if (!mounted) return;
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
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: const Text("Perfil"),
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
              const SizedBox(height: 16),
              Text(
                name.isEmpty ? "Perfil" : name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Tus grados:",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...grades.entries.map((entry) {
                final subjectKey = entry.key.toLowerCase().contains("matem")
                    ? "math"
                    : "spanish";
                final progress = ProgressService.progressValue(
                  subject: subjectKey,
                  grade: entry.value,
                  totalLevels: 3,
                );

                return Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(entry.key),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Grado: ${entry.value}"),
                        const SizedBox(height: 8),
                        ProgressBar(
                          value: progress,
                          color:
                              subjectKey == "math" ? Colors.red : Colors.blue,
                        ),
                        const SizedBox(height: 4),
                        Text("${(progress * 100).round()}% completado"),
                      ],
                    ),
                  ),
                );
              }),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: logout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text(
                    "Cerrar sesion",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
