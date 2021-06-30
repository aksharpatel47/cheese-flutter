import 'package:flutter_app/models/login_form_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../services/auth_service.dart';

part 'auth_bloc.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState(bool isLoggedIn) = _AuthState;
}

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.load() = _Load;
  const factory AuthEvent.logIn(LoginFormData loginFormData) = _LogIn;
  const factory AuthEvent.logOut() = _LogOut;
}

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  IAuthService _authService;

  AuthBloc(this._authService) : super(AuthState(_authService.isLoggedIn)) {
    add(AuthEvent.load());
  }

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    yield* event.when(load: () async* {
      yield state.copyWith(isLoggedIn: _authService.isLoggedIn);
    }, logIn: (LoginFormData loginFormData) async* {
      // Check if username and password are correct
      _authService.login(loginFormData);
      yield state.copyWith(isLoggedIn: _authService.isLoggedIn);
    }, logOut: () async* {
      _authService.logOut();
      yield state.copyWith(isLoggedIn: _authService.isLoggedIn);
    });
  }
}
