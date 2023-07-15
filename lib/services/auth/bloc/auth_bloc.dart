import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import 'package:my_notes/services/auth/auth_provider.dart';
import 'package:my_notes/services/auth/auth_user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider)
      : super(const AuthStateUninitialized(isLoading: true)) {
    on<AuthEventShouldRegister>((event, emit) async {
      emit(
        const AuthStateRegistering(
          isLoading: false,
          exception: null,
        ),
      );
    });

    on<AuthEventForgotPassword>((event, emit) async {
      emit(
        const AuthStateForgotPassword(
          isLoading: false,
          exception: null,
          hasSentEmail: false,
        ),
      );

      final email = event.email;
      if (email == null) {
        return;
      }

      emit(
        const AuthStateForgotPassword(
          isLoading: true,
          exception: null,
          hasSentEmail: false,
        ),
      );

      bool didSendEmail;
      Exception? exception;

      try {
        await provider.sendPasswordReset(toEmail: email);
        didSendEmail = true;
        exception = null;
      } on Exception catch (e) {
        didSendEmail = false;
        exception = e;
      }
      emit(
        AuthStateForgotPassword(
          isLoading: false,
          exception: exception,
          hasSentEmail: didSendEmail,
        ),
      );
    });

    on<AuthEventSendEmailVerification>((event, emit) async {
      await provider.sendEmailVerification();
      emit(state);
    });

    on<AuthEventRegister>((event, emit) async {
      final email = event.email;
      final password = event.password;
      try {
        await provider.createUser(
          email: email,
          password: password,
        );
        await provider.sendEmailVerification();
        emit(const AuthStateNeedsVerification(isLoading: false));
      } on Exception catch (e) {
        emit(AuthStateRegistering(exception: e, isLoading: false));
      }
    });

    on<AuthEvenInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(AuthStateLoggedOut(exception: null, isLoading: false));
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNeedsVerification(isLoading: false));
      } else {
        emit(AuthStateLoggedIn(user: user, isLoading: false));
      }
    });

    on<AuthEventLogIn>((event, emit) async {
      emit(AuthStateLoggedOut(
        exception: null,
        isLoading: true,
        loadingText: 'Please wait while I log you in',
      ));
      final email = event.email;
      final password = event.password;
      try {
        final user = await provider.login(
          email: email,
          password: password,
        );

        if (!user.isEmailVerified) {
          emit(AuthStateLoggedOut(exception: null, isLoading: false));
          emit(const AuthStateNeedsVerification(isLoading: false));
        } else {
          emit(AuthStateLoggedOut(exception: null, isLoading: false));
          emit(AuthStateLoggedIn(user: user, isLoading: false));
        }
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(exception: e, isLoading: false));
      }
    });

    on<AuthEventLogOut>((event, emit) async {
      try {
        await provider.logOut();
        emit(AuthStateLoggedOut(exception: null, isLoading: false));
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(exception: e, isLoading: false));
      }
    });
  }
}
