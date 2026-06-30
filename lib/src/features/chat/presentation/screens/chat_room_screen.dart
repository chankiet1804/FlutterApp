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
    return Scaffold(
      appBar: AppBar(title: Text(widget.otherName)),
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
                      return const Center(child: Text('Đã có lỗi xảy ra'));
                    }
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final messages = snapshot.data!;
                    if (messages.isEmpty) {
                      return const Center(
                        child: Text('Chưa có tin nhắn. Hãy bắt đầu trò chuyện!'),
                      );
                    }

                    _markReadIfIncoming(messages);

                    // Index tin cuối cùng do tôi gửi (để gắn trạng thái đã xem).
                    final lastMineIndex = messages.indexWhere(
                      (m) => m.senderId == _myUid,
                    );

                    return ListView.builder(
                      reverse: true,
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
