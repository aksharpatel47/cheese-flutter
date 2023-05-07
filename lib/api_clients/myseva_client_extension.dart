part of 'myseva_client.dart';

extension MYSClientRepoFunctions on MYSClient {
  Future<Result<Token>> refreshToken(Token token) async {
    var clientResp = await getClient(allowExpired: true);

    if (clientResp.isError) return Result.error(clientResp.asError!.error);

    var client = clientResp.asValue!.value;

    var resp = await client.getService<TokenRemoteRepository>().refreshToken(token);

    if (resp.isSuccessful && resp.body != null)
      return Result.value(resp.body!);
    else {
      var error = resp.error;
      return Result.error(ServerFailure(error is Failure ? error.message : null, null));
    }
  }

  Future<Result<List<Person>>> getPeople(List<int> personIdList) async {
    var clientResp = await getClient();

    if (clientResp.isError) return Result.error(clientResp.asError!.error);

    var client = clientResp.asValue!.value;

    var resp = await client.getService<PeopleRemoteRepository>().getPeople(personIdList);

    if (resp.isSuccessful && resp.body != null)
      return Result.value(resp.body!);
    else {
      var error = resp.error;
      return Result.error(ServerFailure(error is Failure ? error.message : null, null));
    }
  }

  Future<Result<List<Position>>> getPersonPosition(int personId) async {
    var clientResp = await getClient();

    if (clientResp.isError) return Result.error(clientResp.asError!.error);

    var client = clientResp.asValue!.value;

    var resp = await client.getService<PeopleRemoteRepository>().getPositions(personId);

    if (resp.isSuccessful && resp.body != null)
      return Result.value(resp.body!);
    else {
      var error = resp.error;
      return Result.error(ServerFailure(error is Failure ? error.message : null, null));
    }
  }
}
