import 'package:flutter/material.dart';

/// Exercise 5 - Debug & Fix Common UI Errors
class FixUiErrorsDemo extends StatefulWidget {
  const FixUiErrorsDemo({super.key});

  @override
  State<FixUiErrorsDemo> createState() => _FixUiErrorsDemoState();
}

class _FixUiErrorsDemoState extends State<FixUiErrorsDemo> {
  @override
  Widget build(BuildContext context) {
    // Demonstrates correct fixes for common issues:
    // - ListView inside Column -> wrap with Expanded
    // - Overflow on small screens -> use SingleChildScrollView
    // - Proper setState usage is shown in other demos

    final items = List<String>.generate(30, (i) => 'Item ${i + 1}');

    return Scaffold(
      appBar: AppBar(title: const Text('Fix UI Errors')),
      body: Column(
        children: [
          // This top section might overflow on small devices; wrap in Flexible/Expanded when needed
          Padding(
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: const [
                  Text('Long horizontal content example - scroll to view'),
                ],
              ),
            ),
          ),

          // Correct use of ListView inside a Column: place it inside Expanded
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) => ListTile(title: Text(items[index])),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Safe DatePicker usage: call showDatePicker from a widget's context
          final now = DateTime.now();
          final picked = await showDatePicker(
            context: context,
            initialDate: now,
            firstDate: DateTime(now.year - 2),
            lastDate: DateTime(now.year + 2),
          );
          if (!mounted) return;
          if (picked != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Picked: ${picked.toLocal().toString().split(' ').first}'),
              ),
            );
          }
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
