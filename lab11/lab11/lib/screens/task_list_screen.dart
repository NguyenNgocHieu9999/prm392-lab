import 'package:flutter/material.dart';

import '../models/task.dart';
import '../repositories/task_repository.dart';
import 'task_detail_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key, required this.repository});

  final TaskRepository repository;

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _titleController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _addTask() {
    final title = _titleController.text.trim();

    if (title.isEmpty) {
      return;
    }

    widget.repository.addTask(title);
    _titleController.clear();
  }

  void _openTask(Task task) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            TaskDetailScreen(repository: widget.repository, taskId: task.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.repository,
      builder: (context, _) {
        final tasks = widget.repository.tasks;

        return Scaffold(
          appBar: AppBar(title: const Text('Taskly')),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        key: const Key('taskTitleField'),
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Task title',
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (_) => _addTask(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      key: const Key('addTaskButton'),
                      onPressed: _addTask,
                      tooltip: 'Add task',
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: tasks.isEmpty
                      ? const Center(child: Text('No tasks yet. Add one!'))
                      : ListView.separated(
                          itemCount: tasks.length,
                          separatorBuilder: (_, _) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final task = tasks[index];

                            return ListTile(
                              key: Key('taskTile_${task.id}'),
                              title: Text(task.title),
                              leading: Checkbox(
                                value: task.completed,
                                onChanged: (_) {
                                  widget.repository.updateTask(task.toggle());
                                },
                              ),
                              trailing: IconButton(
                                tooltip: 'Delete task',
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () {
                                  widget.repository.deleteTask(task.id);
                                },
                              ),
                              onTap: () => _openTask(task),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
