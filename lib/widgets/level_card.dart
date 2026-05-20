import 'package:flutter/material.dart';

class LevelCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color color;
  final bool locked;
  final bool completed;
  final VoidCallback onTap;

  const LevelCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.color,
    required this.locked,
    this.completed = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = locked ? Colors.grey : color;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: locked ? Colors.grey.shade500 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: locked ? Colors.grey : color, width: 2),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: cardColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 30,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: locked ? Colors.white : Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: locked ? Colors.white70 : color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: TextStyle(
                      color: locked ? Colors.white : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              locked
                  ? Icons.lock_outline
                  : completed
                      ? Icons.check_circle
                      : Icons.arrow_forward_ios,
              color: locked ? Colors.white : color,
              size: completed ? 24 : 18,
            ),
          ],
        ),
      ),
    );
  }
}
