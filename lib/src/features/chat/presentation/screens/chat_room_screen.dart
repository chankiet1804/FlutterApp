import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/features/chat/data/models/chat_model.dart';
import 'package:flutter_app/src/features/chat/data/models/message_model.dart';
import 'package:flutter_app/src/features/chat/data/services/chat_service.dart';
import 'package:flutter_app/src/features/chat/presentation/widgets/chat_input.dart';
import 'package:flutter_app/src/features/chat/presentation/widgets/message_bubble.dart';

/// Phòng chat 1-1 với [otherUid].
class ChatRoomScreen extends StatefulWidget {
  final String otherUid;
  final String otherName;

  const ChatRoomScreen({
    super.key,
    required this.otherUid,
    required this.otherName,
  });

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final _service = ChatService();
  late final String _myUid;
  late final String _chatId;

  // Id tin mới nhất đã được đánh dấu đọc, tránh ghi markAsRead lặp lại.
  String? _lastMarkedMsgId;

  @override
  void initState() {
    super.initState();
    _myUid = FirebaseAuth.instance.currentUser!.uid;
    _chatId = Chat.buildId(_myUid, widget.otherUid);
    // Mở phòng = đã đọc (fire-and-forget, nuốt lỗi để không tạo unhandled future).
    unawaited(_service.markAsRead(_chatId).catchError((_) {}));
  }

  Future<void> _send(String text) async {
    await _service.sendMessage(otherUid: widget.otherUid, text: text);
  }

  /// Đánh dấu đã đọc khi đối phương gửi tin mới lúc phòng đang mở.
  void _markReadIfIncoming(List<Message> messages) {
    if (messages.isEmpty) return;
    final newest = messages.first; // stream sắp xếp mới -> cũ
    if (newest.senderId == _myUid || newest.id == _lastMarkedMsgId) return;
    _lastMarkedMsgId = newest.id;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_service.markAsRead(_chatId).catchError((_) {}));
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: scheme.primaryContainer,
              child: Text(
                widget.otherName.isNotEmpty
                    ? widget.otherName[0].toUpperCase()
                    : '?',
                style: TextStyle(
                  color: scheme.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.otherName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<Chat?>(
              stream: _service.streamChat(_chatId),
              builder: (context, chatSnap) {
                final otherReadAt = chatSnap.data?.lastReadAt[widget.otherUid];

                return StreamBuilder<List<Message>>(
                  stream: _service.streamMessages(_chatId),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const _RoomMessage(
                        icon: Icons.error_outline,
                        text: 'Đã có lỗi xảy ra',
                      );
                    }
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final messages = snapshot.data!;
                    if (messages.isEmpty) {
                      return const _RoomMessage(
                        icon: Icons.chat_bubble_outline,
                        text: 'Chưa có tin nhắn.\nHãy bắt đầu trò chuyện!',
                      );
                    }

                    _markReadIfIncoming(messages);

                    // Index tin cuối cùng do tôi gửi (để gắn trạng thái đã xem).
                    final lastMineIndex = messages.indexWhere(
                      (m) => m.senderId == _myUid,
                    );

                    return ListView.builder(
                      reverse: true,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final msg = messages[index];
                        final isMine = msg.senderId == _myUid;
                        final isLastMine = index == lastMineIndex;
                        // Chỉ tính seen khi tin đã có server timestamp thật.
                        final seen = msg.createdAt != null &&
                            otherReadAt != null &&
                            !otherReadAt.isBefore(msg.createdAt!);

                        return MessageBubble(
                          message: msg,
                          isMine: isMine,
                          showStatus: isMine && isLastMine,
                          seen: seen,
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          ChatInput(onSend: _send),
        ],
      ),
    );
  }
}

/// Thông báo trạng thái căn giữa trong phòng chat (rỗng / lỗi).
class _RoomMessage extends StatelessWidget {
  final IconData icon;
  final String text;

  const _RoomMessage({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: scheme.outline),
            const SizedBox(height: 12),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(color: scheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
