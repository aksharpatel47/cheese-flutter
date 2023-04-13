import 'package:chopper/chopper.dart';
import 'package:flutter_app/models/token.dart';

part 'token_remote_repository.chopper.dart';

@ChopperApi()
abstract class TokenRemoteRepository extends ChopperService {
  static TokenRemoteRepository create([ChopperClient? client]) => _$TokenRemoteRepository(client);

  @Get(path: '/refresh')
  Future<Response<Token>> refreshToken(@Body() Token token);
}
