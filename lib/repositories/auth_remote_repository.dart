import 'package:chopper/chopper.dart';
import 'package:flutter_app/models/login_form_data.dart';
import 'package:flutter_app/models/user.dart';

part 'auth_remote_repository.chopper.dart';

@ChopperApi()
abstract class AuthRemoteRepository extends ChopperService {
  static AuthRemoteRepository create([ChopperClient? client]) => _$AuthRemoteRepository(client);

  @Post(path: '/auth/login')
  Future<Response<User>> login(@Body() LoginFormData loginFormData);
}
