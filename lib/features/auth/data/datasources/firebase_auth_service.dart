import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/logger.dart';

@lazySingleton
class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth;
  bool _googleSignInInitialized = false;

  FirebaseAuthService({
    FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<void> _ensureGoogleSignInInitialized() async {
    if (!_googleSignInInitialized) {
      await GoogleSignIn.instance.initialize();
      _googleSignInInitialized = true;
    }
  }

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      AppLogger.firebase('Signing in with email: $email');
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      AppLogger.firebase('Sign in successful');
      return credential;
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Sign in failed: ${e.message}', error: e);
      throw AuthException(message: _mapFirebaseError(e.code), code: e.code);
    }
  }

  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      AppLogger.firebase('Signing up with email: $email');
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      AppLogger.firebase('Sign up successful');
      return credential;
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Sign up failed: ${e.message}', error: e);
      throw AuthException(message: _mapFirebaseError(e.code), code: e.code);
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    try {
      AppLogger.firebase('Signing in with Google');
      await _ensureGoogleSignInInitialized();

      final googleUser = await GoogleSignIn.instance.authenticate();
      final googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      AppLogger.firebase('Google sign in successful');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Google sign in failed: ${e.message}', error: e);
      throw AuthException(message: _mapFirebaseError(e.code), code: e.code);
    } catch (e) {
      AppLogger.error('Google sign in failed', error: e);
      throw AuthException(message: e.toString());
    }
  }

  Future<UserCredential> signInWithApple() async {
    try {
      AppLogger.firebase('Signing in with Apple');
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final userCredential =
          await _firebaseAuth.signInWithCredential(oauthCredential);

      // Update display name if provided by Apple
      if (appleCredential.givenName != null &&
          userCredential.user?.displayName == null) {
        final displayName =
            '${appleCredential.givenName} ${appleCredential.familyName ?? ''}'
                .trim();
        await userCredential.user?.updateDisplayName(displayName);
      }

      AppLogger.firebase('Apple sign in successful');
      return userCredential;
    } on SignInWithAppleAuthorizationException catch (e) {
      AppLogger.error('Apple sign in failed: ${e.message}', error: e);
      throw AuthException(message: e.message, code: e.code.name);
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Apple sign in failed: ${e.message}', error: e);
      throw AuthException(message: _mapFirebaseError(e.code), code: e.code);
    }
  }

  Future<void> signOut() async {
    try {
      AppLogger.firebase('Signing out');
      final futures = <Future<void>>[_firebaseAuth.signOut()];
      if (_googleSignInInitialized) {
        futures.add(GoogleSignIn.instance.signOut());
      }
      await Future.wait(futures);
      AppLogger.firebase('Sign out successful');
    } catch (e) {
      AppLogger.error('Sign out failed', error: e);
      throw AuthException(message: 'Failed to sign out');
    }
  }

  /// Validates the current session by forcing a token refresh and reloading user.
  /// Returns true if session is valid, false if user needs to re-authenticate.
  Future<bool> validateSession() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) return false;

      // Force refresh the token to validate session
      await user.getIdToken(true);

      // Reload user to check if account is still valid
      await user.reload();

      // Check if user still exists after reload
      final reloadedUser = _firebaseAuth.currentUser;
      AppLogger.firebase('Session validation successful');
      return reloadedUser != null;
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Session validation failed: ${e.code}', error: e);
      return false;
    } catch (e) {
      AppLogger.error('Session validation error', error: e);
      return false;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      AppLogger.firebase('Sending password reset email to: $email');
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      AppLogger.firebase('Password reset email sent');
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Password reset failed: ${e.message}', error: e);
      throw AuthException(message: _mapFirebaseError(e.code), code: e.code);
    }
  }

  Future<void> updateDisplayName(String displayName) async {
    try {
      await _firebaseAuth.currentUser?.updateDisplayName(displayName);
    } on FirebaseAuthException catch (e) {
      throw AuthException(message: _mapFirebaseError(e.code), code: e.code);
    }
  }

  Future<void> updatePhotoUrl(String photoUrl) async {
    try {
      await _firebaseAuth.currentUser?.updatePhotoURL(photoUrl);
    } on FirebaseAuthException catch (e) {
      throw AuthException(message: _mapFirebaseError(e.code), code: e.code);
    }
  }

  Future<void> deleteAccount() async {
    try {
      await _firebaseAuth.currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      throw AuthException(message: _mapFirebaseError(e.code), code: e.code);
    }
  }

  String _mapFirebaseError(String code) {
    switch (code) {
      case 'invalid-email':
        return 'Invalid email address';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'user-not-found':
        return 'No account found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'email-already-in-use':
        return 'An account already exists with this email';
      case 'weak-password':
        return 'Password is too weak';
      case 'operation-not-allowed':
        return 'This sign in method is not enabled';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later';
      case 'network-request-failed':
        return 'Network error. Please check your connection';
      default:
        return 'An error occurred. Please try again';
    }
  }
}
