import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infinity_threadz/common/data/demo_data.dart';
import 'package:infinity_threadz/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Pumps the app past its splash screen onto the login page.
Future<void> pumpToLogin(WidgetTester tester) async {
  // A typical phone screen (412 x 915 logical pixels).
  tester.view.physicalSize = const Size(1236, 2745);
  tester.view.devicePixelRatio = 3.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(const MyApp());
  await tester.pump(const Duration(seconds: 5));
  await tester.pump(const Duration(seconds: 2));
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('shows the login page with a demo-mode hint', (tester) async {
    await pumpToLogin(tester);

    expect(find.text('Sign In'), findsOneWidget);
    expect(
      find.text('Demo mode: sign in with any username and password.'),
      findsOneWidget,
    );
  });

  testWidgets('requires a username and password', (tester) async {
    await pumpToLogin(tester);

    await tester.tap(find.text('Sign In'));
    await tester.pump();

    expect(find.text('Please enter a username'), findsOneWidget);
    expect(find.text('Please enter a password'), findsOneWidget);
  });

  testWidgets('signing in opens the catalogue', (tester) async {
    await pumpToLogin(tester);

    await tester.enterText(find.byType(TextFormField).at(0), 'jenna');
    await tester.enterText(find.byType(TextFormField).at(1), 'secret');
    await tester.tap(find.text('Sign In'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Catalogue'), findsWidgets);
    expect(find.text(DemoData.products.first.name), findsOneWidget);

    // Let the sign-in snackbar finish before the test ends.
    await tester.pump(const Duration(seconds: 5));
  });
}
