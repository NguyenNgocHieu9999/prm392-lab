import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab11/repositories/task_repository.dart';
import 'package:lab11/screens/task_list_screen.dart';

void main() {
  Future<void> pumpTaskList(
    WidgetTester tester, {
    TaskRepository? repository,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: TaskListScreen(repository: repository ?? TaskRepository()),
      ),
    );
  }

  testWidgets('shows empty state when there are no tasks', (tester) async {
    // Arrange
    final repository = TaskRepository();

    // Act
    await pumpTaskList(tester, repository: repository);

    // Assert
    expect(find.text('No tasks yet. Add one!'), findsOneWidget);
  });

  testWidgets('adds a task and updates the UI', (tester) async {
    // Arrange
    await pumpTaskList(tester);

    // Act
    await tester.enterText(find.byKey(const Key('taskTitleField')), 'Buy milk');
    await tester.tap(find.byKey(const Key('addTaskButton')));
    await tester.pump();

    // Assert
    expect(find.text('Buy milk'), findsOneWidget);
    expect(find.text('No tasks yet. Add one!'), findsNothing);
  });

  testWidgets('adds multiple tasks and shows both', (tester) async {
    // Arrange
    await pumpTaskList(tester);

    // Act
    await tester.enterText(find.byKey(const Key('taskTitleField')), 'Task one');
    await tester.tap(find.byKey(const Key('addTaskButton')));
    await tester.pump();

    await tester.enterText(find.byKey(const Key('taskTitleField')), 'Task two');
    await tester.tap(find.byKey(const Key('addTaskButton')));
    await tester.pump();

    // Assert
    expect(find.text('Task one'), findsOneWidget);
    expect(find.text('Task two'), findsOneWidget);
  });
}
