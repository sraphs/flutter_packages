import 'package:sraph_logger/sraph_logger.dart';

final log = Logger('ExampleLogger');

/// Example of configuring a logger to print to stdout.
///
/// This example will print:
///
/// ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
/// │ [💡] [ExampleLogger] [2022-07-20 11:01:13.550015]
/// ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
/// │ recursion: n = 4
/// └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
/// ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
/// │ [💡] [ExampleLogger] [2022-07-20 11:01:13.560492]
/// ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
/// │ recursion: n = 3
/// └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
/// Fibonacci(4) is: 3
/// Fibonacci(5) is: 5
/// ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
/// │ Exception: Unexpected negative
/// ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
/// │ #0      fibonacci (file:///home/nan/github.com/sraphs/flutter_packages/sraph_logger/example/sraph_logger_example.dart:48:100)
/// │ #1      main (file:///home/nan/github.com/sraphs/flutter_packages/sraph_logger/example/sraph_logger_example.dart:43:31)
/// │ #2      _delayEntrypointInvocation.<anonymous closure> (dart:isolate-patch/isolate_patch.dart:297:19)
/// │ #3      _RawReceivePortImpl._handleMessage (dart:isolate-patch/isolate_patch.dart:192:12)
/// ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
/// │ [⛔] [ExampleLogger] [2022-07-20 11:01:13.561669]
/// ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
/// │ Unexpected negative n: -42
/// └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
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
    if (n < 0) log.error('Unexpected negative n: $n', Exception('Unexpected negative'), StackTrace.current);
    return 1;
  } else {
    log.info('recursion: n = $n');
    return fibonacci(n - 2) + fibonacci(n - 1);
  }
}
