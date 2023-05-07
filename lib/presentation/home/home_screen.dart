import 'package:flutter/material.dart';
import 'package:flutter_app/presentation/auth/auth_bloc.dart';
import 'package:flutter_app/presentation/splash/splash_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class HomeScreen extends StatelessWidget {
  static final id = "home";
  static final path = "${SplashPage.path}home";

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String firstName = context.watch<AuthBloc>().state.user?.profile?.personFirstName ?? "";
    String lastName = context.watch<AuthBloc>().state.user?.profile?.personLastName ?? "";

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        context.go(SplashPage.path);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.9,
              child: WaveWidget(
                config: CustomConfig(
                  gradients: [
                    [Color(0xffC99FA9), Color(0xffF6D6C1)],
                    [Color(0xffE7B7C3), Color(0xffC99FA9)],
                    [Color(0xff9EABCB), Color(0xffE7B7C3)],
                    [Color(0xff7285A6), Color(0xff9EABCB)],
                  ],
                  durations: [35000, 19440, 10800, 6000],
                  heightPercentages: [0.15, 0.30, 0.50, 0.70],
                  gradientBegin: Alignment.bottomCenter,
                  gradientEnd: Alignment.topCenter,
                  blur: MaskFilter.blur(BlurStyle.normal, 80),
                ),
                size: Size(double.infinity, double.infinity),
                waveAmplitude: 40,
                duration: 100,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: ListView(
                children: [
                  Row(
                    children: [
                      Column(
                        children: [
                          Text(
                            "Jai Swaminarayan",
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.black38,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            [firstName, lastName].join(" "),
                            style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0x66F6D6C1),
                              Color(0x339EABCB),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: IconButton(
                          onPressed: () {
                            context.read<AuthBloc>().add(AuthEvent.logOut());
                          },
                          icon: Icon(
                            Icons.person,
                            color: Color(0xff7285A6),
                            size: 27,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
