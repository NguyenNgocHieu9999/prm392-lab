import 'package:flutter_test/flutter_test.dart';
import 'package:lab10_full/main.dart';

void main() {
  testWidgets('Integrated app splash screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const Lab10FullApp(isFirebaseConfigured: false));
    expect(find.text('Integrated App'), findsOneWidget);
  });
}
