import 'dart:async';
import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';

import '../core/utils/logger.dart';

enum RecordingState {
  idle,
  recording,
  paused,
  stopped,
}

@lazySingleton
class VoiceService {
  final AudioRecorder _recorder;
  final AudioPlayer _player;
  final _uuid = const Uuid();

  final _recordingStateController = StreamController<RecordingState>.broadcast();
  final _durationController = StreamController<Duration>.broadcast();
  final _amplitudeController = StreamController<double>.broadcast();

  Timer? _durationTimer;
  Duration _currentDuration = Duration.zero;
  String? _currentRecordingPath;

  VoiceService({
    AudioRecorder? recorder,
    AudioPlayer? player,
  })  : _recorder = recorder ?? AudioRecorder(),
        _player = player ?? AudioPlayer();

  Stream<RecordingState> get recordingState => _recordingStateController.stream;
  Stream<Duration> get duration => _durationController.stream;
  Stream<double> get amplitude => _amplitudeController.stream;

  Duration get currentDuration => _currentDuration;
  String? get currentRecordingPath => _currentRecordingPath;

  Future<bool> hasPermission() async {
    return await _recorder.hasPermission();
  }

  Future<void> startRecording() async {
    try {
      final hasPermission = await _recorder.hasPermission();
      if (!hasPermission) {
        AppLogger.warning('Microphone permission not granted');
        return;
      }

      final directory = await getTemporaryDirectory();
      _currentRecordingPath = '${directory.path}/${_uuid.v4()}.m4a';

      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: _currentRecordingPath!,
      );

      _currentDuration = Duration.zero;
      _recordingStateController.add(RecordingState.recording);

      // Start duration timer
      _durationTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) async {
        _currentDuration += const Duration(milliseconds: 100);
        _durationController.add(_currentDuration);

        // Get amplitude
        final amp = await _recorder.getAmplitude();
        _amplitudeController.add(amp.current);
      });

      AppLogger.info('Recording started: $_currentRecordingPath');
    } catch (e) {
      AppLogger.error('Failed to start recording', error: e);
      _recordingStateController.add(RecordingState.idle);
    }
  }

  Future<VoiceRecordingResult?> stopRecording() async {
    try {
      _durationTimer?.cancel();

      final path = await _recorder.stop();
      _recordingStateController.add(RecordingState.stopped);

      if (path == null) return null;

      final file = File(path);
      if (!await file.exists()) return null;

      final duration = _currentDuration.inSeconds;
      _currentDuration = Duration.zero;

      AppLogger.info('Recording stopped: $path, duration: ${duration}s');

      return VoiceRecordingResult(
        file: file,
        duration: duration,
      );
    } catch (e) {
      AppLogger.error('Failed to stop recording', error: e);
      _recordingStateController.add(RecordingState.idle);
      return null;
    }
  }

  Future<void> cancelRecording() async {
    try {
      _durationTimer?.cancel();
      await _recorder.stop();

      if (_currentRecordingPath != null) {
        final file = File(_currentRecordingPath!);
        if (await file.exists()) {
          await file.delete();
        }
      }

      _currentRecordingPath = null;
      _currentDuration = Duration.zero;
      _recordingStateController.add(RecordingState.idle);

      AppLogger.info('Recording cancelled');
    } catch (e) {
      AppLogger.error('Failed to cancel recording', error: e);
    }
  }

  Future<void> pauseRecording() async {
    try {
      await _recorder.pause();
      _durationTimer?.cancel();
      _recordingStateController.add(RecordingState.paused);
    } catch (e) {
      AppLogger.error('Failed to pause recording', error: e);
    }
  }

  Future<void> resumeRecording() async {
    try {
      await _recorder.resume();
      _recordingStateController.add(RecordingState.recording);

      _durationTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) async {
        _currentDuration += const Duration(milliseconds: 100);
        _durationController.add(_currentDuration);

        final amp = await _recorder.getAmplitude();
        _amplitudeController.add(amp.current);
      });
    } catch (e) {
      AppLogger.error('Failed to resume recording', error: e);
    }
  }

  // Playback methods
  Future<void> playAudio(String url) async {
    try {
      await _player.setUrl(url);
      await _player.play();
    } catch (e) {
      AppLogger.error('Failed to play audio', error: e);
    }
  }

  Future<void> pauseAudio() async {
    await _player.pause();
  }

  Future<void> stopAudio() async {
    await _player.stop();
  }

  Future<void> seekTo(Duration position) async {
    await _player.seek(position);
  }

  Stream<Duration> get playbackPosition => _player.positionStream;
  Stream<Duration?> get playbackDuration => _player.durationStream;
  Stream<PlayerState> get playerState => _player.playerStateStream;

  Future<void> dispose() async {
    _durationTimer?.cancel();
    await _recorder.dispose();
    await _player.dispose();
    await _recordingStateController.close();
    await _durationController.close();
    await _amplitudeController.close();
  }
}

class VoiceRecordingResult {
  final File file;
  final int duration;

  const VoiceRecordingResult({
    required this.file,
    required this.duration,
  });
}
