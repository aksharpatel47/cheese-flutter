part of 'cheese_client.dart';

extension CheeseClientRepoFunctions on CheeseClient {
  Future<Result<User>> login(LoginFormData loginFormData) async {
    var clientResp = await getClient(isAuthorized: false);

    if (clientResp.isError) return Result.error(clientResp.asError!.error);

    var client = clientResp.asValue!.value;

    var resp = await client.getService<AuthRemoteRepository>().login(loginFormData);

    if (resp.isSuccessful && resp.body != null)
      return Result.value(resp.body!);
    else {
      var error = resp.error;
      return Result.error(ServerFailure(error is CheeseError ? error.message : null, true));
    }
  }

  Future<Result<List<Todo>>> getTodos(int personId) async {
    var clientResp = await getClient();

    if (clientResp.isError) return Result.error(clientResp.asError!.error);

    var client = clientResp.asValue!.value;

    var resp = await client.getService<TodoRemoteRepository>().getTodos(personId);

    if (resp.isSuccessful && resp.body != null)
      return Result.value(resp.body!.todos);
    else {
      var error = resp.error;
      return Result.error(ServerFailure(error is CheeseError ? error.message : null, true));
    }
  }

  Future<Result<Todo>> toggleTodoStatus(Todo todo) async {
    var clientResp = await getClient();

    if (clientResp.isError) return Result.error(clientResp.asError!.error);

    var client = clientResp.asValue!.value;

    var resp = await client.getService<TodoRemoteRepository>().updateTodo(todo.id, TodoStatus(!todo.completed));

    if (resp.isSuccessful && resp.body != null)
      return Result.value(resp.body!);
    else {
      var error = resp.error;
      return Result.error(ServerFailure(error is CheeseError ? error.message : null, true));
    }
  }
}
