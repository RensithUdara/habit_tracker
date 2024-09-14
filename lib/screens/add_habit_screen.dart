import 'package:flutter/material.dart';
import '../models/habit.dart';

class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({super.key});

  @override
  _AddHabitScreenState createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _trigger = '';
  String _frequency = 'Daily';
  Color _selectedColor = Colors.blueAccent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Habit'),
        backgroundColor: Colors.blueAccent, // Set AppBar color
        elevation: 0,
        foregroundColor: Colors.white,
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
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                _buildTextField(
                  label: 'After I...',
                  onSaved: (value) => _trigger = value!,
                  validator: (value) => value == null || value.isEmpty ? 'Please enter a trigger' : null,
                ),
                const SizedBox(height: 16.0),
                _buildTextField(
                  label: 'I will...',
                  onSaved: (value) => _name = value!,
                  validator: (value) => value == null || value.isEmpty ? 'Please enter a habit' : null,
                ),
                const SizedBox(height: 16.0),
                _buildFrequencyDropdown(),
                const SizedBox(height: 16.0),
                _buildColorPicker(),
                const SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedColor, // Change button color to selected color
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Create new habit', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required String label, required FormFieldSetter<String> onSaved, required FormFieldValidator<String> validator}) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      validator: validator,
      onSaved: onSaved,
    );
  }

  Widget _buildFrequencyDropdown() {
    return DropdownButtonFormField<String>(
      value: _frequency,
      items: ['Daily', 'Weekly', 'Monthly']
          .map((freq) => DropdownMenuItem(value: freq, child: Text(freq)))
          .toList(),
      onChanged: (value) => setState(() => _frequency = value!),
      decoration: InputDecoration(
        labelText: 'Frequency',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildColorPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Select label color:', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _colorCircle(Colors.pinkAccent),
            _colorCircle(Colors.blueAccent),
            _colorCircle(Colors.greenAccent),
          ],
        ),
      ],
    );
  }

  Widget _colorCircle(Color color) {
    return GestureDetector(
      onTap: () => setState(() => _selectedColor = color),
      child: CircleAvatar(
        backgroundColor: color,
        radius: 20,
        child: _selectedColor == color
            ? const Icon(Icons.check, color: Colors.white)
            : null,
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Habit newHabit = Habit(
        name: _name,
        trigger: _trigger,
        frequency: _frequency,
        progress: [],
        color: _selectedColor,
      );
      Navigator.pop(context, newHabit);
    }
  }
}
