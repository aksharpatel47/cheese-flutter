import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_app/models/token.dart';
import 'package:flutter_app/presentation/auth/auth_bloc.dart';
import 'package:flutter_app/services/auth_service.dart';
import 'package:flutter_app/services/person_service.dart';
import 'package:flutter_app/utils/enums.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_bloc_test.mocks.dart';

@GenerateMocks([IAuthService, IPersonService])
void main() {
  IAuthService authService = MockIAuthService();
  IPersonService personService = MockIPersonService();
  List<bool> responses = [];
  final loginFormData = Token('username', 'password');

  setUpAll(() {
    when(authService.isLoggedIn).thenAnswer((_) => responses.removeAt(0));
  });

  group('Auth Bloc', () {
    blocTest(
      'should load initial auth state on creation',
      build: () {
        responses = [false, false];
        return AuthBloc(authService, personService);
      },
      expect: () => [AuthState(LoadingStatus.Initialized, null, null)],
    );

    blocTest(
      'should login user based on username and password in logIn event',
      build: () {
        responses = [false, false, true];
        return AuthBloc(authService, personService);
      },
      act: (AuthBloc bloc) => bloc..add(AuthEvent.logIn(loginFormData)),
      expect: () => [AuthState(LoadingStatus.Error, null, any), AuthState(LoadingStatus.Done, any, null)],
    );

    blocTest(
      'should log out user on logOut event',
      build: () {
        responses = [false, false, true, false];
        return AuthBloc(authService, personService);
      },
      act: (AuthBloc bloc) => bloc
        ..add(AuthEvent.logIn(loginFormData))
        ..add(AuthEvent.logOut()),
      expect: () => [
        AuthState(LoadingStatus.Error, null, any),
        AuthState(LoadingStatus.Done, any, null),
        AuthState(LoadingStatus.Error, null, any),
      ],
    );
  });
}
