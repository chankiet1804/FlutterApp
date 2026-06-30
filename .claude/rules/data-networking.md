# Data / networking pattern

Repository pattern over `http`. Models expose `fromApiJson` / `fromMap` factories
(see `news_model.dart`, `album_model.dart`). List screens use `infinite_scroll_pagination`
with cursor-based paging (see `NewsRepository.fetchNewsPage` + `list_news_screen.dart`).
