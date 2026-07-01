import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/task_provider.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({required this.task, super.key});

  final Task task;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: task.isDone,
        onChanged: (_) => context.read<TaskProvider>().toggleTask(task.id),
      ),
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.isDone ? TextDecoration.lineThrough : null,
        ),
      ),
      trailing: IconButton(
        tooltip: 'Delete task',
        icon: const Icon(Icons.delete_outline),
        onPressed: () => context.read<TaskProvider>().deleteTask(task.id),
      ),
      onTap: () => context.read<TaskProvider>().toggleTask(task.id),
    );
  }
}
