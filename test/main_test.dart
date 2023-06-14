import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:book_recognizer_frontend/main.dart';
import 'package:book_recognizer_frontend/screens/auth.dart';

void main() {
  testWidgets('Main app widget test', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const App());

    // Verify the MaterialApp widget is present.
    final finder = find.byType(MaterialApp);
    expect(finder, findsOneWidget);

    // Verify the title of the MaterialApp widget.
    final MaterialApp app = tester.widget(finder);
    expect(app.title, 'Book Recognizer App');

    // Verify the AuthScreen widget is present as the home screen.
    expect(find.byType(AuthScreen), findsOneWidget);
  });
}
