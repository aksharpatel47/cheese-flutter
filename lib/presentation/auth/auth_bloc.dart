import 'package:flutter_app/models/failure.dart';
import 'package:flutter_app/models/position.dart';
import 'package:flutter_app/models/token.dart';
import 'package:flutter_app/models/user.dart';
import 'package:flutter_app/services/auth_service.dart';
import 'package:flutter_app/services/person_service.dart';
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
  const factory AuthState(LoadingStatus loadingStatus, User? user, Failure? failure) = _AuthState;
}

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.load() = _Load;
  const factory AuthEvent.logIn(Token token) = _LogIn;
  const factory AuthEvent.logOut() = _LogOut;
}

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  IAuthService _authService;
  IPersonService _personService;

  AuthBloc(this._authService, this._personService) : super(AuthState(LoadingStatus.Initialized, null, null)) {
    on<AuthEvent>((event, emit) async {
      await event.when(
        load: () async {
          // var start = DateTime.now();
          emit(state.copyWith(loadingStatus: LoadingStatus.InProgress));

          bool isInitialized = await GetIt.I<ConfigManager>().init();

          if (isInitialized) {
            var resp = await _authService.checkLogin();

            // var end = DateTime.now();

            // var value = 5000 - end.difference(start).inMilliseconds;
            //
            // if (value > 0) await Future.delayed(Duration(milliseconds: value));

            if (resp.isValue) {
              var profile = _authService.user;
              var positions = <Position>[];

              final positionResp = await _personService.getPersonPosition(profile!.personId);

              if (positionResp.isValue) positions = positionResp.asValue!.value;

              User user = User(profile, positions);

              emit(state.copyWith(loadingStatus: LoadingStatus.Done, user: user, failure: null));
            } else {
              var failure = resp.asError!.error as Failure;

              if (failure is NoTokenFailure)
                emit(state.copyWith(loadingStatus: LoadingStatus.Done, user: null, failure: null));
              else
                emit(state.copyWith(loadingStatus: LoadingStatus.Error, user: null, failure: failure));
            }
          } else
            emit(state.copyWith(
                loadingStatus: LoadingStatus.Error, user: null, failure: InternalFailure(ErrorMessages.serverFail)));
        },
        logIn: (token) async {
          emit(state.copyWith(loadingStatus: LoadingStatus.InProgress));

          final resp = await _authService.login(token);

          if (resp.isValue) {
            var profile = _authService.user;
            var positions = <Position>[];

            final positionResp = await _personService.getPersonPosition(profile!.personId);

            if (positionResp.isValue) positions = positionResp.asValue!.value;

            User user = User(profile, positions);

            emit(state.copyWith(loadingStatus: LoadingStatus.Done, user: user, failure: null));
          } else {
            var failure = resp.asError!.error;

            emit(state.copyWith(
              loadingStatus: LoadingStatus.Error,
              failure: failure is Failure ? failure : null,
            ));
          }
        },
        logOut: () async {
          await _authService.logOut();
          emit(state.copyWith(user: null));
        },
      );
    });
    add(AuthEvent.load());
  }
}
