import 'package:flutter/material.dart';
import 'package:flutter_app/presentation/login/widgets/login_form.dart';

class LoginBody extends StatelessWidget {
  const LoginBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LoginForm(),
    );
  }
}
