import 'package:chopper/chopper.dart';
import 'package:flutter_app/models/person.dart';
import 'package:flutter_app/models/position.dart';

part 'people_remote_repository.chopper.dart';

@ChopperApi()
abstract class PeopleRemoteRepository extends ChopperService {
  static PeopleRemoteRepository create([ChopperClient? client]) => _$PeopleRemoteRepository(client);

  @Get(path: '/Person/Profile')
  Future<Response<List<Person>>> getPeople(@Query('personId') List<int> personIdList);

  @Get(path: "/Person/Position")
  Future<Response<List<Position>>> getPositions(@Query("personId") int personId);
}
