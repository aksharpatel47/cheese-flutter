import 'package:chopper/chopper.dart';
import 'package:flutter_app/models/todo.dart';

part 'todo_remote_repository.chopper.dart';

@ChopperApi()
abstract class TodoRemoteRepository extends ChopperService {
  static TodoRemoteRepository create([ChopperClient? client]) => _$TodoRemoteRepository(client);

  @Get(path: '/todos/user/{pid}')
  Future<Response<TodoResponse>> getTodos(@Path('pid') int personId);

  @Put(path: '/todos/{id}')
  Future<Response<Todo>> updateTodo(@Path('id') int id, @Body() TodoStatus todoStatus);
}
