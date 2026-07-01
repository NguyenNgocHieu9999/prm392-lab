import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:lab12/main.dart';
import 'package:lab12/providers/task_provider.dart';

void main() {
  testWidgets('Taskly adds, toggles, and deletes a task', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => TaskProvider.seeded(),
        child: const TasklyApp(),
      ),
    );

    await tester.enterText(find.byType(TextField), 'Submit lab report');
    await tester.tap(find.text('Add'));
    await tester.pump();

    expect(find.text('Submit lab report'), findsOneWidget);

    await tester.tap(find.byType(Checkbox).last);
    await tester.pump();

    expect(find.text('1 of 4 tasks complete'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.delete_outline).last);
    await tester.pump();

    expect(find.text('Submit lab report'), findsNothing);
  });
}
