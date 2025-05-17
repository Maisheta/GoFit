import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // ← مهم تضيفه هنا
import '../provider/workout_provider.dart';
import 'workout_in_progress.dart';

class WorkoutDetailScreen extends StatelessWidget {
  final String title;
  final String imagePath;
  final String duration;
  final String level;
  final List<String> steps;

  const WorkoutDetailScreen({
    required this.title,
    required this.imagePath,
    required this.duration,
    required this.level,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Icon(Icons.timer, color: Colors.orange),
                SizedBox(width: 8),
                Text(duration),
                SizedBox(width: 20),
                Icon(Icons.fitness_center, color: Colors.orange),
                SizedBox(width: 8),
                Text(level),
              ],
            ),

            const SizedBox(height: 30),

            Text(
              'Steps',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...steps.asMap().entries.map((entry) {
              int idx = entry.key;
              String step = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.orange,
                      child: Text(
                        '${idx + 1}',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(child: Text(step, style: TextStyle(fontSize: 16))),
                  ],
                ),
              );
            }),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                final workoutProvider = Provider.of<WorkoutProvider>(
                  context,
                  listen: false,
                );
                workoutProvider.reset();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => WorkoutInProgress(
                          title: title,
                          imagePath: imagePath,
                        ),
                  ),
                );
              },
              child: Text('Start Workout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
