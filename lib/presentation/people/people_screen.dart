import 'package:flutter/material.dart';
import 'package:flutter_app/presentation/people/person_screen.dart';
import 'package:flutter_app/presentation/people/report_screen.dart';
import 'package:flutter_app/presentation/people/search_screen.dart';
import 'package:vrouter/vrouter.dart';

import '../../common_widgets/drawer.dart';

class PeopleScreen extends StatelessWidget {
  static const String id = "people";
  static const String path = "/$id";

  const PeopleScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("People Screen"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              context.vRouter.push(SearchScreen.id);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: ListView(
        children: [
          ListTile(
            title: Text("Person 1"),
            onTap: () {
              context.vRouter.push(PersonScreen.id);
            },
            trailing: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                context.vRouter.push(ReportScreen.id);
              },
            ),
          ),
        ],
      ),
    );
  }
}
