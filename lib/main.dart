import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'core/di/injection.dart';
import 'firebase_options.dart';

void _validateFirebaseConfig() {
  final requiredEnvVars = defaultTargetPlatform == TargetPlatform.iOS
      ? [
          'FIREBASE_IOS_API_KEY',
          'FIREBASE_ANDROID_CLIENT_ID',
          'FIREBASE_IOS_CLIENT_ID',
        ]
      : ['FIREBASE_ANDROID_API_KEY'];

  for (final envVar in requiredEnvVars) {
    if (const String.fromEnvironment('FIREBASE_ANDROID_API_KEY').isEmpty &&
        envVar == 'FIREBASE_ANDROID_API_KEY') {
      throw StateError(
        'Missing required environment variable: $envVar. '
        'Run with: flutter run --dart-define=$envVar=your_value',
      );
    }
    if (const String.fromEnvironment('FIREBASE_IOS_API_KEY').isEmpty &&
        envVar == 'FIREBASE_IOS_API_KEY') {
      throw StateError(
        'Missing required environment variable: $envVar. '
        'Run with: flutter run --dart-define=$envVar=your_value',
      );
    }
    if (const String.fromEnvironment('FIREBASE_ANDROID_CLIENT_ID').isEmpty &&
        envVar == 'FIREBASE_ANDROID_CLIENT_ID') {
      throw StateError(
        'Missing required environment variable: $envVar. '
        'Run with: flutter run --dart-define=$envVar=your_value',
      );
    }
    if (const String.fromEnvironment('FIREBASE_IOS_CLIENT_ID').isEmpty &&
        envVar == 'FIREBASE_IOS_CLIENT_ID') {
      throw StateError(
        'Missing required environment variable: $envVar. '
        'Run with: flutter run --dart-define=$envVar=your_value',
      );
    }
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Validate Firebase configuration
  _validateFirebaseConfig();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize dependencies
  await configureDependencies();

  runApp(const ConvoApp());
}
