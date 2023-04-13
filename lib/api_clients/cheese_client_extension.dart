part of 'cheese_client.dart';

extension CheeseClientRepoFunctions on CheeseClient {
  Future<Result<User>> login(LoginFormData loginFormData) async {
    var clientResp = await getClient(isAuthorized: false);

    if (clientResp.isError) return Result.error(clientResp.asError!.error);

    var client = clientResp.asValue!.value;

    var resp = await client.getService<AuthRemoteRepository>().login(loginFormData);

    if (resp.isSuccessful && resp.body != null)
      return Result.value(resp.body!);
    else
      return Result.error(ServerFailure(null, true));
  }
}
