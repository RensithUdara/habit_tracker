import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../widgets/habit_card.dart';
import 'add_habit_screen.dart';
import 'statistics_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Habit> habits = [];
  int _currentIndex = 0; // Current index for bottom navigation bar

  void _navigateToAddHabit() async {
    final Habit? newHabit = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddHabitScreen()),
    );

    if (newHabit != null) {
      setState(() {
        habits.add(newHabit);
      });
    }
  }

  void _updateProgress(int index) {
    setState(() {
      habits[index].progress.add(DateTime.now());
    });
    _showMotivationalQuote();
  }

  void _showMotivationalQuote() {
    final quotes = [
      "Keep it up!",
      "You're doing great!",
      "Consistency is key!",
      "One step at a time!",
    ];
    final quote = quotes[(quotes.length * (DateTime.now().millisecondsSinceEpoch % 1000) / 1000).floor()];

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(quote)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Extend the body behind the bottom navigation bar
      appBar: AppBar(
        title: const Text('Current Habits'),
        elevation: 0,
        backgroundColor: Colors.lightBlue[200], // Lighter AppBar color
        foregroundColor: Colors.black, // Text color for AppBar
        actions: [
          IconButton(
            icon: const Icon(Icons.insert_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StatisticsScreen(habits: habits)),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[50]!, Colors.blue[100]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            if (habits.isNotEmpty)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('You’re doing great! 😊', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            Expanded(
              child: habits.isEmpty ? _buildEmptyState() : _buildHabitList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddHabit,
        backgroundColor: Colors.lightBlueAccent, // Lighter FAB color
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked, // Position FAB centrally
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.lightBlue[100]!, Colors.lightBlue[200]!],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -1),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            if (index == 1) {
              _navigateToAddHabit();
            }
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent, // Make background transparent to show gradient
          selectedItemColor: Colors.blueAccent, // Set a soft blue color for selected items
          unselectedItemColor: Colors.grey, // Set a grey color for unselected items
          selectedFontSize: 14,
          unselectedFontSize: 14,
          elevation: 0, // Remove default shadow
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Today',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_outlined),
              activeIcon: Icon(Icons.add_circle),
              label: 'Create New',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_outlined),
              activeIcon: Icon(Icons.list_alt),
              label: 'All Habits',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text(
        'No habits yet. Add one!',
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
    );
  }

  Widget _buildHabitList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: habits.length,
      itemBuilder: (context, index) {
        return HabitCard(
          habit: habits[index],
          onTap: () => _updateProgress(index),
        );
      },
    );
  }
}
