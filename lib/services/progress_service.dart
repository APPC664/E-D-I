import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProgressService {
  static Future<void> completeLevel({
    required String subject,
    required String grade,
    required int level,
  }) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final box = Hive.box('user_data');
    await box.put(
      '${user.id}_${subject}_${grade}_level_$level',
      true,
    );
  }
}
