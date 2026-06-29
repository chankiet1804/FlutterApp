# Flutter App

A cross-platform **Flutter + Firebase** application featuring authentication, Cloud
Firestore, push notifications, an AI chatbot, and an interactive **widget catalog** that
showcases common Flutter patterns (animations, HTTP, cursor-based pagination, and more).

Built with Material 3 and a feature-first architecture.

## Features

- 🔐 **Authentication** — Email/Password and Google sign-in via `firebase_ui_auth`; the
  signed-in user is persisted to Firestore on sign-in/sign-up.
- ☁️ **Cloud Firestore** — user profiles stored in the `users` collection with safe,
  null-stripping merge writes.
- 🔔 **Push Notifications** — Firebase Cloud Messaging with foreground, background, and
  notification-tap handling.
- 🤖 **AI Chatbot** — powered by `firebase_ai` + `flutter_ai_toolkit`.
- 🎨 **Widget Catalog** — a demo hub showcasing buttons, progress indicators, bottom
  sheets, animations, HTTP requests, infinite-scroll pagination, and Firestore.
- 💾 **State Management** — `provider` + `ChangeNotifier`, persisted with
  `shared_preferences`.
- 🌗 **Material 3** theming with a consistent input/button style.

## Tech Stack

| Area | Packages |
|------|----------|
| Framework | Flutter (Material 3), Dart `^3.11.1` |
| Firebase | `firebase_core`, `firebase_auth`, `firebase_ui_auth`, `cloud_firestore`, `firebase_messaging`, `firebase_ai` |
| State | `provider`, `shared_preferences` |
| Networking | `http`, `infinite_scroll_pagination` |

**Supported platforms:** Android · iOS · Web · Windows · macOS · Linux

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) 3.41+ (Dart `^3.11.1`)
- A configured [Firebase](https://firebase.google.com/) project
- [FlutterFire CLI](https://firebase.google.com/docs/flutter/setup): `dart pub global activate flutterfire_cli`

### Setup

```bash
# 1. Clone the repository
git clone https://github.com/chankiet1804/FlutterApp.git
cd FlutterApp

# 2. Install dependencies
flutter pub get

# 3. Generate Firebase config (creates lib/firebase_options.dart)
flutterfire configure

# 4. Run the app
flutter run
```

> **Note:** Firebase config in `lib/firebase_options.dart` is generated — do not edit it by
> hand; regenerate with `flutterfire configure`. The Google OAuth client ID lives in
> `lib/main.dart`.

## Commands

```bash
flutter run                           # Run on a connected device/emulator
flutter run -d chrome                 # Run on web
flutter analyze                       # Static analysis / lint
dart format .                         # Format code
flutter test                          # Run all tests
flutter test test/widget_test.dart    # Run a single test file
```

## Architecture

The codebase follows a **feature-first** layout under `lib/src/`.

```
lib/
├── main.dart                 # Entry point: Firebase init + root provider
└── src/
    ├── screens/              # App shell: MyApp → AuthGate
    ├── widgets/              # Shared widgets (e.g. BottomNavigation)
    ├── services/             # UserService, FCMService
    ├── models/               # AppUser, ...
    ├── state/                # CounterProvider (ChangeNotifier)
    └── features/             # Feature modules (home, settings, widget_catalog)
        └── <feature>/
            ├── data/         # models, repositories, services
            └── presentation/ # screens, widgets
```

**Bootstrap flow:** `main.dart` → `MyApp` → `AuthGate` → `BottomNavigation`.
`AuthGate` is the auth boundary: it shows the sign-in screen when signed out and the main
tabbed navigation (Home · Widgets · Settings) when signed in.

## Testing

```bash
flutter test
```

Widget tests live under `test/`.
