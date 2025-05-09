import 'package:flutter/material.dart';
import 'workout_complete_screen.dart';

class WorkoutInProgress extends StatefulWidget {
  final String title;
  final String imagePath;

  const WorkoutInProgress({
    required this.title,
    required this.imagePath,
    super.key,
  });

  @override
  State<WorkoutInProgress> createState() => _WorkoutInProgressState();
}

class _WorkoutInProgressState extends State<WorkoutInProgress> {
  int _seconds = 0;
  bool _isRunning = true;
  late final Stopwatch _stopwatch;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch()..start();
    _startTimer();
  }

  void _startTimer() {
    Future.doWhile(() async {
      await Future.delayed(Duration(seconds: 1));
      if (!_isRunning) return false;
      setState(() => _seconds = _stopwatch.elapsed.inSeconds);
      return _isRunning;
    });
  }

  void _finishWorkout() {
    _stopwatch.stop();
    setState(() => _isRunning = false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => WorkoutCompleteScreen(duration: _seconds),
      ),
    );
  }

  @override
  void dispose() {
    _stopwatch.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String minutes = (_seconds ~/ 60).toString().padLeft(2, '0');
    String secs = (_seconds % 60).toString().padLeft(2, '0');

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 20),
          Image.asset(widget.imagePath, height: 250),
          SizedBox(height: 30),
          Text(
            '$minutes:$secs',
            style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            'Keep going! 💪',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30),
            child: ElevatedButton.icon(
              onPressed: _finishWorkout,
              icon: Icon(Icons.check),
              label: Text('Finish Workout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
