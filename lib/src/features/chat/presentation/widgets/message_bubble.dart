import 'package:flutter/material.dart';
import 'package:flutter_app/src/features/chat/data/models/message_model.dart';

/// Bong bóng một tin nhắn. Tin của tôi nằm phải, người kia nằm trái.
class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isMine;

  /// Chỉ tin cuối cùng của tôi mới hiển thị trạng thái "Đã xem / Đã gửi".
  final bool showStatus;
  final bool seen;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMine,
    this.showStatus = false,
    this.seen = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bubbleColor = isMine ? scheme.primary : scheme.surfaceContainerHighest;
    final textColor = isMine ? scheme.onPrimary : scheme.onSurface;

    return Column(
      crossAxisAlignment: isMine
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(message.text, style: TextStyle(color: textColor)),
        ),
        if (showStatus)
          Padding(
            padding: const EdgeInsets.only(right: 12, bottom: 4),
            child: Text(
              seen ? 'Đã xem' : 'Đã gửi',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
      ],
    );
  }
}
