class ProgressModel {
  final String userId;
  final String subject;
  final String grade;
  final int level;
  final bool completed;

  const ProgressModel({
    required this.userId,
    required this.subject,
    required this.grade,
    required this.level,
    required this.completed,
  });
}
