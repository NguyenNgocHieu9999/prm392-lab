import 'package:flutter/material.dart';

import 'demos/core_widgets_demo.dart';
import 'demos/input_controls_demo.dart';
import 'demos/layout_basics_demo.dart';
import 'demos/scaffold_theme_demo.dart';
import 'demos/fix_ui_errors_demo.dart';

void main() {
  runApp(const MyApp());
}

/// Root app that manages global theme mode for the demos.
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _setThemeMode(ThemeMode mode) {
    setState(() => _themeMode = mode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter UI Lab Demos',
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      home: DemoListPage(
        onThemeModeChanged: _setThemeMode,
        themeMode: _themeMode,
      ),
    );
  }
}

/// Simple launcher page listing all demo screens.
class DemoListPage extends StatelessWidget {
  final void Function(ThemeMode) onThemeModeChanged;
  final ThemeMode themeMode;

  const DemoListPage({
    super.key,
    required this.onThemeModeChanged,
    required this.themeMode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter UI Lab - Demos')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Choose a demo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.widgets),
            title: const Text('Exercise 1 — Core Widgets'),
            subtitle: const Text('Text, Image, Icon, Card, ListTile'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CoreWidgetsDemo()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.input),
            title: const Text('Exercise 2 — Input Controls'),
            subtitle: const Text('Slider, Switch, RadioListTile, DatePicker'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const InputControlsDemo()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.view_list),
            title: const Text('Exercise 3 — Layout Basics'),
            subtitle: const Text('Column, Row, Padding, ListView'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LayoutBasicsDemo()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.phone_iphone),
            title: const Text('Exercise 4 — Scaffold & Theme'),
            subtitle: const Text('AppBar, FAB, Theme + Dark Mode'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ScaffoldThemeDemo(
                  currentMode: themeMode,
                  onThemeModeChanged: onThemeModeChanged,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.bug_report),
            title: const Text('Exercise 5 — Fix UI Errors'),
            subtitle: const Text('Common fixes and patterns'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FixUiErrorsDemo()),
            ),
          ),
        ],
      ),
    );
  }
}
