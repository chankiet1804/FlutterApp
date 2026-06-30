# Architecture

Flutter (Material 3, Dart SDK ^3.11.1) app backed by Firebase. The codebase follows a
**feature-first** layout under `lib/src/`.

## App bootstrap
`lib/main.dart` → `MyApp` (`lib/src/screens/app.dart`) → `AuthGate`
(`lib/src/screens/auth_gate.dart`) → `BottomNavigation` (`lib/src/widgets/bottom_navigation.dart`).

- `main()` initializes Firebase, registers the FCM background handler, and wraps the app
  in a single root `ChangeNotifierProvider<CounterProvider>`.
- `AuthGate` is the auth boundary: a `StreamBuilder` on `FirebaseAuth.authStateChanges()`
  shows `firebase_ui_auth`'s `SignInScreen` (Email + Google) when signed out, and
  `BottomNavigation` when signed in. On sign-in/sign-up it persists an `AppUser` to
  Firestore via `UserService`.
- `BottomNavigation` hosts the three top-level tabs: **Home**, **Widgets**, **Settings**.
- App-wide theming (input/button rounding, color scheme) lives in `app.dart`.

## Feature structure
Each feature lives in `lib/src/features/<feature>/` split into:
- `data/` — `models/`, `repositories/`, `services/`
- `presentation/` — `screens/`, `widgets/`

`widget_catalog` is the largest feature and acts as a **demo/showcase hub**: its
`widgets_screen.dart` is a list of cards, each `Navigator.push`-ing to a screen that
demonstrates one concept (buttons, animations, HTTP, pagination, Firestore, chatbot, etc.).
When adding a new demo, add the screen under `widget_catalog/presentation/screens/` and a
card entry in `widgets_screen.dart`.

Note: some shared/root code (`screens/`, `widgets/`, `services/`, `models/`, `state/`)
sits directly under `lib/src/` rather than inside a feature — keep cross-feature code there.
