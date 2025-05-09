import 'package:flutter/material.dart';
import 'workout_detail_screen.dart';

class ExploreScreen extends StatelessWidget {
  final List<Map<String, dynamic>> workouts = [
    {
      'name': 'Full Body Burn',
      'image': 'assets/b1.jpg',
      'duration': '20 mins',
      'level': 'Beginner',
    },
    {
      'name': 'Cardio Blast',
      'image': 'assets/c1.jpeg',
      'duration': '30 mins',
      'level': 'Intermediate',
    },
    {
      'name': 'Yoga Flex',
      'image': 'assets/y1.jpeg',
      'duration': '25 mins',
      'level': 'Beginner',
    },
    {
      'name': 'Strength Training',
      'image': 'assets/s1.jpg',
      'duration': '40 mins',
      'level': 'Advanced',
    },
    {
      'name': 'HIIT Power',
      'image': 'assets/h1.jpeg',
      'duration': '15 mins',
      'level': 'Intermediate',
    },
    {
      'name': 'Pilates Flow',
      'image': 'assets/p1.jpg',
      'duration': '25 mins',
      'level': 'Beginner',
    },
    {
      'name': 'Balance & Mobility',
      'image': 'assets/m1.jpeg',
      'duration': '20 mins',
      'level': 'Beginner',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Explore Workouts'),
        backgroundColor: Colors.orangeAccent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Workouts List
            Text(
              'Workouts',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: workouts.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 5,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => WorkoutDetailScreen(
                                  title: workouts[index]['name'],
                                  imagePath: workouts[index]['image'],
                                  duration: workouts[index]['duration'],
                                  level: workouts[index]['level'],
                                  steps: [
                                    'Start with warm-up for 3 mins',
                                    'Jumping jacks – 30 sec',
                                    'Push-ups – 15 reps',
                                    'Squats – 20 reps',
                                    'Plank – 45 sec',
                                    'Cool down – 3 mins',
                                  ],
                                ),
                          ),
                        );
                      },
                      child: Container(
                        height: 180,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(
                            image: AssetImage(workouts[index]['image']),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.4),
                              BlendMode.darken,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  workouts[index]['name'],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.timer,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      workouts[index]['duration'],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Icon(
                                      Icons.star_border,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      workouts[index]['level'],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
