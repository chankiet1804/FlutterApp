import 'package:flutter/material.dart';
import 'package:flutter_app/src/features/chat/data/models/message_model.dart';
import 'package:flutter_app/src/features/chat/presentation/utils/time_format.dart';

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
    final metaColor = isMine
        ? scheme.onPrimary.withValues(alpha: 0.75)
        : scheme.onSurfaceVariant;

    final time =
        message.createdAt != null ? formatMessageTime(message.createdAt!) : '';
    const radius = Radius.circular(18);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
      child: Align(
        alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 9, 12, 8),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.76,
          ),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.only(
              topLeft: radius,
              topRight: radius,
              bottomLeft: isMine ? radius : const Radius.circular(4),
              bottomRight: isMine ? const Radius.circular(4) : radius,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message.text,
                style: TextStyle(color: textColor, fontSize: 15, height: 1.25),
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    time,
                    style: TextStyle(color: metaColor, fontSize: 11),
                  ),
                  if (isMine && showStatus) ...[
                    const SizedBox(width: 3),
                    Icon(
                      seen ? Icons.done_all : Icons.done,
                      size: 15,
                      color: seen ? scheme.onPrimary : metaColor,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
