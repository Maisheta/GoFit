import 'package:flutter/material.dart';

class WorkoutState with ChangeNotifier {
  int _duration = 0;

  int get duration => _duration;

  // تحديث مدة التمرين
  void setDuration(int newDuration) {
    _duration = newDuration;
    notifyListeners(); // إخطار المستمعين بأن البيانات قد تغيرت
  }

  // حفظ التمرين
  Future<void> saveWorkoutLocally() async {
    // يمكنك إضافة هنا الكود لحفظ النشاط في Hive أو Firebase
    // مثلًا:
    // final workoutBox = await Hive.openBox('completedWorkouts');
    // workoutBox.add({'duration': _duration, 'date': DateTime.now().toIso8601String()});
  }
}
