import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/features/chat/data/models/chat_model.dart';
import 'package:flutter_app/src/features/chat/data/services/chat_service.dart';
import 'package:flutter_app/src/features/chat/presentation/screens/chat_room_screen.dart';
import 'package:flutter_app/src/features/chat/presentation/screens/user_search_screen.dart';
import 'package:flutter_app/src/features/chat/presentation/widgets/chat_tile.dart';

/// Danh sách hội thoại (inbox).
class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = ChatService();
    final myUid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: const Text('Tin nhắn')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute<void>(builder: (_) => const UserSearchScreen()),
        ),
        child: const Icon(Icons.add_comment),
      ),
      body: StreamBuilder<List<Chat>>(
        stream: service.streamMyChats(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Đã có lỗi xảy ra'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final chats = snapshot.data!;
          if (chats.isEmpty) {
            return const Center(
              child: Text('Chưa có cuộc trò chuyện nào.\nNhấn + để bắt đầu.'),
            );
          }

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index];
              return ChatTile(
                chat: chat,
                myUid: myUid,
                onTap: (otherName) => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => ChatRoomScreen(
                      otherUid: chat.otherUid(myUid),
                      otherName: otherName,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
