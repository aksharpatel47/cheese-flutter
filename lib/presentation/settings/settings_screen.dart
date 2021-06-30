import 'package:flutter/material.dart';

import '../../common_widgets/drawer.dart';

class SettingsScreen extends StatelessWidget {
  static String path = "/settings";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings Screen"),
      ),
      drawer: AppDrawer(),
    );
  }
}
