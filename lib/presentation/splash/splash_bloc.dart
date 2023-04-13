// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_app/utils/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../services/auth_service.dart';
import '../auth/auth_bloc.dart';

@injectable
class SplashBloc extends Bloc<AuthEvent, AuthState> {
  IAuthService _authService;

  SplashBloc(
    this._authService,
  ) : super(AuthState(LoadingStatus.Initialized, _authService.isLoggedIn, null)) {
    on<AuthEvent>(
      (event, emit) {
        emit(state.copyWith(isLoggedIn: _authService.isLoggedIn));
      },
    );
    add(AuthEvent.load());
  }
}
