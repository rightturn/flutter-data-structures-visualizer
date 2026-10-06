import 'package:flutter/foundation.dart';

class AppLogger {
  static const String _prefix = '[DataStructures]';

  static void debug(String message, {String? tag}) {
    if (kDebugMode) {
      final tagStr = tag != null ? '[$tag]' : '';
      print('$_prefix$tagStr $message');
    }
  }

  static void info(String message, {String? tag}) {
    if (kDebugMode) {
      final tagStr = tag != null ? '[$tag]' : '';
      print('$_prefix$tagStr ℹ️ $message');
    }
  }

  static void warning(String message, {String? tag}) {
    if (kDebugMode) {
      final tagStr = tag != null ? '[$tag]' : '';
      print('$_prefix$tagStr ⚠️ $message');
    }
  }

  static void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (kDebugMode) {
      final tagStr = tag != null ? '[$tag]' : '';
      print('$_prefix$tagStr ❌ $message');
      if (error != null) {
        print('$_prefix$tagStr Error: $error');
      }
      if (stackTrace != null) {
        print('$_prefix$tagStr Stack trace: $stackTrace');
      }
    }
  }

  static void animation(String message) => debug(message, tag: 'Animation');
  static void dataStructure(String message) =>
      debug(message, tag: 'DataStructure');
  static void ui(String message) => debug(message, tag: 'UI');
  static void operation(String message) => debug(message, tag: 'Operation');
}
