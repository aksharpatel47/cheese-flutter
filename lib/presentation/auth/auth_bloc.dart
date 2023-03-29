import 'package:flutter_app/models/login_form_data.dart';
import 'package:flutter_app/services/auth_service.dart';
import 'package:flutter_app/utils/config_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

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
    on<AuthEvent>((event, emit) async {
      await event.when(
        load: () async {
          await GetIt.I<ConfigManager>().init();
          emit(state.copyWith(isLoggedIn: _authService.isLoggedIn));
        },
        logIn: (LoginFormData loginFormData) {
          // Check if username and password are correct
          _authService.login(loginFormData);
          emit(state.copyWith(isLoggedIn: _authService.isLoggedIn));
        },
        logOut: () {
          _authService.logOut();
          emit(state.copyWith(isLoggedIn: _authService.isLoggedIn));
        },
      );
    });
    add(AuthEvent.load());
  }
}
