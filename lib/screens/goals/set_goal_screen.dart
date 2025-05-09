import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SetGoalScreen extends StatefulWidget {
  @override
  _SetGoalScreenState createState() => _SetGoalScreenState();
}

class _SetGoalScreenState extends State<SetGoalScreen> {
  final _stepsController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _durationController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;

  Future<void> _saveGoals() async {
    try {
      await FirebaseFirestore.instance.collection('goals').doc(user!.uid).set({
        'steps': int.tryParse(_stepsController.text) ?? 0,
        'calories': int.tryParse(_caloriesController.text) ?? 0,
        'duration': int.tryParse(_durationController.text) ?? 0,
        'updatedAt': DateTime.now(),
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Goals updated!')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to save goals')));
    }
  }

  Future<void> _loadGoals() async {
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
    }
  }

  @override
  void initState() {
    super.initState();
    _loadGoals();
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
