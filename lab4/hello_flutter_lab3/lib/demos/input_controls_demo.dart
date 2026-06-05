import 'package:flutter/material.dart';

/// Exercise 2 - Input Widgets: Slider, Switch, RadioListTile, DatePicker
class InputControlsDemo extends StatefulWidget {
  const InputControlsDemo({super.key});

  @override
  State<InputControlsDemo> createState() => _InputControlsDemoState();
}

class _InputControlsDemoState extends State<InputControlsDemo> {
  double _sliderValue = 50;
  bool _switchValue = false;
  int _radioValue = 0;
  DateTime? _selectedDate;

  // Show the platform date picker and store the selected date
  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Input Controls Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Adjust the controls below:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Slider
            Text('Slider value: ${_sliderValue.toStringAsFixed(0)}'),
            Slider(
              value: _sliderValue,
              min: 0,
              max: 100,
              divisions: 100,
              label: _sliderValue.toStringAsFixed(0),
              onChanged: (v) => setState(() => _sliderValue = v),
            ),

            // Switch
            SwitchListTile(
              title: const Text('Enable option'),
              value: _switchValue,
              onChanged: (v) => setState(() => _switchValue = v),
            ),

            // RadioListTile group
            const Text('Select an option:'),
            RadioListTile<int>(
              title: const Text('Option A'),
              value: 0,
              groupValue: _radioValue,
              onChanged: (v) => setState(() => _radioValue = v ?? 0),
            ),
            RadioListTile<int>(
              title: const Text('Option B'),
              value: 1,
              groupValue: _radioValue,
              onChanged: (v) => setState(() => _radioValue = v ?? 0),
            ),

            const SizedBox(height: 12),
            // DatePicker button
            ElevatedButton.icon(
              icon: const Icon(Icons.calendar_today),
              label: const Text('Pick a date'),
              onPressed: _pickDate,
            ),

            const SizedBox(height: 12),
            // Display selected values
            Text(
              'Selected date: ${_selectedDate != null ? _selectedDate!.toLocal().toString().split(' ').first : 'None'}',
            ),
            Text('Switch is ${_switchValue ? 'ON' : 'OFF'}'),
            Text('Radio selection: ${_radioValue == 0 ? 'A' : 'B'}'),
          ],
        ),
      ),
    );
  }
}
