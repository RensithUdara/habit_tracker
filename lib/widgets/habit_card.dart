import 'package:flutter/material.dart';
import '../models/habit.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;
  final VoidCallback onTap;

  HabitCard({required this.habit, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(2, 2))],
        gradient: LinearGradient(
          colors: [habit.color.withOpacity(0.8), habit.color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16.0),
        title: Text(
          habit.name,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        subtitle: Text(
          habit.trigger,
          style: TextStyle(fontSize: 16, color: Colors.white70),
        ),
        trailing: IconButton(
          icon: Icon(Icons.add_circle_outline, color: Colors.white, size: 32),
          onPressed: onTap,
        ),
      ),
    );
  }
}
