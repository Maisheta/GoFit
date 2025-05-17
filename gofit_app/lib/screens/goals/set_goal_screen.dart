import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SetGoalScreen extends StatefulWidget {
  @override
  _SetGoalScreenState createState() => _SetGoalScreenState();
}

class _SetGoalScreenState extends State<SetGoalScreen> {
  final _stepsController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _durationController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;

  late Box goalBox;

  @override
  void initState() {
    super.initState();
    _initHiveAndLoadGoals();
  }

  Future<void> _initHiveAndLoadGoals() async {
    goalBox = Hive.box('goalsBox');
    _loadGoalsFromLocal(); // load immediately from local
    await _loadGoalsFromFirebase(); // then try firebase
  }

  Future<void> _saveGoals() async {
    final steps = int.tryParse(_stepsController.text) ?? 0;
    final calories = int.tryParse(_caloriesController.text) ?? 0;
    final duration = int.tryParse(_durationController.text) ?? 0;

    try {
      // Save to Firebase
      await FirebaseFirestore.instance.collection('goals').doc(user!.uid).set({
        'steps': steps,
        'calories': calories,
        'duration': duration,
        'updatedAt': DateTime.now(),
      });

      // Save to Hive (local)
      await goalBox.putAll({
        'steps': steps,
        'calories': calories,
        'duration': duration,
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Goals updated!')));
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to save goals')));
    }
  }

  Future<void> _loadGoalsFromFirebase() async {
    try {
      final doc =
          await FirebaseFirestore.instance
              .collection('goals')
              .doc(user!.uid)
              .get();

      if (doc.exists) {
        final data = doc.data()!;
        _stepsController.text = data['steps'].toString();
        _caloriesController.text = data['calories'].toString();
        _durationController.text = data['duration'].toString();

        // Save to Hive
        await goalBox.putAll({
          'steps': data['steps'],
          'calories': data['calories'],
          'duration': data['duration'],
        });
      }
    } catch (e) {
      // Silent fallback if Firebase fails
    }
  }

  void _loadGoalsFromLocal() {
    _stepsController.text = goalBox.get('steps', defaultValue: 0);
    _caloriesController.text = goalBox.get('calories', defaultValue: 0);
    _durationController.text = goalBox.get('duration', defaultValue: 0);
  }

  Widget _buildGoalCard({
    required IconData icon,
    required String label,
    required String hint,
    required TextEditingController controller,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.orangeAccent.withOpacity(0.2),
              child: Icon(icon, color: Colors.orangeAccent),
            ),
            SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: label,
                  hintText: hint,
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      appBar: AppBar(
        title: Text('Set Your Daily Goals'),
        backgroundColor: Colors.orangeAccent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildGoalCard(
              icon: Icons.directions_walk,
              label: 'Steps Goal',
              hint: 'Enter your daily steps goal',
              controller: _stepsController,
            ),
            _buildGoalCard(
              icon: Icons.local_fire_department,
              label: 'Calories Goal',
              hint: 'Enter calories to burn',
              controller: _caloriesController,
            ),
            _buildGoalCard(
              icon: Icons.timer,
              label: 'Workout Duration (min)',
              hint: 'Enter workout duration',
              controller: _durationController,
            ),
            SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _saveGoals,
              icon: Icon(Icons.save),
              label: Text('Save Goals'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
