import 'package:flutter/foundation.dart';

import '../models/task.dart';

class TaskRepository extends ChangeNotifier {
  TaskRepository([List<Task> initialTasks = const []])
    : _tasks = List<Task>.from(initialTasks);

  final List<Task> _tasks;

  List<Task> get tasks => List.unmodifiable(_tasks);

  Task addTask(String title) {
    final trimmedTitle = title.trim();

    if (trimmedTitle.isEmpty) {
      throw ArgumentError.value(title, 'title', 'Task title cannot be empty');
    }

    final task = Task(title: trimmedTitle);
    _tasks.add(task);
    notifyListeners();
    return task;
  }

  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }

  void updateTask(Task updatedTask) {
    final index = _tasks.indexWhere((task) => task.id == updatedTask.id);

    if (index == -1) {
      throw StateError('Task not found: ${updatedTask.id}');
    }

    _tasks[index] = updatedTask;
    notifyListeners();
  }
}
