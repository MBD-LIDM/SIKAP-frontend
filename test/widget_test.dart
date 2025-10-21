import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sikap_frontend/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MainApp());

    // Verify that the app builds without errors
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('App has correct theme', (WidgetTester tester) async {
    await tester.pumpWidget(const MainApp());

    final MaterialApp app = tester.widget(find.byType(MaterialApp));
    
    // Verify app title
    expect(app.title, 'SIKAP');
    
    // Verify debug banner is off
    expect(app.debugShowCheckedModeBanner, false);
  });
}
