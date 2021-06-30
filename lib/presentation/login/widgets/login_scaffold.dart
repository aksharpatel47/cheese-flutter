import 'package:flutter/material.dart';

import 'login_body.dart';

class LoginScaffold extends StatelessWidget {
  const LoginScaffold({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: const LoginBody(),
    );
  }
}
