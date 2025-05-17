import 'package:flutter/material.dart';
import 'workout_in_progress.dart';

class CourseDetailScreen extends StatelessWidget {
  final Map<String, dynamic> course;

  CourseDetailScreen({required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(course['title']),
        backgroundColor: Colors.orangeAccent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Container(
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: AssetImage(course['image']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 24),
            // Title
            Text(
              course['title'],
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                _buildInfoChip(
                  'Level: ${course['level']}',
                  Colors.orangeAccent,
                ),
                SizedBox(width: 12),
                _buildInfoChip('Duration: ${course['duration']}', Colors.green),
              ],
            ),
            SizedBox(height: 24),
            Text(
              'Course Description',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 12),
            Text(
              'This course is designed to help you achieve your fitness goals...',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 24),
            Text(
              'What You Will Need',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 12),
            _buildFeatureList(List<String>.from(course['requirements'] ?? [])),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => WorkoutInProgress(
                            title: course['title'],
                            imagePath: course['image'],
                          ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  minimumSize: Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Start Course'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String label, Color color) {
    return Chip(
      label: Text(label, style: TextStyle(color: Colors.white)),
      backgroundColor: color,
    );
  }

  Widget _buildFeatureList(List<String> features) {
    features = features ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          features.map((feature) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green),
                  SizedBox(width: 8),
                  Text(feature),
                ],
              ),
            );
          }).toList(),
    );
  }
}
