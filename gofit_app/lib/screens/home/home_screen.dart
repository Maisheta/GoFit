import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../workout/CourseDetailScreen.dart';
import '../stats/LogActivityScreen.dart';
import '../stats/activity_history_screen.dart';
import '../goals/set_goal_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String username = '';
  bool isLoading = true;
  Map<String, dynamic> userGoals = {};

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _getUserData();
    await _getUserGoals();
  }

  Future<void> _getUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();
        setState(() {
          username = doc['username'] ?? 'No Name';
        });
      }
    } catch (e) {
      username = 'Error';
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _getUserGoals() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc =
            await FirebaseFirestore.instance
                .collection('goals')
                .doc(user.uid)
                .get();
        if (doc.exists) {
          setState(() {
            userGoals = doc.data()!;
          });
        }
      }
    } catch (e) {
      print('Failed to load goals: $e');
    }
  }

  final List<Map<String, dynamic>> popularCourses = [
    {'title': 'Core Strength', 'image': 'assets/c1.jpeg'},
    {'title': 'HIIT Blast', 'image': 'assets/h1.jpeg'},
    {'title': 'Yoga Flex', 'image': 'assets/y1.jpeg'},
    {'title': 'Leg Day', 'image': 'assets/on1.jpg'},
  ];

  final List<Map<String, dynamic>> recommendedCourses = [
    {
      'title': 'Upper Body Burn',
      'level': 'Beginner',
      'duration': '15 mins',
      'icon': Icons.accessibility_new,
      'image': 'assets/c1.jpeg',
      'description':
          'A quick and effective upper body workout to build strength.',
      'requirements': ['Yoga Mat', 'Dumbbells'],
    },
    {
      'title': 'Endurance Builder',
      'level': 'Intermediate',
      'duration': '45 mins',
      'icon': Icons.directions_bike,
      'image': 'assets/h1.jpeg',
      'description':
          'Boost your stamina and endurance with this cardio-focused session.',
      'requirements': ['Water Bottle', 'Running Shoes'],
    },
    {
      'title': 'Mindful Yoga',
      'level': 'All Levels',
      'duration': '30 mins',
      'icon': Icons.self_improvement,
      'image': 'assets/y1.jpeg',
      'description': 'Relax your mind and stretch your body with gentle yoga.',
      'requirements': ['Yoga Mat', 'Calm Environment'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child:
            isLoading
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundImage: AssetImage(
                                  'assets/coach1.png',
                                ),
                              ),
                              SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Hello, $username 👋',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Let’s crush your goals today!',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Icon(Icons.notifications_none, size: 28),
                        ],
                      ),
                      SizedBox(height: 30),

                      // Today's Workout
                      Text(
                        'Today\'s Workout',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        height: 160,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: [Colors.orangeAccent, Colors.deepOrange],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          image: DecorationImage(
                            image: AssetImage('assets/on2.png'),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.4),
                              BlendMode.darken,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              'Full Body Training\n30 Mins',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),

                      // Log Activity & History
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => LogActivityScreen(),
                                  ),
                                );
                              },
                              icon: Icon(Icons.edit_calendar),
                              label: Text('Log Activity'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orangeAccent,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ActivityHistoryScreen(),
                                  ),
                                );
                              },
                              icon: Icon(Icons.history),
                              label: Text('History'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepOrangeAccent,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),

                      // Popular Trainings
                      Text(
                        'Popular Trainings',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 12),
                      SizedBox(
                        height: 160,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: popularCourses.length,
                          itemBuilder: (context, index) {
                            final course = popularCourses[index];
                            return Container(
                              width: 140,
                              margin: EdgeInsets.only(right: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(12),
                                    ),
                                    child: Image.asset(
                                      course['image'],
                                      height: 100,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                      vertical: 4.0,
                                    ),
                                    child: Text(
                                      course['title'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                      // Daily Goals
                      Text(
                        'Your Daily Goals',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildGoalBox('Steps', userGoals['steps'] ?? 0),
                          _buildGoalBox('Calories', userGoals['calories'] ?? 0),
                          _buildGoalBox(
                            'Duration',
                            '${userGoals['duration'] ?? 0} min',
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => SetGoalScreen()),
                          );

                          if (result == true) {
                            await _getUserGoals();
                            setState(() {});
                          }
                        },

                        icon: Icon(Icons.flag),
                        label: Text('Set Goals'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orangeAccent,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20),

                      // Recommended Courses
                      Text(
                        'Recommended Courses',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 12),
                      Column(
                        children:
                            recommendedCourses.map((course) {
                              return Container(
                                margin: EdgeInsets.only(bottom: 14),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  leading: Icon(
                                    course['icon'],
                                    size: 36,
                                    color: Colors.orangeAccent,
                                  ),
                                  title: Text(
                                    course['title'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${course['level']} • ${course['duration']}',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                  trailing: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 18,
                                    color: Colors.grey,
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => CourseDetailScreen(
                                              course: course,
                                            ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }).toList(),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }

  Widget _buildGoalBox(String label, dynamic value) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 6),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 3,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              '$value',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.orangeAccent,
              ),
            ),
            SizedBox(height: 6),
            Text(label, style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}
