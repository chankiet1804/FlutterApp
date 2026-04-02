import 'package:flutter/material.dart';
import 'package:flutter_app/src/features/settings/presentation/account_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 48.0),
      child: Column(
        children: <Widget>[
          Card(
            child: ListTile(
              leading: Icon(Icons.person),
              title: Text('Account'),
              subtitle: Text('This is an account setting'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => const AccountScreen(title: 'Account'),
                ),
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.dark_mode),
              title: Text('Theme'),
              subtitle: Text('This is a theme setting'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => const AccountScreen(title: 'Theme'),
                ),
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.language),
              title: Text('Language'),
              subtitle: Text('This is a language setting'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => const AccountScreen(title: 'Language'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
