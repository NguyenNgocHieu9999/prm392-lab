import 'package:flutter_test/flutter_test.dart';
import 'package:lab10_5_notification/main.dart';

void main() {
  testWidgets('Notification screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const NotificationApp());
    expect(find.text('Local Notification'), findsOneWidget);
  });
}
