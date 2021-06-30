import 'package:flutter/material.dart';
import 'package:flutter_app/presentation/people/people_screen.dart';
import 'package:vrouter/vrouter.dart';

class ReportScreen extends StatelessWidget {
  static String id = "report";
  static String path = "$PeopleScreen.path/$id";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 48, 32, 48),
      child: Scaffold(
        body: Container(
          color: Colors.white,
          child: Center(
            child: OutlinedButton(
              child: Text("Close"),
              onPressed: () {
                context.vRouter.pop();
              },
            )
          ),
        ),
      ),
    );
  }
}
