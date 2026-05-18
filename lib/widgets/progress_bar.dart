import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final double value;
  final Color color;

  const ProgressBar({
    super.key,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: LinearProgressIndicator(
        value: value.clamp(0, 1),
        minHeight: 10,
        backgroundColor: Colors.black12,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}
