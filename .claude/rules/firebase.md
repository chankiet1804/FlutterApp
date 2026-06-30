# Firebase usage

- **Auth**: `firebase_auth` + `firebase_ui_auth` + `firebase_ui_oauth_google`. The Google
  OAuth `clientId` is a constant in `main.dart`.
- **Firestore**: `UserService` (`lib/src/services/user_service.dart`) writes the `users`
  collection. `setAppUser` strips `null` fields and uses `SetOptions(merge: true)` so
  partial writes don't clobber existing data. (`set_user`/`get_city` are leftover demo
  methods — prefer `setAppUser`.)
- **FCM**: `FCMService` (`lib/src/services/fcm_service.dart`) handles permission, token,
  foreground messages, and notification taps. Background handler is in `main.dart`.
- **Firebase AI**: `firebase_ai` + `flutter_ai_toolkit` power the chatbot screen.
