import 'package:flutter/material.dart';
import 'package:flutter_app/configure.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group("Flutter App", () {
    setUpAll(() async {
      await configureDependencies();
    });

    testWidgets('check if login button exists', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();
      final usernameTextField = find.byKey(Key('username'));
      final passwordTextField = find.byKey(Key('password'));
      final loginButton = find.byType(ElevatedButton);
      expect(loginButton, findsOneWidget);
      expect(usernameTextField, findsOneWidget);
      expect(passwordTextField, findsOneWidget);
      await tester.enterText(usernameTextField, 'akshar');
      await tester.enterText(passwordTextField, 'patel');
      await tester.tap(loginButton);
      await tester.pumpAndSettle();
      final peopleTile = find.byType(ListTile);
      expect(peopleTile, findsOneWidget);
      await tester.tap(peopleTile);
      await tester.pumpAndSettle();
      final tab1 = find.byKey(ValueKey("tab1"));
      final tab2 = find.byKey(ValueKey("tab2"));
      expect(tab1, findsOneWidget);
      expect(tab2, findsOneWidget);
      await tester.tap(tab2);
      await tester.pumpAndSettle();
      await tester.tap(tab1);
      await tester.pumpAndSettle();
      final backButton = find.byTooltip("Back");
      expect(backButton, findsOneWidget);
      await tester.tap(backButton);
      await tester.pumpAndSettle();
      final drawerButton = find.byTooltip("Open navigation menu");
      expect(drawerButton, findsOneWidget);
      await tester.tap(drawerButton);
      await tester.pumpAndSettle();
      final taskNavButton = find.byKey(ValueKey("TaskScreen"));
      expect(taskNavButton, findsOneWidget);
      await tester.tap(taskNavButton);
      await tester.pumpAndSettle();
      final taskDrawerButton = find.byTooltip("Open navigation menu");
      await tester.tap(taskDrawerButton);
      await tester.pumpAndSettle();
      final peopleNavButton = find.byKey(ValueKey("PeopleScreen"));
      await tester.tap(peopleNavButton);
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip("Open navigation menu"));
      await tester.pumpAndSettle();
      final logOutButton = find.byKey(Key('logOut'));
      expect(logOutButton, findsOneWidget);
      await tester.tap(logOutButton);
      await tester.pumpAndSettle();
      expect(find.byType(ElevatedButton), findsOneWidget);
    });
  });
}
