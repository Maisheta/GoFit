import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class GoalProvider with ChangeNotifier {
  int steps = 0;
  int calories = 0;
  int duration = 0;

  final Box goalBox = Hive.box('goalsBox');

  void loadGoals() {
    steps = goalBox.get('steps', defaultValue: 0);
    calories = goalBox.get('calories', defaultValue: 0);
    duration = goalBox.get('duration', defaultValue: 0);
    notifyListeners();
  }

  void updateGoals({
    required int newSteps,
    required int newCalories,
    required int newDuration,
  }) {
    steps = newSteps;
    calories = newCalories;
    duration = newDuration;

    goalBox.put('steps', steps);
    goalBox.put('calories', calories);
    goalBox.put('duration', duration);

    notifyListeners();
  }
}
