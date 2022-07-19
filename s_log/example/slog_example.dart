import 'package:s_log/s_log.dart';

final log = Logger('ExampleLogger');

/// Example of configuring a logger to print to stdout.
///
/// This example will print:
///
/// [ExampleLogger] [INFO] [2022-07-19 12:57:30.380392] recursion: n = 4
/// [ExampleLogger] [INFO] [2022-07-19 12:57:30.387433] recursion: n = 3
/// Fibonacci(4) is: 3
/// Fibonacci(5) is: 5
/// [ExampleLogger] [ERROR] [2022-07-19 12:57:30.387604] Unexpected negative n: -42
/// Fibonacci(-42) is: 1
void main() {
  Logger.root.level = Level.ALL; // defaults to Level.INFO

  print('Fibonacci(4) is: ${fibonacci(4)}');

  Logger.root.level = Level.ERROR; // skip logs less then ERROR.
  print('Fibonacci(5) is: ${fibonacci(5)}');

  print('Fibonacci(-42) is: ${fibonacci(-42)}');
}

int fibonacci(int n) {
  if (n <= 2) {
    if (n < 0) log.error('Unexpected negative n: $n');
    return 1;
  } else {
    log.info('recursion: n = $n');
    return fibonacci(n - 2) + fibonacci(n - 1);
  }
}
