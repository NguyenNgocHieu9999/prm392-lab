import 'package:flutter_test/flutter_test.dart';
import 'package:lab10_2_realapilogin/main.dart';

void main() {
  testWidgets('Real API login screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const RealApiLoginApp());
    expect(find.text('REST API Login'), findsOneWidget);
  });
}
