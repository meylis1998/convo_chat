import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/logger.dart';
import '../../../../domain/entities/user_entity.dart';
import '../../../../domain/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription<UserEntity?>? _authStateSubscription;
  Timer? _sessionValidationTimer;

  /// Session validation interval (5 minutes)
  static const _sessionValidationInterval = Duration(minutes: 5);

  AuthBloc(this._authRepository) : super(const AuthState()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthUserChanged>(_onAuthUserChanged);
    on<SignInWithEmailRequested>(_onSignInWithEmail);
    on<SignUpWithEmailRequested>(_onSignUpWithEmail);
    on<SignInWithGoogleRequested>(_onSignInWithGoogle);
    on<SignInWithAppleRequested>(_onSignInWithApple);
    on<SignOutRequested>(_onSignOut);
    on<PasswordResetRequested>(_onPasswordReset);
    on<SessionValidationRequested>(_onSessionValidation);
    on<SessionExpired>(_onSessionExpired);
  }

  void _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) {
    _authStateSubscription?.cancel();
    _authStateSubscription = _authRepository.authStateChanges.listen(
      (user) => add(AuthUserChanged(user)),
    );
  }

  void _onAuthUserChanged(
    AuthUserChanged event,
    Emitter<AuthState> emit,
  ) {
    if (event.user != null) {
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: event.user,
        failure: null,
      ));
      _startSessionValidationTimer();
    } else {
      emit(state.copyWith(
        status: AuthStatus.unauthenticated,
        user: null,
      ));
      _stopSessionValidationTimer();
    }
  }

  void _startSessionValidationTimer() {
    _sessionValidationTimer?.cancel();
    _sessionValidationTimer = Timer.periodic(
      _sessionValidationInterval,
      (_) => add(const SessionValidationRequested()),
    );
  }

  void _stopSessionValidationTimer() {
    _sessionValidationTimer?.cancel();
    _sessionValidationTimer = null;
  }

  Future<void> _onSignInWithEmail(
    SignInWithEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await _authRepository.signInWithEmail(
      email: event.email,
      password: event.password,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: AuthStatus.unauthenticated,
        failure: failure,
      )),
      (user) => emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        failure: null,
      )),
    );
  }

  Future<void> _onSignUpWithEmail(
    SignUpWithEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await _authRepository.signUpWithEmail(
      email: event.email,
      password: event.password,
      displayName: event.displayName,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: AuthStatus.unauthenticated,
        failure: failure,
      )),
      (user) => emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        failure: null,
      )),
    );
  }

  Future<void> _onSignInWithGoogle(
    SignInWithGoogleRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await _authRepository.signInWithGoogle();

    result.fold(
      (failure) => emit(state.copyWith(
        status: AuthStatus.unauthenticated,
        failure: failure,
      )),
      (user) => emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        failure: null,
      )),
    );
  }

  Future<void> _onSignInWithApple(
    SignInWithAppleRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await _authRepository.signInWithApple();

    result.fold(
      (failure) => emit(state.copyWith(
        status: AuthStatus.unauthenticated,
        failure: failure,
      )),
      (user) => emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        failure: null,
      )),
    );
  }

  Future<void> _onSignOut(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _authRepository.signOut();
    emit(state.copyWith(
      status: AuthStatus.unauthenticated,
      user: null,
    ));
  }

  Future<void> _onPasswordReset(
    PasswordResetRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await _authRepository.sendPasswordResetEmail(event.email);

    result.fold(
      (failure) => emit(state.copyWith(
        status: AuthStatus.unauthenticated,
        failure: failure,
      )),
      (_) => emit(state.copyWith(
        status: AuthStatus.unauthenticated,
        failure: null,
      )),
    );
  }

  Future<void> _onSessionValidation(
    SessionValidationRequested event,
    Emitter<AuthState> emit,
  ) async {
    // Only validate if currently authenticated
    if (state.status != AuthStatus.authenticated) return;

    final result = await _authRepository.validateSession();

    result.fold(
      (failure) {
        // Session validation failed - likely network issue, don't log out
        AppLogger.warning('Session validation failed: ${failure.message}');
      },
      (isValid) {
        if (!isValid) {
          // Session is invalid - trigger session expired
          add(const SessionExpired(reason: 'Session expired or invalidated'));
        }
      },
    );
  }

  Future<void> _onSessionExpired(
    SessionExpired event,
    Emitter<AuthState> emit,
  ) async {
    AppLogger.warning('Session expired: ${event.reason}');
    _stopSessionValidationTimer();
    await _authRepository.signOut();
    emit(state.copyWith(
      status: AuthStatus.unauthenticated,
      user: null,
      failure: SessionFailure.expired(),
    ));
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    _sessionValidationTimer?.cancel();
    return super.close();
  }
}
