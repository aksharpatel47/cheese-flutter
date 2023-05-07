import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/token.dart';
import 'package:flutter_app/presentation/auth/auth_bloc.dart';
import 'package:flutter_app/presentation/common_widgets/mys_webpage.dart';
import 'package:flutter_app/utils/config_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MYSWebPage(
      postRequest: getPostRequest(context),
      title: "Login",
      delayedHeightLoad: true,
      onLoadStart: (url) {
        extractToken(url, context);
      },
      onLoadStop: (url) {
        extractToken(url, context);
      },
    );
  }

  Future<void> extractToken(Uri? url, BuildContext context) async {
    if (url?.hasQuery ?? false) {
      var authStr = url?.queryParameters["auth"];

      if (authStr != null) {
        var auth = jsonDecode(authStr);

        var token = auth['token'];
        var refreshToken = auth['refreshToken'];

        if (token != null && refreshToken != null) {
          var userToken = Token(token, refreshToken);

          context.read<AuthBloc>().add(AuthEvent.logIn(userToken));

          context.pop(userToken);
        }
      }
    }
  }

  String getFormHtml(BuildContext context) {
    var configs = GetIt.I<ConfigManager>().remoteConfigData;

    String body =
        "<body onload=\"document.forms['submit_form'].submit()\"><form name=\"submit_form\" ngcontent-myn-c13="
        " ngnoform="
        " method=\"post\" action=\"${configs!.ssoPostUrl}\"><input style='display:none;' ngcontent-myn-c13="
        " type=\"hidden\" name=\"client_id\" value=\"${configs.ssoClientId}\"><input style='display:none;' _ngcontent-myn-c13="
        " type=\"hidden\" name=\"client_key\" value=\"${configs.ssoSecretKey}\"></form></body>";
    return body;
  }

  PostRequest getPostRequest(BuildContext context) {
    var configs = GetIt.I<ConfigManager>().remoteConfigData;

    return PostRequest(
      configs!.ssoPostUrl,
      Uint8List.fromList(utf8.encode("client_id=${configs.ssoClientId}&client_key=${configs.ssoSecretKey}")),
    );
  }
}
