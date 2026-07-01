import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab11/models/task.dart';
import 'package:lab11/repositories/task_repository.dart';
import 'package:lab11/screens/task_list_screen.dart';

void main() {
  testWidgets('navigates from task list to task detail', (tester) async {
    // Arrange
    final task = Task(id: 'task-1', title: 'Seeded task');
    final repository = TaskRepository([task]);

    await tester.pumpWidget(
      MaterialApp(home: TaskListScreen(repository: repository)),
    );

    // Act
    await tester.tap(find.text('Seeded task'));
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Task Detail'), findsOneWidget);
    expect(find.byKey(const Key('detailTitleField')), findsOneWidget);
  });
}
