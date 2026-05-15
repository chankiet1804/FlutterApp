import 'package:flutter/material.dart';
import 'package:flutter_app/src/features/widget_catalog/data/models/album_model.dart';
import 'package:flutter_app/src/features/widget_catalog/data/repositories/album_repository.dart';

class HttpScreen extends StatefulWidget {
  const HttpScreen({super.key});
  @override
  State<HttpScreen> createState() => _HttpScreenState();
}

class _HttpScreenState extends State<HttpScreen> {
  late Future<Album> futureAlbum;
  final _repository = AlbumRepository(); // Khởi tạo repo

  @override
  void initState() {
    super.initState();
    futureAlbum = _repository.fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HTTP Screen')),
      body: Center(
        child: FutureBuilder<Album>(
          future: futureAlbum,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data!.title);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
