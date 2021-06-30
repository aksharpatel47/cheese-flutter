import 'package:flutter/material.dart';
import 'package:flutter_app/presentation/login/login_screen.dart';
import 'package:flutter_app/presentation/people/people_screen.dart';
import 'package:flutter_app/presentation/people/person_screen.dart';
import 'package:flutter_app/presentation/people/report_screen.dart';
import 'package:flutter_app/presentation/people/search_screen.dart';
import 'package:flutter_app/presentation/settings/settings_screen.dart';
import 'package:flutter_app/presentation/splash/splash_screen.dart';
import 'package:flutter_app/presentation/task/task_screen.dart';
import 'package:vrouter/vrouter.dart';

import 'configure.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: VRouter(
        routes: [
          VWidget(
            path: SplashPage.path,
            widget: SplashPage(),
          ),
          VWidget(
            path: LoginScreen.path,
            widget: LoginScreen(),
          ),
          VWidget(
            path: PeopleScreen.path,
            widget: PeopleScreen(),
            stackedRoutes: [
              VWidget(
                path: PersonScreen.id,
                widget: PersonScreen(),
              ),
              VWidget(
                path: ReportScreen.id,
                widget: ReportScreen(),
              ),
              VWidget(
                path: SearchScreen.id,
                widget: SearchScreen(),
              ),
            ],
          ),
          VWidget(
            path: SettingsScreen.path,
            widget: SettingsScreen(),
          ),
          VWidget(
            path: TaskScreen.path,
            widget: TaskScreen(),
          ),
        ],
      ),
    );
  }
}
