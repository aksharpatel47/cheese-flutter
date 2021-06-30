import 'package:flutter/material.dart';
import 'package:flutter_app/presentation/splash/splash_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: SplashScreen(),
    ));
    expect(find.text("Splash Screen"), findsOneWidget);
  });
}
