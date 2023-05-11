import 'package:aad_b2c_webview/aad_b2c_webview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/presentation/home/home_screen.dart';
import 'package:flutter_app/presentation/login/widgets/b2c.dart' as a;
import 'package:flutter_app/utils/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../auth/auth_bloc.dart';

class LoginScreen extends StatelessWidget {
  static String id = "login";
  static String path = "/$id";

  @override
  Widget build(BuildContext context) {
    const aadB2CClientID = "69b690f5-cd2d-477a-b42f-341b6190e258";
    const aadB2CRedirectURL = "org.baps.na.myseva://auth/";
    const aadB2CUserFlowName = "B2C_1A_SIGNUP_SIGNIN";
    const aadB2CScopes = ['openid', 'offline_access', "69b690f5-cd2d-477a-b42f-341b6190e258"];
    const aadB2CUserAuthFlow =
        "https://bapsdev.b2clogin.com/bapsdev.onmicrosoft.com"; // https://login.microsoftonline.com/<azureTenantId>/oauth2/v2.0/token/
    const aadB2TenantName = "bapsdev";

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.loadingStatus == LoadingStatus.Error && state.failure != null)
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.failure!.message)));
        if (state.user != null) {
          GoRouter.of(context).go(HomeScreen.path);
        }
      },
      child: Scaffold(
        body: a.ADB2CEmbedWebView(
          tenantBaseUrl: aadB2CUserAuthFlow,
          userFlowName: aadB2CUserFlowName,
          clientId: aadB2CClientID,
          redirectUrl: aadB2CRedirectURL,
          scopes: aadB2CScopes,
          onAnyTokenRetrieved: (Token anyToken) {},
          onIDToken: (Token token) {},
          onAccessToken: (Token token) {},
          onRefreshToken: (Token token) {},
        ),
      ),
      // child: const LoginForm(),
    );
  }
}
