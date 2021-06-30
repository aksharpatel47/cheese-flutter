import 'package:flutter/material.dart';

class CommonScreen extends StatelessWidget {
  final AppBar? appBar;
  final String? title;
  final Widget body;

  const CommonScreen({Key? key, this.title, this.appBar, required this.body})
      : assert(title != null || appBar != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar ??
          AppBar(
            title: Text(title!),
          ),
      drawer: Drawer(),
      body: body,
    );
  }
}
