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

import '../../data/datasources/remote/firebase_auth_service.dart' as _i6;
import '../../data/datasources/remote/firestore_conversation_service.dart'
    as _i291;
import '../../data/datasources/remote/firestore_message_service.dart' as _i100;
import '../../data/datasources/remote/firestore_user_service.dart' as _i407;
import '../../data/repositories/auth_repository_impl.dart' as _i895;
import '../../domain/repositories/auth_repository.dart' as _i1073;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i797;
import '../../features/chat/presentation/bloc/chat_bloc.dart' as _i65;
import '../../features/conversations/presentation/bloc/conversations_bloc.dart'
    as _i794;
import '../../features/search/presentation/bloc/search_bloc.dart' as _i552;
import '../../services/media_service.dart' as _i454;
import '../../services/voice_service.dart' as _i365;
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
    gh.lazySingleton<_i291.FirestoreConversationService>(
      () => _i291.FirestoreConversationService(
        firestore: gh<_i974.FirebaseFirestore>(),
      ),
    );
    gh.lazySingleton<_i100.FirestoreMessageService>(
      () => _i100.FirestoreMessageService(
        firestore: gh<_i974.FirebaseFirestore>(),
      ),
    );
    gh.lazySingleton<_i407.FirestoreUserService>(
      () =>
          _i407.FirestoreUserService(firestore: gh<_i974.FirebaseFirestore>()),
    );
    gh.factory<_i794.ConversationsBloc>(
      () => _i794.ConversationsBloc(gh<_i291.FirestoreConversationService>()),
    );
    gh.lazySingleton<_i365.VoiceService>(
      () => _i365.VoiceService(
        recorder: gh<_i1039.AudioRecorder>(),
        player: gh<_i501.AudioPlayer>(),
      ),
    );
    gh.lazySingleton<_i6.FirebaseAuthService>(
      () => _i6.FirebaseAuthService(firebaseAuth: gh<_i59.FirebaseAuth>()),
    );
    gh.factory<_i552.SearchBloc>(
      () => _i552.SearchBloc(
        gh<_i407.FirestoreUserService>(),
        gh<_i100.FirestoreMessageService>(),
        gh<_i291.FirestoreConversationService>(),
      ),
    );
    gh.factory<_i65.ChatBloc>(
      () => _i65.ChatBloc(
        gh<_i100.FirestoreMessageService>(),
        gh<_i291.FirestoreConversationService>(),
      ),
    );
    gh.lazySingleton<_i454.MediaService>(
      () => _i454.MediaService(
        storage: gh<_i457.FirebaseStorage>(),
        imagePicker: gh<_i183.ImagePicker>(),
      ),
    );
    gh.lazySingleton<_i1073.AuthRepository>(
      () => _i895.AuthRepositoryImpl(
        gh<_i6.FirebaseAuthService>(),
        gh<_i407.FirestoreUserService>(),
      ),
    );
    gh.factory<_i797.AuthBloc>(
      () => _i797.AuthBloc(gh<_i1073.AuthRepository>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
