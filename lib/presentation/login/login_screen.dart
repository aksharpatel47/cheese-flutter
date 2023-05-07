import 'package:flutter/material.dart';
import 'package:flutter_app/presentation/home/home_screen.dart';
import 'package:flutter_app/presentation/login/widgets/login_form.dart';
import 'package:flutter_app/utils/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../auth/auth_bloc.dart';

class LoginScreen extends StatelessWidget {
  static String id = "login";
  static String path = "/$id";

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.loadingStatus == LoadingStatus.Error && state.failure != null)
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.failure!.message)));
        if (state.user != null) {
          GoRouter.of(context).go(HomeScreen.path);
        }
      },
      child: const LoginForm(),
    );
  }
}
