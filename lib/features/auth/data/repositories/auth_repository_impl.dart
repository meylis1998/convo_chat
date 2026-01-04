import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/firebase_auth_service.dart';
import '../datasources/firestore_user_service.dart';
import '../models/user_model.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthService _authService;
  final FirestoreUserService _userService;

  AuthRepositoryImpl(this._authService, this._userService);

  @override
  Stream<UserEntity?> get authStateChanges {
    return _authService.authStateChanges.asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;
      try {
        final user = await _userService.getUser(firebaseUser.uid);
        return user?.toEntity();
      } catch (e) {
        AppLogger.error('Failed to get user on auth state change', error: e);
        return null;
      }
    });
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _authService.signInWithEmail(
        email: email,
        password: password,
      );

      final user = await _userService.getUser(credential.user!.uid);
      if (user == null) {
        return Left(AuthFailure.userNotFound());
      }

      // Update online status
      await _userService.updateOnlineStatus(user.uid, true);

      return Right(user.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message, code: e.code));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final credential = await _authService.signUpWithEmail(
        email: email,
        password: password,
      );

      // Update Firebase Auth display name
      await _authService.updateDisplayName(displayName);

      // Create user in Firestore
      final user = UserModel(
        uid: credential.user!.uid,
        email: email,
        displayName: displayName,
        createdAt: DateTime.now(),
        isOnline: true,
      );

      await _userService.createUser(user);

      return Right(user.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message, code: e.code));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    try {
      final credential = await _authService.signInWithGoogle();
      final firebaseUser = credential.user!;

      // Check if user exists in Firestore
      var user = await _userService.getUser(firebaseUser.uid);

      if (user == null) {
        // Create new user
        user = UserModel(
          uid: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          displayName: firebaseUser.displayName ?? 'User',
          photoUrl: firebaseUser.photoURL,
          createdAt: DateTime.now(),
          isOnline: true,
        );
        await _userService.createUser(user);
      } else {
        // Update online status
        await _userService.updateOnlineStatus(user.uid, true);
      }

      return Right(user.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message, code: e.code));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithApple() async {
    try {
      final credential = await _authService.signInWithApple();
      final firebaseUser = credential.user!;

      // Check if user exists in Firestore
      var user = await _userService.getUser(firebaseUser.uid);

      if (user == null) {
        // Create new user
        user = UserModel(
          uid: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          displayName: firebaseUser.displayName ?? 'User',
          photoUrl: firebaseUser.photoURL,
          createdAt: DateTime.now(),
          isOnline: true,
        );
        await _userService.createUser(user);
      } else {
        // Update online status
        await _userService.updateOnlineStatus(user.uid, true);
      }

      return Right(user.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message, code: e.code));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      final currentUser = _authService.currentUser;
      if (currentUser != null) {
        await _userService.updateOnlineStatus(currentUser.uid, false);
      }
      await _authService.signOut();
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message, code: e.code));
    }
  }

  @override
  Future<Either<Failure, void>> sendPasswordResetEmail(String email) async {
    try {
      await _authService.sendPasswordResetEmail(email);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message, code: e.code));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final firebaseUser = _authService.currentUser;
      if (firebaseUser == null) {
        return const Right(null);
      }

      final user = await _userService.getUser(firebaseUser.uid);
      return Right(user?.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateProfile({
    String? displayName,
    String? photoUrl,
    String? bio,
  }) async {
    try {
      final currentUser = _authService.currentUser;
      if (currentUser == null) {
        return Left(AuthFailure.userNotFound());
      }

      final updates = <String, dynamic>{};
      if (displayName != null) {
        updates['displayName'] = displayName;
        await _authService.updateDisplayName(displayName);
      }
      if (photoUrl != null) {
        updates['photoUrl'] = photoUrl;
        await _authService.updatePhotoUrl(photoUrl);
      }
      if (bio != null) {
        updates['bio'] = bio;
      }

      if (updates.isNotEmpty) {
        await _userService.updateUser(currentUser.uid, updates);
      }

      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message, code: e.code));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> validateSession() async {
    try {
      final isValid = await _authService.validateSession();
      return Right(isValid);
    } on AuthException catch (e) {
      return Left(SessionFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(
        const SessionFailure(message: 'Failed to validate session'),
      );
    }
  }
}
