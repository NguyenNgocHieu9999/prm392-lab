import 'package:flutter_test/flutter_test.dart';
import 'package:lab10_1_mocklogin/main.dart';

void main() {
  testWidgets('Mock login screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MockLoginApp());
    expect(find.text('Mock Login'), findsOneWidget);
  });
}
