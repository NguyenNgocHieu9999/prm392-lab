import 'package:flutter_test/flutter_test.dart';
import 'package:lab11/models/task.dart';
import 'package:lab11/repositories/task_repository.dart';

void main() {
  group('TaskRepository', () {
    test('addTask adds a new task', () {
      // Arrange
      final repository = TaskRepository();

      // Act
      final task = repository.addTask('Read DevTools docs');

      // Assert
      expect(repository.tasks, hasLength(1));
      expect(repository.tasks.first, same(task));
      expect(repository.tasks.first.title, 'Read DevTools docs');
    });

    test('deleteTask removes an existing task', () {
      // Arrange
      final task = Task(id: '1', title: 'Temporary task');
      final repository = TaskRepository([task]);

      // Act
      repository.deleteTask(task.id);

      // Assert
      expect(repository.tasks, isEmpty);
    });

    test('updateTask replaces an existing task', () {
      // Arrange
      final task = Task(id: '1', title: 'Original title');
      final repository = TaskRepository([task]);
      final updatedTask = task.copyWith(title: 'Updated title');

      // Act
      repository.updateTask(updatedTask);

      // Assert
      expect(repository.tasks, hasLength(1));
      expect(repository.tasks.first.title, 'Updated title');
    });
  });
}
