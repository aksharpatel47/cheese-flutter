import 'package:async/async.dart';
import 'package:flutter_app/api_clients/myseva_client.dart';
import 'package:flutter_app/models/person.dart';
import 'package:flutter_app/models/position.dart';
import 'package:injectable/injectable.dart';

abstract class IPersonService {
  Future<Result<List<Person>>> getProfile(List<int> personIdList);
  Future<Result<List<Position>>> getPersonPosition(int personId);
}

@LazySingleton(as: IPersonService)
class PersonService implements IPersonService {
  MYSClient _mysClient;

  PersonService(this._mysClient);

  Future<Result<List<Person>>> getProfile(List<int> personIdList) async => await _mysClient.getPeople(personIdList);

  Future<Result<List<Position>>> getPersonPosition(int personId) async => await _mysClient.getPersonPosition(personId);
}
