import 'package:flutter/material.dart';

import 'repositories/task_repository.dart';
import 'screens/task_list_screen.dart';

void main() {
  runApp(TasklyApp());
}

class TasklyApp extends StatelessWidget {
  TasklyApp({super.key, TaskRepository? repository})
    : repository = repository ?? TaskRepository();

  final TaskRepository repository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taskly',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: TaskListScreen(repository: repository),
    );
  }
}
