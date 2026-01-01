import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

class AppLogger {
  static const String _name = 'ChatApp';

  static void debug(String message, {String? tag}) {
    if (kDebugMode) {
      developer.log(
        message,
        name: tag ?? _name,
        level: 500,
      );
    }
  }

  static void info(String message, {String? tag}) {
    if (kDebugMode) {
      developer.log(
        message,
        name: tag ?? _name,
        level: 800,
      );
    }
  }

  static void warning(String message, {String? tag}) {
    if (kDebugMode) {
      developer.log(
        '⚠️ $message',
        name: tag ?? _name,
        level: 900,
      );
    }
  }

  static void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      '❌ $message',
      name: tag ?? _name,
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void network(String message, {String? tag}) {
    if (kDebugMode) {
      developer.log(
        '🌐 $message',
        name: tag ?? '$_name/Network',
        level: 500,
      );
    }
  }

  static void firebase(String message, {String? tag}) {
    if (kDebugMode) {
      developer.log(
        '🔥 $message',
        name: tag ?? '$_name/Firebase',
        level: 500,
      );
    }
  }
}
