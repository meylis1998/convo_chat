// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../data/datasources/remote/firebase_auth_service.dart' as _i1;
import '../../data/datasources/remote/firestore_conversation_service.dart' as _i2;
import '../../data/datasources/remote/firestore_message_service.dart' as _i3;
import '../../data/datasources/remote/firestore_user_service.dart' as _i4;
import '../../data/repositories/auth_repository_impl.dart' as _i5;
import '../../domain/repositories/auth_repository.dart' as _i6;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i7;
import '../../features/chat/presentation/bloc/chat_bloc.dart' as _i8;
import '../../features/conversations/presentation/bloc/conversations_bloc.dart' as _i9;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );

    // Services
    gh.lazySingleton<_i1.FirebaseAuthService>(() => _i1.FirebaseAuthService());
    gh.lazySingleton<_i4.FirestoreUserService>(() => _i4.FirestoreUserService());
    gh.lazySingleton<_i2.FirestoreConversationService>(() => _i2.FirestoreConversationService());
    gh.lazySingleton<_i3.FirestoreMessageService>(() => _i3.FirestoreMessageService());

    // Repositories
    gh.lazySingleton<_i6.AuthRepository>(() => _i5.AuthRepositoryImpl(
      gh<_i1.FirebaseAuthService>(),
      gh<_i4.FirestoreUserService>(),
    ));

    // Blocs
    gh.factory<_i7.AuthBloc>(() => _i7.AuthBloc(gh<_i6.AuthRepository>()));
    gh.factory<_i9.ConversationsBloc>(() => _i9.ConversationsBloc(gh<_i2.FirestoreConversationService>()));
    gh.factory<_i8.ChatBloc>(() => _i8.ChatBloc(
      gh<_i3.FirestoreMessageService>(),
      gh<_i2.FirestoreConversationService>(),
    ));

    return this;
  }
}
