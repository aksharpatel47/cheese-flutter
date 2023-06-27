import 'package:flutter/material.dart';
import 'package:flutter_app/presentation/common_widgets/mys_webpage.dart';
import 'package:flutter_app/presentation/home/home_screen.dart';
import 'package:flutter_app/presentation/login/login_screen.dart';
import 'package:flutter_app/presentation/people/people_screen.dart';
import 'package:flutter_app/presentation/people/person_screen.dart';
import 'package:flutter_app/presentation/people/report_screen.dart';
import 'package:flutter_app/presentation/people/search_screen.dart';
import 'package:flutter_app/presentation/settings/settings_screen.dart';
import 'package:flutter_app/presentation/splash/splash_screen.dart';
import 'package:flutter_app/presentation/task/task_screen.dart';
import 'package:flutter_app/presentation/weather/weather_screen.dart';
import 'package:go_router/go_router.dart';

final navigatorKey = GlobalKey<NavigatorState>();

var router = GoRouter(
  // debugLogDiagnostics: true,
  navigatorKey: navigatorKey,
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
      path: HomeScreen.path,
      builder: (context, state) => HomeScreen(),
      // pageBuilder: (context, state) => CustomTransitionPage<void>(
      //   key: state.pageKey,
      //   child: const HomeScreen(),
      //   transitionsBuilder: (context, animation, secondaryAnimation, child) {
      //     return FadeTransition(opacity: animation, child: ScaleTransition(scale: animation, child: child));
      //   },
      // ),
    ),
    GoRoute(
      path: MYSWebPage.path,
      redirect: (context, state) {
        return null;
      },
      builder: (context, state) {
        var paramUrl = state.queryParameters['url'];
        var paramTitle = state.queryParameters['title'];

        var url = Uri.decodeFull(paramUrl!);

        return MYSWebPage(url: url, title: paramTitle);
      },
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
      path: WeatherScreen.path,
      builder: (context, state) => WeatherScreen(),
    ),
    GoRoute(
      path: SettingsScreen.path,
      builder: (context, state) => SettingsScreen(),
    ),
  ],
);
