import 'package:flutter_test/flutter_test.dart';
import 'package:lab10_3_autologin_logout/main.dart';

void main() {
  testWidgets('Auto login splash screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const AutoLoginApp());
    expect(find.text('Session Hub'), findsOneWidget);
  });
}
