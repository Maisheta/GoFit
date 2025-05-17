import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class StatisticsScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> _getUserStats() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    final docRef = _firestore.collection('users').doc(user.uid);
    final doc = await docRef.get();

    if (!doc.exists) {
      final defaultData = {
        'name': user.email?.split('@')[0] ?? 'User',
        'steps': 0,
        'calories': 0,
        'goalSteps': 10000,
        'goalCalories': 300,
        'weeklyProgress': List.filled(7, 0),
        'joinedAt': DateTime.now(),
      };
      await docRef.set(defaultData);
      return defaultData;
    }

    return doc.data()!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Statistics')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _getUserStats(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          if (snapshot.hasError)
            return Center(child: Text('Error loading data.'));

          final data = snapshot.data!;
          final steps = data['steps'] ?? 0;
          final calories = data['calories'] ?? 0;
          final goalSteps = data['goalSteps'] ?? 10000;
          final goalCalories = data['goalCalories'] ?? 300;
          final joinedAt = data['joinedAt']?.toDate() ?? DateTime.now();
          final List weekly = data['weeklyProgress'] ?? List.filled(7, 0);
          final List<FlSpot> progress = List.generate(
            weekly.length,
            (i) => FlSpot(i.toDouble(), (weekly[i] as num).toDouble()),
          );

          final int streak = weekly.where((e) => e > 0).length;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Today\'s Overview',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _statCard(
                        'Steps',
                        steps.toString(),
                        Icons.directions_walk,
                      ),
                      _statCard(
                        'Calories',
                        '$calories kcal',
                        Icons.local_fire_department,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Goal Progress',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  _goalProgress('Steps', steps, goalSteps, Colors.orangeAccent),
                  SizedBox(height: 10),
                  _goalProgress(
                    'Calories',
                    calories,
                    goalCalories,
                    Colors.orangeAccent,
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Weekly Progress',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Container(
                    height: 250,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, _) {
                                const days = [
                                  'S',
                                  'M',
                                  'T',
                                  'W',
                                  'T',
                                  'F',
                                  'S',
                                ];
                                return Padding(
                                  padding: EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    days[value.toInt()],
                                    style: TextStyle(fontSize: 12),
                                  ),
                                );
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              interval: 2000,
                              getTitlesWidget:
                                  (value, _) => Text('${value.toInt()}'),
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: progress,
                            isCurved: true,
                            gradient: LinearGradient(
                              colors: [Colors.orange, Colors.deepOrangeAccent],
                            ),
                            barWidth: 4,
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                colors: [
                                  Colors.orange.withOpacity(0.3),
                                  Colors.deepOrangeAccent.withOpacity(0.1),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            dotData: FlDotData(show: true),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'User Info',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.date_range, color: Colors.grey[600]),
                      SizedBox(width: 8),
                      Text('Joined: ${DateFormat.yMMMd().format(joinedAt)}'),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.local_fire_department,
                        color: Colors.deepOrangeAccent,
                      ),
                      SizedBox(width: 8),
                      Text('Active Days This Week: $streak/7'),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _statCard(String title, String value, IconData icon) {
    return Container(
      width: 150,
      height: 120,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.orangeAccent, size: 28),
          SizedBox(height: 10),
          Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          Text(
            value,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _goalProgress(String label, int value, int goal, Color color) {
    final ratio = (value / goal).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: $value / $goal', style: TextStyle(fontSize: 14)),
        SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 12,
            backgroundColor: color.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
