import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_app/src/features/widget_catalog/data/models/album_model.dart';

class AlbumRepository {
  Future<Album> fetchAlbum() async {
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/albums/1'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print('Response body: ${response.body}');
      return Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}
