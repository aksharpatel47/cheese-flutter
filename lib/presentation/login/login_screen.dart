import 'package:flutter/material.dart';
import 'package:flutter_app/presentation/people/people_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../auth/auth_bloc.dart';
import 'widgets/login_scaffold.dart';

class LoginScreen extends StatelessWidget {
  static String id = "login";
  static String path = "/$id";

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoggedIn) {
          GoRouter.of(context).go(PeopleScreen.path);
        }
      },
      child: const LoginScaffold(),
    );
  }
}
