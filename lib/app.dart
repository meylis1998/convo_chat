import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/injection.dart';
import 'core/errors/failures.dart';
import 'features/auth/data/datasources/firestore_user_service.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';

class ConvoApp extends StatefulWidget {
  const ConvoApp({super.key});

  @override
  State<ConvoApp> createState() => _ConvoAppState();
}

class _ConvoAppState extends State<ConvoApp> with WidgetsBindingObserver {
  late final AuthBloc _authBloc;
  late final AppRouter _appRouter;
  late final FirestoreUserService _userService;
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _userService = getIt<FirestoreUserService>();
    _authBloc = getIt<AuthBloc>()..add(const AuthCheckRequested());
    _appRouter = AppRouter(_authBloc);

    // Listen to auth state changes to update online status
    _authBloc.stream.listen((state) {
      if (state.isAuthenticated && state.user != null) {
        _userService.updateOnlineStatus(state.user!.uid, true);
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _authBloc.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final user = _authBloc.state.user;
    if (user == null) return;

    switch (state) {
      case AppLifecycleState.resumed:
        _userService.updateOnlineStatus(user.uid, true);
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
      case AppLifecycleState.detached:
        _userService.updateOnlineStatus(user.uid, false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _authBloc,
      child: BlocListener<AuthBloc, AuthState>(
        listenWhen: (previous, current) =>
            current.failure is SessionFailure &&
            previous.failure != current.failure,
        listener: (context, state) {
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SnackBar(
              content: Text(state.failure!.message),
              backgroundColor: AppColors.error,
              duration: const Duration(seconds: 5),
              action: SnackBarAction(
                label: 'OK',
                textColor: AppColors.white,
                onPressed: () {},
              ),
            ),
          );
        },
        child: MaterialApp.router(
          scaffoldMessengerKey: _scaffoldMessengerKey,
          title: 'Convo',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.system,
          routerConfig: _appRouter.router,
        ),
      ),
    );
  }
}
