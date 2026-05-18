import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/login_screen.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://pranzwmeybolhmvcyidd.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InByYW56d21leWJvbGhtdmN5aWRkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQzMDk2MTksImV4cCI6MjA4OTg4NTYxOX0.9EDHJvmcNIiSSUHgr8d-w6wEYvCQdwIfUaX0lTqfvsM',
  );

  await Hive.initFlutter();
  await Hive.openBox('user_data');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute:
          Supabase.instance.client.auth.currentSession == null ? '/' : '/home',
      routes: {
        '/': (context) => const LoginScreen(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
