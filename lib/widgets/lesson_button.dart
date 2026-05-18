import 'package:flutter/material.dart';

class LessonButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;

  const LessonButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        minimumSize: const Size(72, 48),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }
}
