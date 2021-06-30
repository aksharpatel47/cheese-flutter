// import 'package:flutter_app/presentation/login/login_screen.dart';
// import 'package:flutter_app/presentation/people/people_screen.dart';
// import 'package:flutter_app/presentation/people/person_screen.dart';
// import 'package:flutter_app/presentation/people/report_screen.dart';
// import 'package:flutter_app/presentation/people/search_screen.dart';
// import 'package:flutter_app/presentation/settings/settings_screen.dart';
// import 'package:flutter_app/presentation/splash/splash_screen.dart';
// import 'package:flutter_app/presentation/task/task_screen.dart';
//
// @MaterialAutoRouter(
//   replaceInRouteName: 'Screen,Route',
//   routes: <AutoRoute>[
//     AutoRoute(
//       page: SplashPage,
//       initial: true,
//     ),
//     AutoRoute(
//       page: LoginScreen,
//       path: "/login",
//     ),
//     AutoRoute(
//         page: EmptyRouterPage,
//         path: "/people",
//         name: "PeopleRouter",
//         children: [
//           AutoRoute(
//             path: "",
//             page: PeopleScreen,
//           ),
//           AutoRoute(
//             path: "person",
//             page: PersonScreen,
//           ),
//           CustomRoute(
//             path: "report",
//             page: ReportScreen,
//             opaque: false,
//           ),
//           MaterialRoute(
//             path: "search",
//             page: SearchScreen,
//             fullscreenDialog: true,
//           ),
//         ]),
//     AutoRoute(
//       page: SettingsScreen,
//       path: "/settings",
//     ),
//     AutoRoute(
//       page: TaskScreen,
//       path: "/task",
//     ),
//   ],
// )
// class $AppRouter {}
