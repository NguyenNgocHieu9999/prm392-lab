import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab11/repositories/task_repository.dart';
import 'package:lab11/screens/task_list_screen.dart';

void main() {
  testWidgets('adds, opens, edits, saves, and verifies updated task title', (
    tester,
  ) async {
    // Arrange
    final repository = TaskRepository();

    await tester.pumpWidget(
      MaterialApp(home: TaskListScreen(repository: repository)),
    );

    // Act
    await tester.enterText(
      find.byKey(const Key('taskTitleField')),
      'Original title',
    );
    await tester.tap(find.byKey(const Key('addTaskButton')));
    await tester.pump();

    await tester.tap(find.text('Original title'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('detailTitleField')),
      'Updated title',
    );
    await tester.tap(find.byKey(const Key('saveTaskButton')));
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Updated title'), findsOneWidget);
    expect(find.text('Original title'), findsNothing);
  });
}
