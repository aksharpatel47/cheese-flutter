import 'package:flutter/material.dart';
import 'package:flutter_app/presentation/auth/auth_bloc.dart';
import 'package:flutter_app/presentation/login/login_screen.dart';
import 'package:flutter_app/presentation/people/people_screen.dart';
import 'package:flutter_app/presentation/settings/settings_screen.dart';
import 'package:flutter_app/presentation/task/task_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:vrouter/vrouter.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<AuthBloc>(),
      child: Builder(
        builder: (context) {
          return BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state.isLoggedIn == false) {
                context.vRouter.pushReplacement(LoginScreen.path);
              }
            },
            child: _getDrawerChild(context),
          );
        },
      ),
    );
  }

  Widget _getDrawerChild(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).accentColor),
              child: Text(
                "Header",
                style: Theme.of(context).textTheme.headline4?.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
            ListTile(
              key: ValueKey("PeopleScreen"),
              leading: Icon(Icons.people),
              title: Text("People"),
              dense: true,
              onTap: () {
                context.vRouter.pushReplacement(PeopleScreen.path);
              },
              trailing: Icon(Icons.chevron_right),
            ),
            ListTile(
              key: ValueKey("TaskScreen"),
              leading: Icon(Icons.check),
              title: Text("Task"),
              dense: true,
              onTap: () {
                context.vRouter.pushReplacement(TaskScreen.path);
              },
              trailing: Icon(Icons.chevron_right),
            ),
            Divider(),
            ListTile(
              key: ValueKey("SettingsScreen"),
              title: Text("Settings"),
              dense: true,
              onTap: () {
                context.vRouter.pushReplacement(SettingsScreen.path);
              },
              trailing: Icon(Icons.chevron_right),
            ),
            ListTile(
              title: Text("About"),
              dense: true,
              onTap: () {},
              trailing: Icon(Icons.chevron_right),
            ),
            Divider(),
            ListTile(
              title: Text("Contact Us"),
              onTap: () {
                print("Send Email");
              },
            ),
            ListTile(
              key: Key('logOut'),
              leading: Icon(Icons.power_settings_new),
              title: Text("Log Out"),
              onTap: () {
                BlocProvider.of<AuthBloc>(context).add(AuthEvent.logOut());
              },
            ),
          ],
        ),
      ),
    );
  }
}
