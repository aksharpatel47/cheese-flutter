import 'package:flutter/material.dart';
import 'package:flutter_app/presentation/auth/auth_bloc.dart';
import 'package:flutter_app/presentation/task/task_bloc.dart';
import 'package:flutter_app/utils/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get_it/get_it.dart';

import '../common_widgets/drawer.dart';

class TaskScreen extends StatelessWidget {
  static String id = "task";
  static String path = "/$id";

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TaskBloc>(
      create: (context) => GetIt.I<TaskBloc>(),
      child: Builder(builder: (context) {
        var user = context.read<AuthBloc>().state.user;
        if (user != null) context.read<TaskBloc>().add(TaskEvent.load(user.profile.personId));

        return Scaffold(
          appBar: AppBar(
            title: Text("Task Screen"),
          ),
          drawer: AppDrawer(),
          floatingActionButton: BlocBuilder<TaskBloc, TaskState>(
            builder: (context, state) {
              bool show = state.when(success: (l, _) => l != LoadingStatus.InProgress, empty: (_, __) => false);

              if (show) {
                return FloatingActionButton(
                  onPressed: () {
                    // context.read<TaskBloc>();
                  },
                  child: Icon(Icons.add),
                );
              } else
                return SizedBox();
            },
          ),
          body: BlocBuilder<TaskBloc, TaskState>(builder: (context, state) {
            return Container(
              child: state.when(success: (loadingStatus, todoList) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    ListView.builder(
                      itemCount: todoList.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: FormBuilderCheckbox(
                              name: todoList[index].id.toString(),
                              title: Text(
                                todoList[index].todo,
                                style: TextStyle(fontSize: 18),
                              ),
                              initialValue: todoList[index].completed,
                              onChanged: (value) {
                                context.read<TaskBloc>().add(TaskEvent.toggleStatus(todoList[index].id));
                              },
                            ),
                          ),
                        );
                      },
                    ),
                    if (loadingStatus == LoadingStatus.InProgress) ...[
                      Container(
                        color: Colors.white.withOpacity(0.6),
                      ),
                      Center(child: CircularProgressIndicator()),
                    ],
                  ],
                );
              }, empty: (loadingStatus, failure) {
                if (loadingStatus == LoadingStatus.Error && failure != null)
                  return Center(child: Text(failure.message));
                else
                  return Center(child: CircularProgressIndicator());
              }),
            );
          }),
        );
      }),
    );
  }
}
