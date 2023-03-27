import 'package:flutter_app/presentation/login/login_screen.dart';
import 'package:flutter_app/presentation/people/people_screen.dart';
import 'package:flutter_app/presentation/people/person_screen.dart';
import 'package:flutter_app/presentation/people/report_screen.dart';
import 'package:flutter_app/presentation/people/search_screen.dart';
import 'package:flutter_app/presentation/settings/settings_screen.dart';
import 'package:flutter_app/presentation/splash/splash_screen.dart';
import 'package:flutter_app/presentation/task/task_screen.dart';
import 'package:go_router/go_router.dart';

var router = GoRouter(
  // debugLogDiagnostics: true,
  routes: <GoRoute>[
    GoRoute(
      path: SplashPage.path,
      builder: (context, state) => SplashPage(),
    ),
    GoRoute(
      path: LoginScreen.path,
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: PeopleScreen.path,
      builder: (context, state) => PeopleScreen(),
      routes: <GoRoute>[
        GoRoute(
          path: ReportScreen.id,
          builder: (context, state) => ReportScreen(),
        ),
        GoRoute(
          path: SearchScreen.id,
          builder: (context, state) => SearchScreen(),
        ),
        GoRoute(
          path: PersonScreen.id,
          builder: (context, state) => PersonScreen(),
        ),
      ],
    ),
    GoRoute(
      path: TaskScreen.path,
      builder: (context, state) => TaskScreen(),
    ),
    GoRoute(
      path: SettingsScreen.path,
      builder: (context, state) => SettingsScreen(),
    ),
  ],
);
