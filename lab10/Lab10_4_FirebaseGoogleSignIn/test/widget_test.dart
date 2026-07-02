import 'package:flutter_test/flutter_test.dart';
import 'package:lab10_4_firebasegooglesignin/main.dart';

void main() {
  testWidgets('Firebase sign-in screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const FirebaseGoogleSignInApp(isFirebaseConfigured: false));
    expect(find.text('Firebase Auth'), findsOneWidget);
  });
}
