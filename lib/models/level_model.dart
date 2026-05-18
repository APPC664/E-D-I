class LevelModel {
  final String title;
  final String subtitle;
  final String description;
  final bool completed;
  final bool locked;

  const LevelModel({
    required this.title,
    required this.subtitle,
    required this.description,
    this.completed = false,
    this.locked = false,
  });
}
