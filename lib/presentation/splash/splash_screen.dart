import 'package:flutter/material.dart';
import 'package:flutter_app/presentation/login/login_screen.dart';
import 'package:flutter_app/presentation/people/people_screen.dart';
import 'package:flutter_app/utils/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../auth/auth_bloc.dart';

class SplashPage extends StatelessWidget {
  static String path = "/";

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if ([LoadingStatus.Done, LoadingStatus.Error].contains(state.loadingStatus)) {
          if (state.user != null) {
            GoRouter.of(context).go(PeopleScreen.path);
          } else {
            GoRouter.of(context).go(LoginScreen.path);
          }
        }
      },
      child: SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Splash Screen",
                key: Key("SplashText"),
              ),
              SizedBox(
                height: 30,
              ),
              CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
