import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import ' goal_model.dart';

class GoalViewModel extends ChangeNotifier {
  final stepsController = TextEditingController();
  final caloriesController = TextEditingController();
  final durationController = TextEditingController();

  final user = FirebaseAuth.instance.currentUser;

  Future<void> loadGoals() async {
    final doc =
        await FirebaseFirestore.instance
            .collection('goals')
            .doc(user!.uid)
            .get();

    if (doc.exists) {
      final goal = GoalModel.fromMap(doc.data()!);
      stepsController.text = goal.steps.toString();
      caloriesController.text = goal.calories.toString();
      durationController.text = goal.duration.toString();
    }
  }

  Future<void> saveGoals(BuildContext context) async {
    try {
      final goal = GoalModel(
        steps: int.tryParse(stepsController.text) ?? 0,
        calories: int.tryParse(caloriesController.text) ?? 0,
        duration: int.tryParse(durationController.text) ?? 0,
      );

      await FirebaseFirestore.instance
          .collection('goals')
          .doc(user!.uid)
          .set(goal.toMap());

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

  @override
  void dispose() {
    stepsController.dispose();
    caloriesController.dispose();
    durationController.dispose();
    super.dispose();
  }
}
