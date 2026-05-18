import 'package:flutter/material.dart';

import '../../../../services/progress_service.dart';

class Level1CountingPage extends StatefulWidget {
  final String grade;
  final Color color;

  const Level1CountingPage({
    super.key,
    required this.grade,
    required this.color,
  });

  @override
  State<Level1CountingPage> createState() => _Level1CountingPageState();
}

class _Level1CountingPageState extends State<Level1CountingPage> {
  final List<int> balloonNumbers = [4, 2, 5, 3, 10, 8, 1, 7, 6, 9];
  final Set<int> poppedBalloons = {};
  int nextBalloon = 1;
  String message = "";
  bool completed = false;

  Future<void> completeLevel() async {
    await ProgressService.completeLevel(
      subject: "math",
      grade: widget.grade,
      level: 1,
    );

    if (!mounted) return;
    setState(() {
      completed = true;
      message = "Muy bien, completaste el conteo.";
    });
  }

  void tapBalloon(int number) {
    if (poppedBalloons.contains(number) || completed) return;

    if (number == nextBalloon) {
      setState(() {
        poppedBalloons.add(number);
        nextBalloon++;
        message = number == 10
            ? "Muy bien, completaste el conteo."
            : "Correcto. Ahora busca el $nextBalloon.";
      });

      if (number == 10) {
        completeLevel();
      }
    } else {
      setState(() {
        message = "Intenta otra vez. Toca primero el $nextBalloon.";
      });
    }
  }

  Widget buildMessage() {
    if (message.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: completed ? Colors.green.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: completed ? Colors.green : Colors.black12,
        ),
      ),
      child: Text(
        message,
        style: TextStyle(
          color: completed ? Colors.green.shade900 : Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildBalloon(int number) {
    final isPopped = poppedBalloons.contains(number);

    return GestureDetector(
      onTap: () => tapBalloon(number),
      child: AnimatedOpacity(
        opacity: isPopped ? 0.18 : 1,
        duration: const Duration(milliseconds: 180),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 68,
              height: 82,
              decoration: BoxDecoration(
                color: isPopped ? Colors.grey : widget.color,
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  "$number",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              width: 2,
              height: 18,
              color: Colors.black26,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: const Text("Nivel 1"),
        backgroundColor: widget.color,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: widget.color,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Principiante",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Explota los globos del 1 al 10",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      "Toca los globos en orden, empezando por el 1.",
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 14,
                      runSpacing: 18,
                      children: balloonNumbers.map(buildBalloon).toList(),
                    ),
                  ],
                ),
              ),
              buildMessage(),
            ],
          ),
        ),
      ),
    );
  }
}
