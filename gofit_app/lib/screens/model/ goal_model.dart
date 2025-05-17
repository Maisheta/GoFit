class GoalModel {
  final int steps;
  final int calories;
  final int duration;

  GoalModel({
    required this.steps,
    required this.calories,
    required this.duration,
  });

  factory GoalModel.fromMap(Map<String, dynamic> map) {
    return GoalModel(
      steps: map['steps'] ?? 0,
      calories: map['calories'] ?? 0,
      duration: map['duration'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'steps': steps,
      'calories': calories,
      'duration': duration,
      'updatedAt': DateTime.now(),
    };
  }
}
