import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/entities/user_entity.dart';

abstract class AuthRepository {
  Stream<UserEntity?> get authStateChanges;

  Future<Either<Failure, UserEntity>> signInWithEmail({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  });

  Future<Either<Failure, UserEntity>> signInWithGoogle();

  Future<Either<Failure, UserEntity>> signInWithApple();

  Future<Either<Failure, void>> signOut();

  Future<Either<Failure, void>> sendPasswordResetEmail(String email);

  Future<Either<Failure, UserEntity?>> getCurrentUser();

  Future<Either<Failure, void>> updateProfile({
    String? displayName,
    String? photoUrl,
    String? bio,
  });

  /// Validates the current session.
  /// Returns Right(true) if valid, Right(false) if invalid/expired.
  Future<Either<Failure, bool>> validateSession();
}
