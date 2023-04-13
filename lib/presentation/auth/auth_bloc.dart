import 'package:flutter_app/models/failure.dart';
import 'package:flutter_app/models/login_form_data.dart';
import 'package:flutter_app/services/auth_service.dart';
import 'package:flutter_app/utils/config_manager.dart';
import 'package:flutter_app/utils/constants.dart';
import 'package:flutter_app/utils/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

part 'auth_bloc.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState(LoadingStatus loadingStatus, bool isLoggedIn, Failure? failure) = _AuthState;
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

  AuthBloc(this._authService) : super(AuthState(LoadingStatus.Initialized, _authService.isLoggedIn, null)) {
    on<AuthEvent>((event, emit) async {
      await event.when(
        load: () async {
          emit(state.copyWith(loadingStatus: LoadingStatus.InProgress));

          bool isInitialized = await GetIt.I<ConfigManager>().init();

          emit(state.copyWith(
              loadingStatus: isInitialized ? LoadingStatus.Done : LoadingStatus.Error,
              isLoggedIn: _authService.isLoggedIn,
              failure: isInitialized ? null : InternalFailure(ErrorMessages.serverFail)));
        },
        logIn: (LoginFormData loginFormData) async {
          emit(state.copyWith(loadingStatus: LoadingStatus.InProgress));

          final resp = await _authService.login(loginFormData);

          if (resp.isValue)
            emit(state.copyWith(loadingStatus: LoadingStatus.Done, isLoggedIn: _authService.isLoggedIn, failure: null));
          else {
            var failure = resp.asError!.error;

            emit(state.copyWith(
              loadingStatus: LoadingStatus.Error,
              failure: failure is Failure ? failure : null,
            ));
          }
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
