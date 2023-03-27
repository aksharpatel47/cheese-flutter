import 'package:flutter/material.dart';
import 'package:flutter_app/presentation/people/people_screen.dart';

class PersonScreen extends StatelessWidget {
  static String id = ":personId";
  static String path = "${PeopleScreen.path}/$id";

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Person Screen"),
          bottom: const TabBar(
            tabs: const <Widget>[
              const Tab(
                key: ValueKey("tab1"),
                icon: const Icon(Icons.ac_unit),
              ),
              const Tab(
                key: ValueKey("tab2"),
                icon: const Icon(Icons.account_balance),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: const <Widget>[
            const Center(
              child: const Text('It\'s cloudy here'),
            ),
            const Center(
              child: const Text('It\'s rainy here'),
            ),
          ],
        ),
      ),
    );
  }
}
