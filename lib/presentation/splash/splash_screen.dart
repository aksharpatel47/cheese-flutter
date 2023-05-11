import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/presentation/common_widgets/mys_webpage.dart';
import 'package:flutter_app/presentation/home/home_screen.dart';
// import 'package:flutter_app/router.dart';
import 'package:flutter_app/utils/config_manager.dart';
import 'package:flutter_app/utils/enums.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

import '../auth/auth_bloc.dart';

class SplashPage extends StatelessWidget {
  static String path = "/";

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if ([LoadingStatus.Done, LoadingStatus.Error].contains(state.loadingStatus)) {
          if (state.user != null) {
            GoRouter.of(context).go(HomeScreen.path);
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
    const aadB2CClientID = "69b690f5-cd2d-477a-b42f-341b6190e258";
    const aadB2CRedirectURL =
        "https://bapsdev.b2clogin.com/bapsdev.onmicrosoft.com/B2C_1A_SIGNUP_SIGNIN/v2.0/.well-known/openid-configuration";
    const aadB2CUserFlowName = "B2C_1A_SIGNUP_SIGNIN";
    const aadB2CScopes = ['openid', 'offline_access', "69b690f5-cd2d-477a-b42f-341b6190e258"];
    const aadB2CUserAuthFlow =
        "https://bapsdev.b2clogin.com/bapsdev.onmicrosoft.com"; // https://login.microsoftonline.com/<azureTenantId>/oauth2/v2.0/token/
    const aadB2TenantName = "bapsdev";

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          Hero(
            tag: 'logo',
            child: Stack(
              alignment: Alignment.center,
              children: [
                RotatingBG(
                  color: Color(0xffF8D8B7),
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 40.0, sigmaY: 40.0),
                  child: Container(),
                ),
                Transform.rotate(
                  angle: -3.14 / 8,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0x66F8D8B7),
                    ),
                    height: 170,
                    width: 170,
                  ),
                ),
                SizedBox(
                  height: 170,
                  width: 170,
                  child: Image.asset(
                    'assets/mys_logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
          Hero(
            tag: 'message',
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return () {
                  if (state.loadingStatus == LoadingStatus.Done && state.user == null)
                    return Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: InkWell(
                            onTap: () async {
                              FlutterAppAuth _appAuth = FlutterAppAuth();
                              AuthorizationTokenResponse? result;
                              try {
                                result = await _appAuth.authorizeAndExchangeCode(
                                  AuthorizationTokenRequest(
                                      "69b690f5-cd2d-477a-b42f-341b6190e258", "org.baps.na.mysevaapp://auth/",
                                      discoveryUrl:
                                          "https://bapsdev.b2clogin.com/bapsdev.onmicrosoft.com/v2.0/.well-known/openid-configuration?p=B2C_1A_SIGNUP_SIGNIN",
                                      scopes: [
                                        'offline_access',
                                        'openid',
                                      ],
                                      additionalParameters: {'p': 'B2C_1A_SIGNUP_SIGNIN'},
                                      preferEphemeralSession: true),
                                );

                                print(result);
                              } catch (e) {
                                print(e.toString());
                              }
                              // GoRouter.of(context).push(LoginScreen.path);

                              // c.Config config = new c.Config(
                              //   tenant: "bapsdev.onmicrosoft.com",
                              //   clientId: "69b690f5-cd2d-477a-b42f-341b6190e258",
                              //   scope: "openid profile offline_access",
                              //   // redirectUri is Optional as a default is calculated based on app type/web location
                              //   // redirectUri:
                              //   //     "https://bapsdev.b2clogin.com/bapsdev.onmicrosoft.com/B2C_1A_SIGNUP_SIGNIN/v2.0/.well-known/openid-configuration",
                              //   navigatorKey: navigatorKey,
                              //   webUseRedirect:
                              //       true, // default is false - on web only, forces a redirect flow instead of popup auth
                              //   //Optional parameter: Centered CircularProgressIndicator while rendering web page in WebView
                              //   loader: Center(child: CupertinoActivityIndicator()),
                              //   // postLogoutRedirectUri: 'http://your_base_url/logout', //optional
                              // );
                              //
                              // final AadOAuth oauth = new AadOAuth(config);
                              //
                              // final res = await oauth.login();
                              // print(res);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                              decoration: BoxDecoration(color: Color(0xff9EABCB)),
                              child: Text(
                                "Login with BAPS SSO",
                                style: TextStyle(fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Not a member?",
                              style: TextStyle(fontSize: 15.5),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            GestureDetector(
                              onTap: () {
                                var config = GetIt.I<ConfigManager>().remoteConfigData;

                                if (config != null) {
                                  var signUpUrl = config.signUpUrl;

                                  var path =
                                      MYSWebPage.path + "?url=" + Uri.encodeFull(signUpUrl) + "&title=" + "Sign Up";

                                  context.push(path);
                                }
                              },
                              child: Text(
                                "Signup now",
                                style: TextStyle(fontSize: 15.5, color: Color(0xff7285A6)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  else if (state.loadingStatus == LoadingStatus.Error && state.failure != null)
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 30),
                      decoration: BoxDecoration(
                        color: Color(0xff9EABCB).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              state.failure!.message,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 15, color: Color(0xff7285A6)),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              context.read<AuthBloc>().add(AuthEvent.load());
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                              decoration:
                                  BoxDecoration(color: Color(0xff7285A6), borderRadius: BorderRadius.circular(20)),
                              child: Text(
                                "Refresh",
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    );
                  else if (state.loadingStatus == LoadingStatus.InProgress)
                    return CupertinoActivityIndicator(radius: 12);
                  else
                    return SizedBox();
                }.call();
              },
            ),
          ),
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 270,
                child: WaveWidget(
                  config: CustomConfig(
                    gradients: [
                      [Color(0xffC99FA9), Color(0xffF6D6C1)],
                      [Color(0xffE7B7C3), Color(0xffC99FA9)],
                      [Color(0xff9EABCB), Color(0xffE7B7C3)],
                      [Color(0xff7285A6), Color(0xff9EABCB)],
                    ],
                    durations: [35000, 19440, 10800, 6000],
                    heightPercentages: [0.10, 0.15, 0.20, 0.30],
                    gradientBegin: Alignment.bottomCenter,
                    gradientEnd: Alignment.topCenter,
                    blur: MaskFilter.blur(BlurStyle.solid, 40),
                  ),
                  size: Size(double.infinity, double.infinity),
                  waveAmplitude: 10,
                  duration: 100,
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(bottom: Platform.isAndroid ? 20 : 0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 70,
                        child: Image.asset(
                          "assets/mys_name.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                var config = GetIt.I<ConfigManager>().remoteConfigData;

                                if (config != null) {
                                  var signUpUrl = config.termsUrl;

                                  var path = MYSWebPage.path +
                                      "?url=" +
                                      Uri.encodeFull(signUpUrl) +
                                      "&title=" +
                                      "Terms of use";

                                  context.push(path);
                                }
                              },
                              child: Text(
                                "Terms of use",
                                style: TextStyle(fontSize: 15.5, color: Colors.white.withOpacity(0.8)),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                var config = GetIt.I<ConfigManager>().remoteConfigData;

                                if (config != null) {
                                  var signUpUrl = config.privacyUrl;

                                  var path = MYSWebPage.path +
                                      "?url=" +
                                      Uri.encodeFull(signUpUrl) +
                                      "&title=" +
                                      "Privacy Policy";

                                  context.push(path);
                                }
                              },
                              child: Text(
                                "Privacy Policy",
                                style: TextStyle(fontSize: 15.5, color: Colors.white.withOpacity(0.8)),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Text("mySeva")
        ],
      ),
    );
  }
}

class RotatingBG extends StatefulWidget {
  final Color color;

  const RotatingBG({Key? key, required this.color}) : super(key: key);

  @override
  State<RotatingBG> createState() => _RotatingBGState();
}

class _RotatingBGState extends State<RotatingBG> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _fadeController;

  @override
  void initState() {
    _controller = AnimationController(
      duration: Duration(seconds: 7),
      vsync: this,
    )..repeat();
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 1300),
      vsync: this,
    )..repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween(begin: 0.0, end: 0.6).animate(_fadeController),
      child: RotationTransition(
        turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
        child: Container(
          height: 250,
          width: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: widget.color,
          ),
          // child: Image.asset(
          //   'assets/mys_logo_back.png',
          //   fit: BoxFit.contain,
          // ),
        ),
      ),
    );
  }
}
