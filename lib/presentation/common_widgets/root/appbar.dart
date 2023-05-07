import 'dart:ui';

import 'package:flutter/material.dart';

PreferredSize getAppBar(String? title) {
  return PreferredSize(
    child: MYSAppBar(title: title),
    preferredSize: Size(
      double.infinity,
      56,
    ),
  );
}

class MYSAppBar extends StatelessWidget {
  const MYSAppBar({
    super.key,
    required this.title,
  });

  final String? title;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: AppBar(
          backgroundColor: Colors.white.withOpacity(0.3),
          foregroundColor: Colors.black,
          elevation: 0,
          title: Text(
            title ?? "",
          ),
          flexibleSpace: MYSAppbarBG(),
        ),
      ),
    );
  }
}

class MYSAppbarBG extends StatelessWidget {
  const MYSAppbarBG({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[Color(0xff9EABCB).withOpacity(0.2), Color(0xffF6D6C1).withOpacity(0.2)]),
      ),
    );
  }
}
