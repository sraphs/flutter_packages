// ignore_for_file: constant_identifier_names

class Level implements Comparable<Level> {
  final String name;
  final int value;

  const Level._(this.name, this.value);

  /// Special key to turn on logging for all levels ([value] = 0).
  static const Level ALL = Level._('ALL', 0);

  /// Special key to turn off all logging ([value] = 2000).
  static const Level OFF = Level._('OFF', 2000);

  /// Key for highly detailed tracing ([value] = 100).
  static const Level DEBUG = Level._('DEBUG', 100);

  /// Key for informational messages ([value] = 200).
  static const Level INFO = Level._('INFO', 200);

  /// Key for potential problems ([value] = 300).
  static const Level WARNING = Level._('WARNING', 300);

  /// Key for serious failures ([value] = 400).
  static const Level ERROR = Level._('ERROR', 400);

  static const List<Level> LEVELS = [
    ALL,
    DEBUG,
    INFO,
    WARNING,
    ERROR,
    OFF,
  ];

  @override
  bool operator ==(Object other) => other is Level && value == other.value;

  bool operator <(Level other) => value < other.value;

  bool operator <=(Level other) => value <= other.value;

  bool operator >(Level other) => value > other.value;

  bool operator >=(Level other) => value >= other.value;

  @override
  int compareTo(Level other) => value - other.value;

  @override
  int get hashCode => value;

  @override
  String toString() => name;

  Level fromString(String name) {
    switch (name.toUpperCase()) {
      case 'ALL':
        return ALL;
      case 'OFF':
        return OFF;
      case 'DEBUG':
        return DEBUG;
      case 'INFO':
        return INFO;
      case 'WARNING':
        return WARNING;
      case 'ERROR':
        return ERROR;
    }

    return OFF;
  }
}
