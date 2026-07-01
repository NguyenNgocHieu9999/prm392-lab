import 'package:flutter/foundation.dart';

import '../models/task.dart';

class TaskProvider extends ChangeNotifier {
  TaskProvider([List<Task>? tasks]) : _tasks = List.of(tasks ?? const []);

  factory TaskProvider.seeded() {
    return TaskProvider(const [
      Task(id: 'task-1', title: 'Review rebuild behavior'),
      Task(id: 'task-2', title: 'Optimize Taskly asset loading'),
      Task(id: 'task-3', title: 'Prepare release checklist'),
    ]);
  }

  final List<Task> _tasks;

  List<Task> get tasks => List.unmodifiable(_tasks);

  int get completedCount => _tasks.where((task) => task.isDone).length;

  void addTask(String title) {
    final trimmedTitle = title.trim();
    if (trimmedTitle.isEmpty) {
      return;
    }

    _tasks.add(
      Task(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: trimmedTitle,
      ),
    );
    notifyListeners();
  }

  void toggleTask(String id) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index == -1) {
      return;
    }

    final task = _tasks[index];
    _tasks[index] = task.copyWith(isDone: !task.isDone);
    notifyListeners();
  }

  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }
}
