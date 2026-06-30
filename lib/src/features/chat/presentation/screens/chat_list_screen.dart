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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute<void>(builder: (_) => const UserSearchScreen()),
        ),
        icon: const Icon(Icons.edit_outlined),
        label: const Text('Tin nhắn mới'),
      ),
      body: StreamBuilder<List<Chat>>(
        stream: service.streamMyChats(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            // Log lỗi thật ra terminal để trace (StreamBuilder nuốt mất nguyên nhân).
            debugPrint('streamMyChats error: ${snapshot.error}');
            debugPrintStack(stackTrace: snapshot.stackTrace);
            return _CenteredState(
              icon: Icons.error_outline,
              title: 'Đã có lỗi xảy ra',
              subtitle: 'Không tải được danh sách trò chuyện.',
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final chats = snapshot.data!;
          if (chats.isEmpty) {
            return const _CenteredState(
              icon: Icons.forum_outlined,
              title: 'Chưa có cuộc trò chuyện nào',
              subtitle: 'Nhấn "Tin nhắn mới" để bắt đầu.',
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: chats.length,
            separatorBuilder: (context, index) => const Divider(
              height: 1,
              indent: 84,
              endIndent: 16,
            ),
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

/// Trạng thái rỗng / lỗi căn giữa, dùng chung cho inbox.
class _CenteredState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _CenteredState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 72, color: scheme.outline),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: TextStyle(color: scheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
