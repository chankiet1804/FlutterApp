# Commands

```bash
flutter pub get                       # Install dependencies
flutter run                           # Run on a connected device/emulator
flutter run -d chrome                 # Run on web
flutter analyze                       # Static analysis / lint (flutter_lints)
dart format .                         # Format code
flutter test                          # Run all tests
flutter test test/widget_test.dart    # Run a single test file
flutter test --name "substring"       # Run tests matching a name
```

Firebase config is generated, not hand-edited: regenerate `lib/firebase_options.dart`
with `flutterfire configure`.
