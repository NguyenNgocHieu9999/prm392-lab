import 'package:flutter/material.dart';

/// Exercise 4 - App Structure with Scaffold, AppBar, FAB & Theme
class ScaffoldThemeDemo extends StatelessWidget {
  final ThemeMode currentMode;
  final void Function(ThemeMode) onThemeModeChanged;

  const ScaffoldThemeDemo({
    super.key,
    required this.currentMode,
    required this.onThemeModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scaffold & Theme Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Screen structure example',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'Current theme: ${currentMode == ThemeMode.dark ? 'Dark' : 'Light'}',
            ),
            const SizedBox(height: 12),

            // Dark Mode toggle implemented by calling back to root app
            SwitchListTile(
              title: const Text('Enable Dark Mode'),
              value: currentMode == ThemeMode.dark,
              onChanged: (v) =>
                  onThemeModeChanged(v ? ThemeMode.dark : ThemeMode.light),
            ),

            const SizedBox(height: 12),
            const Text(
              'Floating Action Button below triggers a sample action.',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('FAB tapped'))),
        child: const Icon(Icons.add),
      ),
    );
  }
}
