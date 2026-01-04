// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:firebase_storage/firebase_storage.dart' as _i457;
import 'package:get_it/get_it.dart' as _i174;
import 'package:image_picker/image_picker.dart' as _i183;
import 'package:injectable/injectable.dart' as _i526;
import 'package:just_audio/just_audio.dart' as _i501;
import 'package:record/record.dart' as _i1039;

import '../../features/auth/data/datasources/firebase_auth_service.dart'
    as _i607;
import '../../features/auth/data/datasources/firestore_user_service.dart'
    as _i488;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i797;
import '../../features/chat/data/datasources/firestore_message_service.dart'
    as _i868;
import '../../features/chat/presentation/bloc/chat_bloc.dart' as _i65;
import '../../features/conversations/data/datasources/firestore_conversation_service.dart'
    as _i49;
import '../../features/conversations/presentation/bloc/conversations_bloc.dart'
    as _i794;
import '../../features/search/presentation/bloc/search_bloc.dart' as _i552;
import '../services/media_service.dart' as _i586;
import '../services/voice_service.dart' as _i950;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i59.FirebaseAuth>(() => registerModule.firebaseAuth);
    gh.lazySingleton<_i974.FirebaseFirestore>(
      () => registerModule.firebaseFirestore,
    );
    gh.lazySingleton<_i457.FirebaseStorage>(
      () => registerModule.firebaseStorage,
    );
    gh.lazySingleton<_i183.ImagePicker>(() => registerModule.imagePicker);
    gh.lazySingleton<_i1039.AudioRecorder>(() => registerModule.audioRecorder);
    gh.lazySingleton<_i501.AudioPlayer>(() => registerModule.audioPlayer);
    gh.lazySingleton<_i488.FirestoreUserService>(
      () =>
          _i488.FirestoreUserService(firestore: gh<_i974.FirebaseFirestore>()),
    );
    gh.lazySingleton<_i868.FirestoreMessageService>(
      () => _i868.FirestoreMessageService(
        firestore: gh<_i974.FirebaseFirestore>(),
      ),
    );
    gh.lazySingleton<_i49.FirestoreConversationService>(
      () => _i49.FirestoreConversationService(
        firestore: gh<_i974.FirebaseFirestore>(),
      ),
    );
    gh.lazySingleton<_i950.VoiceService>(
      () => _i950.VoiceService(
        recorder: gh<_i1039.AudioRecorder>(),
        player: gh<_i501.AudioPlayer>(),
      ),
    );
    gh.lazySingleton<_i607.FirebaseAuthService>(
      () => _i607.FirebaseAuthService(firebaseAuth: gh<_i59.FirebaseAuth>()),
    );
    gh.factory<_i794.ConversationsBloc>(
      () => _i794.ConversationsBloc(gh<_i49.FirestoreConversationService>()),
    );
    gh.lazySingleton<_i787.AuthRepository>(
      () => _i153.AuthRepositoryImpl(
        gh<_i607.FirebaseAuthService>(),
        gh<_i488.FirestoreUserService>(),
      ),
    );
    gh.factory<_i797.AuthBloc>(
      () => _i797.AuthBloc(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i65.ChatBloc>(
      () => _i65.ChatBloc(
        gh<_i868.FirestoreMessageService>(),
        gh<_i49.FirestoreConversationService>(),
      ),
    );
    gh.factory<_i552.SearchBloc>(
      () => _i552.SearchBloc(
        gh<_i488.FirestoreUserService>(),
        gh<_i868.FirestoreMessageService>(),
        gh<_i49.FirestoreConversationService>(),
      ),
    );
    gh.lazySingleton<_i586.MediaService>(
      () => _i586.MediaService(
        storage: gh<_i457.FirebaseStorage>(),
        imagePicker: gh<_i183.ImagePicker>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
