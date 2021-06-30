import 'package:flutter/material.dart';
import 'package:flutter_app/presentation/people/people_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:vrouter/vrouter.dart';
import '../auth/auth_bloc.dart';
import 'widgets/login_scaffold.dart';

class LoginScreen extends StatelessWidget {
  static String id = "login";
  static String path = "/$id";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<AuthBloc>(),
      child: Builder(
        builder: (context) {
          return BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state.isLoggedIn == true) {
                context.vRouter.pushReplacement(PeopleScreen.path);
              }
            },
            child: const LoginScaffold(),
          );
        },
      ),
    );
  }
}
