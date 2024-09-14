import 'package:flutter/material.dart';
import '../models/habit.dart';

class StatisticsScreen extends StatelessWidget {
  final List<Habit> habits;

  const StatisticsScreen({super.key, required this.habits});

  @override
  Widget build(BuildContext context) {
    int completedHabits = habits.where((habit) => habit.progress.isNotEmpty).length;
    double completionRate = habits.isNotEmpty ? completedHabits / habits.length : 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        backgroundColor: Colors.lightBlue[200], // Lighter AppBar color
        elevation: 0,
        foregroundColor: Colors.black, // Text color for AppBar
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[50]!, Colors.blue[100]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildCircularCompletionIndicator(completionRate),
              const SizedBox(height: 40),
              _buildStatisticsSummary(),
              const SizedBox(height: 20),
              _buildCompletionMessage(completionRate),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircularCompletionIndicator(double completionRate) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 200,
          height: 200,
          child: TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: completionRate),
            duration: const Duration(seconds: 1),
            builder: (context, value, child) => CircularProgressIndicator(
              value: value,
              strokeWidth: 12,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blueAccent),
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${(completionRate * 100).toStringAsFixed(0)}%',
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            const SizedBox(height: 4),
            const Text(
              'Completion Rate',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatisticsSummary() {
    return Column(
      children: [
        _buildStatisticsRow(
          icon: Icons.assignment_turned_in,
          title: 'Total Habits',
          value: '${habits.length}',
          color: Colors.teal,
        ),
        _buildStatisticsRow(
          icon: Icons.done_all,
          title: 'Habits Completed',
          value: '${habits.where((habit) => habit.progress.isNotEmpty).length}',
          color: Colors.green,
        ),
        _buildStatisticsRow(
          icon: Icons.stars,
          title: 'Streaks',
          value: '${_calculateStreak()} days',
          color: Colors.orange,
        ),
      ],
    );
  }

  Widget _buildStatisticsRow({required IconData icon, required String title, required String value, required Color color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.1),
            ),
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 18, color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionMessage(double completionRate) {
    String message;
    Color messageColor;

    if (completionRate == 1) {
      message = 'Awesome! You have completed all your habits!';
      messageColor = Colors.green;
    } else if (completionRate >= 0.5) {
      message = 'Great job! You’re more than halfway there!';
      messageColor = Colors.blue;
    } else {
      message = 'Keep going! Every little bit counts!';
      messageColor = Colors.orange;
    }

    return Text(
      message,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 16, color: messageColor, fontWeight: FontWeight.bold),
    );
  }

  int _calculateStreak() {
    int longestStreak = 0;
    int currentStreak = 0;

    // Sort all progress dates in ascending order
    List<DateTime> progressDates = habits
        .expand((habit) => habit.progress)
        .toList()
      ..sort((a, b) => a.compareTo(b));

    if (progressDates.isEmpty) {
      return 0;
    }

    for (int i = 0; i < progressDates.length; i++) {
      if (i == 0) {
        // First day of streak
        currentStreak = 1;
      } else {
        // Calculate the difference between current and previous day
        int difference = progressDates[i].difference(progressDates[i - 1]).inDays;

        if (difference == 1) {
          // If consecutive day, increment current streak
          currentStreak++;
        } else if (difference > 1) {
          // If not consecutive, reset the current streak
          longestStreak = currentStreak > longestStreak ? currentStreak : longestStreak;
          currentStreak = 1;
        }
      }
    }

    // Check the last streak
    longestStreak = currentStreak > longestStreak ? currentStreak : longestStreak;

    return longestStreak;
  }
}
