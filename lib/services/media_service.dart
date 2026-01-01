import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

import '../core/errors/exceptions.dart';
import '../core/utils/logger.dart';

@lazySingleton
class MediaService {
  final FirebaseStorage _storage;
  final ImagePicker _imagePicker;
  final _uuid = const Uuid();

  MediaService({
    FirebaseStorage? storage,
    ImagePicker? imagePicker,
  })  : _storage = storage ?? FirebaseStorage.instance,
        _imagePicker = imagePicker ?? ImagePicker();

  Future<File?> pickImage({required ImageSource source}) async {
    try {
      final xFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );
      if (xFile == null) return null;
      return File(xFile.path);
    } catch (e) {
      AppLogger.error('Failed to pick image', error: e);
      return null;
    }
  }

  Future<File?> pickVideo({required ImageSource source}) async {
    try {
      final xFile = await _imagePicker.pickVideo(
        source: source,
        maxDuration: const Duration(minutes: 5),
      );
      if (xFile == null) return null;
      return File(xFile.path);
    } catch (e) {
      AppLogger.error('Failed to pick video', error: e);
      return null;
    }
  }

  Future<List<File>> pickMultipleImages() async {
    try {
      final xFiles = await _imagePicker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );
      return xFiles.map((xFile) => File(xFile.path)).toList();
    } catch (e) {
      AppLogger.error('Failed to pick multiple images', error: e);
      return [];
    }
  }

  Future<MediaUploadResult> uploadImage({
    required File file,
    required String conversationId,
    void Function(double)? onProgress,
  }) async {
    return _uploadMedia(
      file: file,
      conversationId: conversationId,
      folder: 'images',
      onProgress: onProgress,
    );
  }

  Future<MediaUploadResult> uploadVideo({
    required File file,
    required String conversationId,
    void Function(double)? onProgress,
  }) async {
    return _uploadMedia(
      file: file,
      conversationId: conversationId,
      folder: 'videos',
      onProgress: onProgress,
    );
  }

  Future<MediaUploadResult> uploadFile({
    required File file,
    required String conversationId,
    void Function(double)? onProgress,
  }) async {
    return _uploadMedia(
      file: file,
      conversationId: conversationId,
      folder: 'files',
      onProgress: onProgress,
    );
  }

  Future<MediaUploadResult> uploadVoice({
    required File file,
    required String conversationId,
    void Function(double)? onProgress,
  }) async {
    return _uploadMedia(
      file: file,
      conversationId: conversationId,
      folder: 'voice',
      onProgress: onProgress,
    );
  }

  Future<MediaUploadResult> _uploadMedia({
    required File file,
    required String conversationId,
    required String folder,
    void Function(double)? onProgress,
  }) async {
    try {
      final fileName = '${_uuid.v4()}${path.extension(file.path)}';
      final storagePath = 'conversations/$conversationId/$folder/$fileName';

      AppLogger.firebase('Uploading media to: $storagePath');

      final ref = _storage.ref().child(storagePath);
      final uploadTask = ref.putFile(file);

      uploadTask.snapshotEvents.listen((snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        onProgress?.call(progress);
      });

      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      final metadata = await snapshot.ref.getMetadata();

      AppLogger.firebase('Upload complete: $downloadUrl');

      return MediaUploadResult(
        url: downloadUrl,
        fileName: path.basename(file.path),
        fileSize: metadata.size ?? 0,
        mimeType: metadata.contentType ?? 'application/octet-stream',
      );
    } on FirebaseException catch (e) {
      AppLogger.error('Failed to upload media', error: e);
      throw StorageException(message: e.message ?? 'Failed to upload media');
    }
  }

  Future<void> deleteMedia(String url) async {
    try {
      final ref = _storage.refFromURL(url);
      await ref.delete();
      AppLogger.firebase('Media deleted: $url');
    } on FirebaseException catch (e) {
      AppLogger.error('Failed to delete media', error: e);
      // Don't throw - just log the error
    }
  }
}

class MediaUploadResult {
  final String url;
  final String fileName;
  final int fileSize;
  final String mimeType;

  const MediaUploadResult({
    required this.url,
    required this.fileName,
    required this.fileSize,
    required this.mimeType,
  });
}
