class NewsPage {
  /// Creates a page of social news items.
  const NewsPage({required this.items, required this.nextCursor});

  /// The items returned in the page.
  final List<News> items;

  /// The cursor for the next page, or null when no more pages exist.
  final String? nextCursor;

  /// Builds a page from the full API response.
  factory NewsPage.fromApiJson(Map<String, dynamic> json) {
    final data =
        json['data'] as Map<String, dynamic>? ?? const <String, dynamic>{};
    final itemsJson = data['data'] as List<dynamic>? ?? const <dynamic>[];
    final items = itemsJson
        .whereType<Map<String, dynamic>>()
        .map(News.fromJson)
        .toList();
    final nextCursor = data['nextCursor']?.toString();

    return NewsPage(items: items, nextCursor: nextCursor);
  }
}

class News {
  /// Creates a social news item.
  const News({
    required this.socialAccount,
    required this.content,
    required this.postUrl,
    required this.externalPostId,
    required this.media,
    required this.publishedAt,
    required this.viewCount,
  });

  final SocialAccount socialAccount;
  final String content;
  final String postUrl;
  final String externalPostId;
  final List<NewsMedia> media;
  final DateTime publishedAt;
  final int viewCount;

  /// Builds a news item from JSON.
  factory News.fromJson(Map<String, dynamic> json) {
    final mediaJson = json['media'] as List<dynamic>? ?? const <dynamic>[];

    return News(
      socialAccount: SocialAccount.fromJson(
        json['socialAccount'] as Map<String, dynamic>? ??
            const <String, dynamic>{},
      ),
      content: json['content'] as String? ?? '',
      postUrl: json['postUrl'] as String? ?? '',
      externalPostId: json['externalPostId'] as String? ?? '',
      media: mediaJson
          .whereType<Map<String, dynamic>>()
          .map(NewsMedia.fromJson)
          .toList(),
      publishedAt: _parseDate(json['publishedAt']),
      viewCount: _parseInt(json['viewCount']),
    );
  }
}

class SocialAccount {
  /// Creates a social account summary.
  const SocialAccount({
    required this.username,
    required this.avatarUrl,
    required this.label,
  });

  final String username;
  final String avatarUrl;
  final String label;

  /// Builds a social account from JSON.
  factory SocialAccount.fromJson(Map<String, dynamic> json) {
    return SocialAccount(
      username: json['username'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String? ?? '',
      label: json['label'] as String? ?? '',
    );
  }
}

class NewsMedia {
  /// Creates a media item.
  const NewsMedia({required this.type, required this.url});

  final String type;
  final String url;

  /// Builds a media item from JSON.
  factory NewsMedia.fromJson(Map<String, dynamic> json) {
    return NewsMedia(
      type: json['type'] as String? ?? '',
      url: json['url'] as String? ?? '',
    );
  }
}

DateTime _parseDate(Object? value) {
  if (value is String && value.isNotEmpty) {
    return DateTime.tryParse(value)?.toLocal() ?? DateTime(1970);
  }
  return DateTime(1970);
}

int _parseInt(Object? value) {
  if (value is int) {
    return value;
  }
  if (value is String) {
    return int.tryParse(value) ?? 0;
  }
  return 0;
}
