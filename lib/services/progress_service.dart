import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProgressService {
  static const String progressTable = 'progress';

  static String progressKey({
    required String userId,
    required String subject,
    required String grade,
    required int level,
  }) {
    return '${userId}_${subject}_${grade}_level_$level';
  }

  static String pendingProgressKey(String key) {
    return 'pending_progress_$key';
  }

  static String lessonId({
    required String subject,
    required String grade,
    required int level,
  }) {
    final source = '$subject|$grade|$level';
    var hash = 0x811c9dc5;

    for (final unit in source.codeUnits) {
      hash ^= unit;
      hash = (hash * 0x01000193) & 0xffffffff;
    }

    String part(int salt) {
      final value = (hash ^ (salt * 0x45d9f3b)) & 0xffffffff;
      return value.toRadixString(16).padLeft(8, '0');
    }

    return '${part(1)}-${part(2).substring(0, 4)}-4${part(3).substring(1, 4)}-'
        '8${part(4).substring(1, 4)}-${part(5)}${part(6).substring(0, 4)}';
  }

  static Future<void> saveProgressToSupabase({
    required String userId,
    required String subject,
    required String grade,
    required int level,
  }) async {
    await Supabase.instance.client
        .from(progressTable)
        .delete()
        .eq('user_id', userId)
        .eq(
          'lesson_id',
          lessonId(subject: subject, grade: grade, level: level),
        );

    await Supabase.instance.client.from(progressTable).insert({
      'user_id': userId,
      'lesson_id': lessonId(subject: subject, grade: grade, level: level),
      'completed': true,
      'score': 100,
      'mistakes': 0,
      'completed_at': DateTime.now().toIso8601String(),
    });
  }

  static Future<void> completeLevel({
    required String subject,
    required String grade,
    required int level,
  }) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final box = Hive.box('user_data');
    final key = progressKey(
      userId: user.id,
      subject: subject,
      grade: grade,
      level: level,
    );

    await box.put(key, true);
    await box.put(pendingProgressKey(key), true);

    try {
      await saveProgressToSupabase(
        userId: user.id,
        subject: subject,
        grade: grade,
        level: level,
      );
      await box.put(pendingProgressKey(key), false);
    } catch (e) {
      // El progreso queda guardado localmente y pendiente de sincronizar.
    }
  }

  static Future<void> syncPendingProgress({
    required String subject,
    required String grade,
    required int totalLevels,
  }) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final box = Hive.box('user_data');

    for (int level = 1; level <= totalLevels; level++) {
      final key = progressKey(
        userId: user.id,
        subject: subject,
        grade: grade,
        level: level,
      );
      final isCompleted = box.get(key) == true;
      final isPending = box.get(pendingProgressKey(key)) == true;

      if (!isCompleted || !isPending) continue;

      try {
        await saveProgressToSupabase(
          userId: user.id,
          subject: subject,
          grade: grade,
          level: level,
        );
        await box.put(pendingProgressKey(key), false);
      } catch (e) {
        return;
      }
    }
  }

  static Future<void> loadRemoteProgress({
    required String subject,
    required String grade,
  }) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final box = Hive.box('user_data');

    try {
      final rows = await Supabase.instance.client
          .from(progressTable)
          .select('lesson_id, completed')
          .eq('user_id', user.id)
          .eq('completed', true);

      for (final row in rows) {
        final remoteLessonId = row['lesson_id'];

        for (int level = 1; level <= 3; level++) {
          final expectedLessonId = lessonId(
            subject: subject,
            grade: grade,
            level: level,
          );

          if (remoteLessonId != expectedLessonId) continue;

          await box.put(
            progressKey(
              userId: user.id,
              subject: subject,
              grade: grade,
              level: level,
            ),
            true,
          );
        }
      }
    } catch (e) {
      // Si Supabase no responde o la tabla aun no existe, se conserva Hive.
    }
  }

  static bool isLevelCompleted({
    required String subject,
    required String grade,
    required int level,
  }) {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return false;

    final box = Hive.box('user_data');
    return box.get(
          progressKey(
            userId: user.id,
            subject: subject,
            grade: grade,
            level: level,
          ),
        ) ==
        true;
  }

  static double progressValue({
    required String subject,
    required String grade,
    required int totalLevels,
  }) {
    if (totalLevels == 0) return 0;

    int completed = 0;
    for (int level = 1; level <= totalLevels; level++) {
      if (isLevelCompleted(
        subject: subject,
        grade: grade,
        level: level,
      )) {
        completed++;
      }
    }

    return completed / totalLevels;
  }
}
