import 'package:flutter_app/models/failure.dart';
import 'package:flutter_app/models/todo.dart';
import 'package:flutter_app/services/todo_service.dart';
import 'package:flutter_app/utils/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'task_bloc.freezed.dart';

@injectable
class TaskBloc extends Bloc<TaskEvent, TaskState> {
  ITodoService _todoService;

  List<Todo> _todoList = <Todo>[];

  TaskBloc(this._todoService) : super(TaskState.empty(LoadingStatus.Initialized, null)) {
    on<TaskEvent>((event, emit) async {
      await event.when(load: (personId) async {
        emit(TaskState.empty(LoadingStatus.InProgress, null));

        final resp = await _todoService.getTodos(personId);

        if (resp.isError) {
          var failure = resp.asError!.error;
          if (failure is Failure) emit(TaskState.empty(LoadingStatus.Error, failure));
        } else {
          _todoList = resp.asValue!.value;
          emit(TaskState.success(LoadingStatus.Done, _todoList));
        }
      }, toggleStatus: (id) async {
        int index = _todoList.indexWhere((e) => e.id == id);
        if (index >= 0) {
          emit(TaskState.success(LoadingStatus.InProgress, _todoList));

          final resp = await _todoService.toggleStatus(_todoList[index]);

          if (resp.isValue) {
            var newTodo = resp.asValue!.value;
            _todoList[index].completed = newTodo.completed;

            emit(TaskState.success(LoadingStatus.Done, _todoList));
          }
        }
      });
    });
  }
}

@freezed
class TaskState with _$TaskState {
  const factory TaskState.success(LoadingStatus loadingStatus, List<Todo> todoList) = _Success;
  const factory TaskState.empty(LoadingStatus loadingStatus, Failure? failure) = _Empty;
}

@freezed
class TaskEvent with _$TaskEvent {
  const factory TaskEvent.load(int personId) = _Load;
  const factory TaskEvent.toggleStatus(int id) = _ToggleStatus;
}
