import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ActivityHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

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
                .doc(user.uid)
                .collection('activities')
                .orderBy(
                  'date',
                  descending: true,
                ) // بناءً على الحقل اللي انت حفظته
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final activities = snapshot.data?.docs ?? [];

          if (activities.isEmpty) {
            return Center(child: Text('No activities logged yet.'));
          }

          return ListView.builder(
            itemCount: activities.length,
            itemBuilder: (context, index) {
              final activity = activities[index].data() as Map<String, dynamic>;
              final date = (activity['date'] as Timestamp).toDate();
              final formattedDate = DateFormat(
                'dd MMM yyyy • hh:mm a',
              ).format(date);

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
        },
      ),
    );
  }
}
