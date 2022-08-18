import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/models/person.dart';

part 'people_remote_repository.g.dart';

@RestApi()
abstract class PeopleRemoteRepository {
  factory PeopleRemoteRepository(Dio dio, {String baseUrl}) = _PeopleRemoteRepository;

  @GET('/people/{id}')
  Future<Person> getPerson(@Path('id') int id);

  @GET('/people')
  Future<List<Person>> getPeople();
}
