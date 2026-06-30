import 'package:flutter/material.dart';
import 'package:flutter_app/src/features/chat/presentation/screens/chat_list_screen.dart';
import 'package:flutter_app/src/features/widget_catalog/presentation/screens/animations_screen.dart';
import 'package:flutter_app/src/features/widget_catalog/presentation/screens/firebase_chatbot_screen.dart';
import 'package:flutter_app/src/features/widget_catalog/presentation/screens/firestore_screen.dart';
import 'package:flutter_app/src/features/widget_catalog/presentation/screens/list_news_screen.dart';
import 'package:flutter_app/src/features/widget_catalog/presentation/screens/modal_bottom_sheet_screen.dart';
import 'package:flutter_app/src/features/widget_catalog/presentation/screens/button_screen.dart';
import 'package:flutter_app/src/features/widget_catalog/presentation/screens/progress_indicator_screen.dart';
import 'package:flutter_app/src/features/widget_catalog/presentation/screens/http_screen.dart';

class WidgetsScreen extends StatelessWidget {
  const WidgetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> data = [
      Card(
        child: ListTile(
          leading: const Icon(Icons.chat),
          title: const Text('Chat'),
          subtitle: const Text('Tap to open chat screen'),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) => const ChatListScreen(),
            ),
          ),
        ),
      ),
      Card(
        child: ListTile(
          leading: Icon(Icons.check_box_outline_blank),
          title: Text('Buttons'),
          subtitle: Text('Tap to open button screen'),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute<void>(builder: (context) => const ButtonScreen()),
          ),
        ),
      ),
      Card(
        child: ListTile(
          leading: Icon(Icons.moving),
          title: Text('Progress Indicators'),
          subtitle: Text('Tap to open progress indicators screen'),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) => const ProgressIndicatorScreen(),
            ),
          ),
        ),
      ),
      Card(
        child: ListTile(
          leading: Icon(Icons.border_bottom_sharp),
          title: Text('BottomSheet'),
          subtitle: Text('Tap to open bottom sheet screen'),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) => const ModalBottomSheetScreen(),
            ),
          ),
        ),
      ),
      Card(
        child: ListTile(
          leading: Icon(Icons.chat_bubble_outline),
          title: Text('Chatbot Screen'),
          subtitle: Text('Tap to open firebase chatbot screen'),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute<void>(builder: (context) => const ChatPage()),
          ),
        ),
      ),
      Card(
        child: ListTile(
          leading: Icon(Icons.network_check),
          title: Text('HTTP Screen'),
          subtitle: Text('Tap to open HTTP screen'),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute<void>(builder: (context) => const HttpScreen()),
          ),
        ),
      ),
      Card(
        child: ListTile(
          leading: Icon(Icons.newspaper),
          title: Text('List News Screen'),
          subtitle: Text('Tap to open list news screen'),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) => const ListNewsScreen(),
            ),
          ),
        ),
      ),
      Card(
        child: ListTile(
          leading: Icon(Icons.animation),
          title: Text('Animations Screen'),
          subtitle: Text('Tap to open animations screen'),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) => const AnimationsScreen(),
            ),
          ),
        ),
      ),
      Card(
        child: ListTile(
          leading: Icon(Icons.miscellaneous_services),
          title: Text('Firestore Screen'),
          subtitle: Text('Tap to open firestore screen'),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) => const FirestoreScreen(),
            ),
          ),
        ),
      ),
    ];
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return data[index];
      },
    );
  }
}
