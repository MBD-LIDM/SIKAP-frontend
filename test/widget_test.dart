import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sikap/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MainApp());

    // Verify that the app builds without errors
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('App has correct theme', (WidgetTester tester) async {
    await tester.pumpWidget(const MainApp());

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    
    // Verify app title
    expect(materialApp.title, 'SIKAP');
    
    // Verify debug banner is off
    expect(materialApp.debugShowCheckedModeBanner, false);
  });
}
