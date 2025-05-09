import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LogActivityScreen extends StatefulWidget {
  @override
  _LogActivityScreenState createState() => _LogActivityScreenState();
}

class _LogActivityScreenState extends State<LogActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  String _activityType = 'Running';
  int _duration = 0;
  int _calories = 0;

  void _submitActivity() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('activities')
        .add({
          'activityType': _activityType,
          'duration': _duration,
          'calories': _calories,
          'date': DateTime.now(),
        });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Activity logged successfully')));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Log Activity'),
        backgroundColor: Colors.orangeAccent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Icon(
                    Icons.fitness_center,
                    size: 50,
                    color: Colors.orangeAccent,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Track Your Workout",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 24),

                  DropdownButtonFormField<String>(
                    value: _activityType,
                    items:
                        ['Running', 'Walking', 'Workout']
                            .map(
                              (type) => DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              ),
                            )
                            .toList(),
                    onChanged:
                        (value) => setState(() => _activityType = value!),
                    decoration: InputDecoration(
                      labelText: 'Activity Type',
                      prefixIcon: Icon(Icons.directions_run),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Duration (minutes)',
                      prefixIcon: Icon(Icons.timer),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'Enter duration'
                                : null,
                    onSaved: (value) => _duration = int.parse(value!),
                  ),

                  SizedBox(height: 16),

                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Calories burned',
                      prefixIcon: Icon(Icons.local_fire_department),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'Enter calories'
                                : null,
                    onSaved: (value) => _calories = int.parse(value!),
                  ),

                  SizedBox(height: 24),

                  ElevatedButton.icon(
                    onPressed: _submitActivity,
                    icon: Icon(Icons.save),
                    label: Text('Save Activity'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
