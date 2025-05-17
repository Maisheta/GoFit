import 'package:flutter/material.dart';

class WorkoutProvider with ChangeNotifier {
  int _duration = 0;

  int get duration => _duration;

  void setDuration(int seconds) {
    _duration = seconds;
    notifyListeners();
  }

  void reset() {
    _duration = 0;
    notifyListeners();
  }
}
