import 'ansi_color.dart';
import '../level.dart';
import '../log_printer.dart';
import '../log_record.dart';

/// Output looks like this:
/// ```
/// ┌──────────────────────────
/// │ Error info
/// ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
/// │ Method stack history
/// ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
/// │ Record info
/// ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
/// │ Log message
/// └──────────────────────────
/// ```
class ConsolePrinter extends LogPrinter {
  static const topLeftCorner = '┌';
  static const bottomLeftCorner = '└';
  static const middleCorner = '├';
  static const verticalLine = '│';
  static const doubleDivider = '─';
  static const singleDivider = '┄';

  static final levelColors = {
    Level.DEBUG: AnsiColor.none(),
    Level.INFO: AnsiColor.fg(12),
    Level.WARNING: AnsiColor.fg(208),
    Level.ERROR: AnsiColor.fg(196),
  };

  static final levelNames = {
    Level.DEBUG: '🐛',
    Level.INFO: '💡',
    Level.WARNING: '⚠️',
    Level.ERROR: '⛔',
  };

  /// The index which to begin the stack trace at
  ///
  /// This can be useful if, for instance, Logger is wrapped in another class and
  /// you wish to remove these wrapped calls from stack trace
  final int lineLength;

  final int stackCount;

  String _topBorder = '';
  String _middleBorder = '';
  String _bottomBorder = '';

  ConsolePrinter({
    this.lineLength = 128,
    this.stackCount = 8,
  }) {
    var doubleDividerLine = StringBuffer();
    var singleDividerLine = StringBuffer();
    for (var i = 0; i < lineLength - 1; i++) {
      doubleDividerLine.write(doubleDivider);
      singleDividerLine.write(singleDivider);
    }

    _topBorder = '$topLeftCorner$doubleDividerLine';
    _middleBorder = '$middleCorner$singleDividerLine';
    _bottomBorder = '$bottomLeftCorner$doubleDividerLine';
  }

  @override
  void log(LogRecord record) {
    final color = _getLevelColor(record.level);
    print(color(_topBorder));

    // Error info
    if (record.error != null) {
      for (var line in record.error.toString().split('\n')) {
        print(
          color('$verticalLine $line'),
        );
      }
      print(color(_middleBorder));
    }

    // Method stack history
    if (record.stackTrace != null) {
      var count = 0;
      for (final line in record.stackTrace.toString().split('\n')) {
        print(color('$verticalLine $line'));
        if (++count == stackCount) {
          break;
        }
      }
      print(color(_middleBorder));
    }

    // Record info
    final levelName = _getLevelName(record.level);
    print(color('$verticalLine [$levelName] [${record.loggerName}] [${record.time}]'));
    print(color(_middleBorder));

    // Log message
    for (final line in record.message.split('\n')) {
      print(color('$verticalLine $line'));
    }

    print(color(_bottomBorder));
  }

  AnsiColor _getLevelColor(Level level) {
    return levelColors[level]!;
  }

  String _getLevelName(Level level) {
    return levelNames[level]!;
  }
}
