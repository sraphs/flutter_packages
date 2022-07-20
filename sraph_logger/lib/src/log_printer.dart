import 'log_record.dart';

/// An abstract handler of log record.
abstract class LogPrinter {
  void init() {}

  /// Is called every time a new [LogRecord] is sent and handles printing or
  /// storing the message.
  void log(LogRecord record);

  void destroy() {}
}
