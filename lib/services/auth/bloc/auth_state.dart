part of 'auth_bloc.dart';

@immutable
abstract class AuthState {
  const AuthState({
    required this.isLoading,
    this.loadingText = 'Please wait a moment',
  });

  final bool isLoading;
  final String? loadingText;
}

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized({required super.isLoading});
}

class AuthStateRegistering extends AuthState {
  const AuthStateRegistering({
    required super.isLoading,
    required this.exception,
  });

  final Exception? exception;
}

class AuthStateForgotPassword extends AuthState {
  const AuthStateForgotPassword({
    required super.isLoading,
    required this.exception,
    required this.hasSentEmail,
  });

  final Exception? exception;
  final bool hasSentEmail;
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;

  const AuthStateLoggedIn({
    required super.isLoading,
    required this.user,
  });
}

class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification({required super.isLoading});
}

class AuthStateLoggedOut extends AuthState with EquatableMixin {
  AuthStateLoggedOut({
    required super.isLoading,
    super.loadingText = null,
    required this.exception,
  });

  final Exception? exception;

  @override
  List<Object?> get props => [exception, isLoading];
}
