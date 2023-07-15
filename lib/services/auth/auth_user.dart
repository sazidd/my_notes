import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  const AuthUser({
    required this.id,
    required this.email,
    required this.isEmailVerified,
  });
  final String id;
  final String email;
  final bool isEmailVerified;

  factory AuthUser.fromFirebase(User user) {
    return AuthUser(
      id: user.uid,
      email: user.email!,
      isEmailVerified: user.emailVerified,
    );
  }
}
