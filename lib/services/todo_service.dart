import 'package:async/async.dart';
import 'package:flutter_app/api_clients/cheese_client.dart';
import 'package:flutter_app/models/todo.dart';
import 'package:injectable/injectable.dart';

abstract class ITodoService {
  Future<Result<List<Todo>>> getTodos(int personId);

  Future<Result<Todo>> toggleStatus(Todo todo);
}

@LazySingleton(as: ITodoService)
class TodoService implements ITodoService {
  CheeseClient _cheeseClient;

  TodoService(this._cheeseClient);

  @override
  Future<Result<List<Todo>>> getTodos(int personId) async => await _cheeseClient.getTodos(personId);

  @override
  Future<Result<Todo>> toggleStatus(Todo todo) async => await _cheeseClient.toggleTodoStatus(todo);
}
