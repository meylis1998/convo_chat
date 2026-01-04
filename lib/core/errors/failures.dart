import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure({required this.message, this.code});

  @override
  List<Object?> get props => [message, code];
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.code});
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message, super.code});
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'No internet connection',
    super.code,
  });
}

class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.code});

  factory AuthFailure.invalidEmail() => const AuthFailure(
        message: 'Invalid email address',
        code: 'invalid-email',
      );

  factory AuthFailure.wrongPassword() => const AuthFailure(
        message: 'Wrong password',
        code: 'wrong-password',
      );

  factory AuthFailure.userNotFound() => const AuthFailure(
        message: 'User not found',
        code: 'user-not-found',
      );

  factory AuthFailure.emailAlreadyInUse() => const AuthFailure(
        message: 'Email is already in use',
        code: 'email-already-in-use',
      );

  factory AuthFailure.weakPassword() => const AuthFailure(
        message: 'Password is too weak',
        code: 'weak-password',
      );

  factory AuthFailure.unknown([String? message]) => AuthFailure(
        message: message ?? 'An unknown error occurred',
        code: 'unknown',
      );
}

class StorageFailure extends Failure {
  const StorageFailure({required super.message, super.code});
}

class ValidationFailure extends Failure {
  const ValidationFailure({required super.message, super.code});
}

class SessionFailure extends Failure {
  const SessionFailure({required super.message, super.code});

  factory SessionFailure.expired() => const SessionFailure(
        message: 'Your session has expired. Please sign in again.',
        code: 'session-expired',
      );

  factory SessionFailure.invalidated() => const SessionFailure(
        message:
            'Your session was invalidated. You may have logged in on another device.',
        code: 'session-invalidated',
      );
}
