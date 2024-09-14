import 'dart:ui';

class Habit {
  String name;
  String trigger;
  String frequency; // 'Daily', 'Weekly', 'Monthly'
  List<DateTime> progress;
  Color color;

  Habit({
    required this.name,
    required this.trigger,
    required this.frequency,
    required this.progress,
    required this.color,
  });
}
