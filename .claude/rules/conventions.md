# Conventions

- Code comments in this repo are frequently in Vietnamese; match the surrounding file.
- Models that touch Firestore convert `DateTime` ⇄ `Timestamp` explicitly in
  `toMap`/`fromMap` (see `AppUser`).
