import 'dart:convert';

import 'package:flutter_app/src/features/widget_catalog/data/models/news_model.dart';
import 'package:http/http.dart' as http;

class NewsRepository {
  static const _baseUrl =
      'https://staging.interlinklabs.ai/api/v1/social-news/'
      'social-post-by-account';

  Future<NewsPage> fetchNewsPage({String? cursor}) async {
    final queryParameters = <String, String>{
      'username': 'all',
      'type': 'latest',
      'lang': 'en',
      'cursor': ?cursor,
    };

    final uri = Uri.parse(_baseUrl).replace(queryParameters: queryParameters);
    final response = await http.get(
      uri,
      headers: const {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return NewsPage.fromApiJson(body);
    }

    throw Exception('Failed to load news');
  }
}
