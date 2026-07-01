import 'package:flutter_test/flutter_test.dart';
import 'package:lab11/models/task.dart';

void main() {
  group('Task model', () {
    test('uses false as the default completed value', () {
      // Arrange
      final task = Task(title: 'Study Flutter tests');

      // Act
      final completed = task.completed;

      // Assert
      expect(completed, isFalse);
    });

    test('toggle switches completed from false to true', () {
      // Arrange
      final task = Task(title: 'Write unit test');

      // Act
      final toggledTask = task.toggle();

      // Assert
      expect(toggledTask.completed, isTrue);
    });

    test('toggle switches completed from true to false', () {
      // Arrange
      final task = Task(title: 'Review test', completed: true);

      // Act
      final toggledTask = task.toggle();

      // Assert
      expect(toggledTask.completed, isFalse);
    });
  });
}
