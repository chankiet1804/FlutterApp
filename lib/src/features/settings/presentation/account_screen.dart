import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  // In the constructor, require a title.
  const AccountScreen({super.key, required this.title});

  // Declare a field that holds the title.
  final String title;

  @override
  Widget build(BuildContext context) {
    // Use the title to create the UI.
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text('This is the detail view for $title'),
      ),
    );
  }
}
