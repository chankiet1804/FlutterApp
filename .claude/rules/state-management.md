# State management

`provider` + `ChangeNotifier`. `CounterProvider` (`lib/src/state/counter_provider.dart`)
is the example: it persists its value with `shared_preferences` (`SharedPreferencesAsync`)
and is read via `context.watch`/`context.read`.
