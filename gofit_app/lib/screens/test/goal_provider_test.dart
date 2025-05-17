import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';

import '../provider/goal_provider.dart';

void main() {
  setUp(() async {
    await setUpTestHive();
    await Hive.openBox('goalsBox');
  });

  tearDown(() async {
    await tearDownTestHive();
  });

  test('GoalProvider saves and loads values', () {
    final provider = GoalProvider();
    provider.updateGoals(newSteps: 5000, newCalories: 300, newDuration: 45);

    expect(provider.steps, 5000);
    expect(provider.calories, 300);
    expect(provider.duration, 45);

    provider.loadGoals();

    expect(provider.steps, 5000);
    expect(provider.calories, 300);
    expect(provider.duration, 45);
  });
}
