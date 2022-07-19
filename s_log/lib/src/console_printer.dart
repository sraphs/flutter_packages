// ignore_for_file: avoid_print

import 'log_record.dart';

/// Outputs console log messages:
/// ```
/// [NAME] [LEVEL] [TIME] Log message
/// __________________________________
/// Error info
/// __________________________________
/// Stack trace
/// ```
class ConsolePrinter {
  const ConsolePrinter();

  void log(LogRecord record) {
    String _coloredString(String string) {
      switch (record.level.name) {
        case "DEBUG":
          // gray
          return '\u001b[90m$string\u001b[0m';
        case "INFO":
          // green
          return '\u001b[32m$string\u001b[0m';
        case "WARNING":
          // blue
          return '\u001B[34m$string\u001b[0m';
        case "ERROR":
          // red
          return '\u001b[31m$string\u001b[0m';
        default:
          // gray
          return '\u001b[90m$string\u001b[0m';
      }
    }

    String _prepareObject() {
      switch (record.level.name) {
        case "DEBUG":
          return _coloredString('[${record.loggerName}] [DEBUG] [${record.time}] ${record.message}');
        case "INFO":
          return _coloredString('[${record.loggerName}] [INFO] [${record.time}] ${record.message}');
        case "WARNING":
          return _coloredString('[${record.loggerName}] [WARNING] [${record.time}] ${record.message}');
        case "ERROR":
          return _coloredString('[${record.loggerName}] [ERROR] [${record.time}] ${record.message}');
        default:
          return _coloredString('[${record.loggerName}] [UNKNOWN] [${record.time}] ${record.message}');
      }
    }

    print(_prepareObject());

    if (record.error != null) {
      print(_coloredString('__________________________________'));
      print(_coloredString(record.error.toString()));
    }

    if (record.stackTrace != null) {
      print(_coloredString('__________________________________'));
      print(_coloredString(record.stackTrace.toString()));
    }
  }
}
