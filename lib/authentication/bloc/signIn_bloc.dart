import 'dart:async';

import 'package:cryptoPanic/authentication/models/authDetails.dart';

import 'package:cryptoPanic/authentication/repository/auth_repository.dart';

import 'package:equatable/equatable.dart';

import 'package:bloc/bloc.dart';

part 'signIn_event.dart';
part 'signIn_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository _authenticationRepository;

  AuthenticationBloc(
      {required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(AuthenticationInitial());

  StreamSubscription<AuthenticationDetail>? authStreamSub;

  @override
  Future<void> close() {
    authStreamSub?.cancel();
    return super.close();
  }

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AuthenticationStarted) {
      try {
        yield AuthenticationLoading();
        authStreamSub = _authenticationRepository
            .getAuthDetailStream()
            .listen((authDetail) {
          add(AuthenticationStateChanged(authenticationDetail: authDetail));
        });
      } catch (error) {
        print(
            'Error occurred while fetching authentication detail : ${error.toString()}');
        yield AuthenticationFailiure(
            message: 'Error occurred while fetching auth detail');
      }
    } else if (event is AuthenticationStateChanged) {
      if (event.authenticationDetail.isValid!) {
        yield AuthenticationSuccess(
            authenticationDetail: event.authenticationDetail);
      } else {
        yield AuthenticationFailiure(message: 'User has logged out');
      }
    } else if (event is AuthenticationGoogleStarted) {
      try {
        yield AuthenticationLoading();
        AuthenticationDetail authenticationDetail =
            await _authenticationRepository.authenticateWithGoogle();

        if (authenticationDetail.isValid!) {
          yield AuthenticationSuccess(
              authenticationDetail: authenticationDetail);
        } else {
          yield AuthenticationFailiure(message: 'User detail not found.');
        }
      } catch (error) {
        print('Error occurred while login with Google ${error.toString()}');
        yield AuthenticationFailiure(
          message: 'Unable to login with Google. Try again.',
        );
      }
    } else if (event is AuthenticationExited) {
      try {
        yield AuthenticationLoading();
        await _authenticationRepository.unAuthenticate();
      } catch (error) {
        print('Error occurred while logging out. : ${error.toString()}');
        yield AuthenticationFailiure(
            message: 'Unable to logout. Please try again.');
      }
    }
  }
}
