# Sraph Cache

[![pub package](https://img.shields.io/pub/v/sraph_cache.svg)](https://pub.dev/packages/sraph_cache)

Base on [shared_preferences](https://pub.dev/packages/shared_preferences) and add listenable cache.

## Usage
To use this plugin, add `sraph_cache` as a [dependency in your pubspec.yaml file](https://flutter.dev/docs/development/platform-integration/platform-channels).

### Examples
Here are small examples that show you how to use the API.

#### Write data
```dart
// init Cache.
await Cache.ensureInitialized();

// Save an integer value to 'counter' key.
await Cache.set<int>('counter', 10);
// Save an boolean value to 'repeat' key.
await Cache.set<bool>('repeat', true);
// Save an double value to 'decimal' key.
await Cache.set<double>('decimal', 1.5);
// Save an String value to 'action' key.
await Cache.set<String>('action', 'Start');
// Save an list of strings to 'items' key.
await Cache.set<List<String>>('items', <String>['Earth', 'Moon', 'Sun']);
```

#### Read data
```dart
// Try reading data from the 'counter' key. If it doesn't exist, returns null.
final int? counter = Cache.get<int>('counter');
// Try reading data from the 'repeat' key. If it doesn't exist, returns null.
final bool? repeat = Cache.get<bool>('repeat');
// Try reading data from the 'decimal' key. If it doesn't exist, returns null.
final double? decimal = Cache.get<double>('decimal');
// Try reading data from the 'action' key. If it doesn't exist, returns null.
final String? action = Cache.get<String>('action');
// Try reading data from the 'items' key. If it doesn't exist, returns null.
final List<String>? items = Cache.get<List<String>>('items');
```

#### Remove an entry
```dart
// Remove data for the 'counter' key.
final success = await Cache.remove('counter');
```

#### Listen to changes
```dart
return ValueListenableBuilder(
    valueListenable: Cache.listenable(),
    builder: (context, _, child) {
    ...
    },
);
```
