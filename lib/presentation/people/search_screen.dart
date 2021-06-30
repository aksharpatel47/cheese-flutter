import 'package:flutter/material.dart';

import 'people_screen.dart';

class SearchScreen extends StatelessWidget {
  static String id = "search";
  static String path = "$PeopleScreen.path/$id";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Screen"),
      ),
      body: Center(
        child: Text("Search Results"),
      ),
    );
  }
}
