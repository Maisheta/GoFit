import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ActivityHistoryScreen extends StatefulWidget {
  @override
  _ActivityHistoryScreenState createState() => _ActivityHistoryScreenState();
}

class _ActivityHistoryScreenState extends State<ActivityHistoryScreen> {
  final user = FirebaseAuth.instance.currentUser;
  late Box activityBox;

  @override
  void initState() {
    super.initState();
    activityBox = Hive.box('activityBox');
  }

  Future<void> _cacheActivities(List<QueryDocumentSnapshot> docs) async {
    List<Map<String, dynamic>> localData =
        docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return {
            'activityType': data['activityType'],
            'duration': data['duration'],
            'calories': data['calories'],
            'date': (data['date'] as Timestamp).toDate().toIso8601String(),
          };
        }).toList();

    await activityBox.put('activities', localData);
  }

  List<Map<String, dynamic>> _getLocalActivities() {
    final local = activityBox.get('activities', defaultValue: []) as List;
    return local.cast<Map<String, dynamic>>();
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(body: Center(child: Text('Please log in')));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Activities'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('users')
                .doc(user!.uid)
                .collection('activities')
                .orderBy('date', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            // Show local if error
            final localActivities = _getLocalActivities();
            return _buildActivityList(localActivities);
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final activities = snapshot.data?.docs ?? [];

          if (activities.isEmpty) {
            return Center(child: Text('No activities logged yet.'));
          }

          _cacheActivities(activities); // Save to Hive

          final dataList =
              activities.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return {
                  'activityType': data['activityType'],
                  'duration': data['duration'],
                  'calories': data['calories'],
                  'date':
                      (data['date'] as Timestamp).toDate().toIso8601String(),
                };
              }).toList();

          return _buildActivityList(dataList);
        },
      ),
    );
  }

  Widget _buildActivityList(List<Map<String, dynamic>> data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        final activity = data[index];
        final date = DateTime.parse(activity['date']);
        final formattedDate = DateFormat('dd MMM yyyy • hh:mm a').format(date);

        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: Icon(Icons.fitness_center, color: Colors.orange),
            title: Text(activity['activityType']),
            subtitle: Text(
              'Duration: ${activity['duration']} mins\n'
              'Calories: ${activity['calories']} kcal\n'
              'Date: $formattedDate',
            ),
          ),
        );
      },
    );
  }
}
