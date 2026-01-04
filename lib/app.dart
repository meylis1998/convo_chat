import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/injection.dart';
import 'core/errors/failures.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'presentation/routes/app_router.dart';
import 'presentation/theme/app_colors.dart';
import 'presentation/theme/app_theme.dart';

class ConvoApp extends StatefulWidget {
  const ConvoApp({super.key});

  @override
  State<ConvoApp> createState() => _ConvoAppState();
}

class _ConvoAppState extends State<ConvoApp> {
  late final AuthBloc _authBloc;
  late final AppRouter _appRouter;
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    _authBloc = getIt<AuthBloc>()..add(const AuthCheckRequested());
    _appRouter = AppRouter(_authBloc);
  }

  @override
  void dispose() {
    _authBloc.close();
    super.dispose();
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
