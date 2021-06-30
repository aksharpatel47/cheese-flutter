import 'package:flutter/material.dart';

import '../../common_widgets/drawer.dart';

class TaskScreen extends StatelessWidget {
  static String id = "task";
  static String path = "/$id";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task Screen"),
      ),
      drawer: AppDrawer(),
    );
  }
}
