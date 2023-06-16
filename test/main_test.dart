import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:book_recognizer_frontend/main.dart' as app;
import 'package:book_recognizer_frontend/screens/auth.dart';

void main() {
  group('App Integration Tests', () {
    testWidgets('AuthScreen is displayed as the home screen',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      expect(find.byType(AuthScreen), findsOneWidget);
    });

    testWidgets('App theme is applied correctly', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final materialAppFinder = find.byType(MaterialApp);
      final MaterialApp materialApp = tester.widget(materialAppFinder);

      expect(materialApp.theme?.brightness, Brightness.light);
      // Use the correct primary color obtained from the console.
      expect(materialApp.theme?.colorScheme.primary, const Color(0xff006a61));
    });
  });
}
