## Initializing

By default, the logging package does not do anything useful with the log
messages. You must configure the logging level.

```dart
Logger.root.level = Level.ALL; // defaults to Level.INFO
```

First, set the root `Level`. All messages at or above the current level are sent to the
`onRecord` stream. Available levels are:

+ `Level.OFF`
+ `Level.DEBUG`
+ `Level.INFO`
+ `Level.WARNING`
+ `Level.ERROR`

Then, listen on the `onRecord` stream for `LogRecord` events. The `LogRecord`
class has various properties for the message, error, logger name, and more.

## Logging messages

Create a `Logger` with a unique name to easily identify the source of the log
messages.

```dart
final log = Logger('MyClassName');
```

Here is an example of logging a debug message and an error:

```dart
var future = doSomethingAsync().then((result) {
  log.debug('Got the result: $result');
  processResult(result);
}).catchError((e, stackTrace) => log.severe('Oh noes!', e, stackTrace));
```

When logging more complex messages, you can pass a closure instead that will be
evaluated only if the message is actually logged:

```dart
log.debug(() => [1, 2, 3, 4, 5].map((e) => e * 4).join("-"));
```

Available logging methods are:

+ `log.debug(logged_content);`
+ `log.info(logged_content);`
+ `log.warning(logged_content);`
+ `log.error(logged_content);`
