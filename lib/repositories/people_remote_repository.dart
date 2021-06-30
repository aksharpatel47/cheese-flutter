import 'package:chopper/chopper.dart';
import 'package:flutter_app/models/person.dart';

part 'people_remote_repository.chopper.dart';

@ChopperApi(baseUrl: "/people")
abstract class PeopleRemoteRepository extends ChopperService {
  static PeopleRemoteRepository create([ChopperClient? client]) =>
      _$PeopleRemoteRepository(client);

  @Get(path: "/{projectId}/")
  Future<Response<List<Person>>> getProjectPeople(@Path() int projectId);

  @Get()
  Future<Response<List<Person>>> getAssignedPeople();
}
