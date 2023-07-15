part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class AuthEvenInitialize extends AuthEvent {
  const AuthEvenInitialize();
}

class AuthEventLogIn extends AuthEvent {
  const AuthEventLogIn({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
}

class AuthEventSendEmailVerification extends AuthEvent {
  const AuthEventSendEmailVerification();
}

class AuthEventRegister extends AuthEvent {
  const AuthEventRegister(this.email, this.password);

  final String email;
  final String password;
}

class AuthEventShouldRegister extends AuthEvent {
  const AuthEventShouldRegister();
}

class AuthEventForgotPassword extends AuthEvent {
  const AuthEventForgotPassword({this.email});

  final String? email;
}

class AuthEventLogOut extends AuthEvent {
  const AuthEventLogOut();
}
