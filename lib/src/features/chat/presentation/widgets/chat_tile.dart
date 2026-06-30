import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/features/chat/data/models/chat_model.dart';
import 'package:flutter_app/src/features/chat/presentation/utils/time_format.dart';
import 'package:flutter_app/src/models/app_user.dart';

/// Một dòng trong danh sách hội thoại (inbox).
///
/// Tải thông tin người còn lại từ collection `users` theo otherUid và cache
/// lại Future để không gọi `.get()` mỗi lần inbox rebuild (mỗi tin nhắn mới).
class ChatTile extends StatefulWidget {
  final Chat chat;
  final String myUid;

  /// Trả về tên đã resolve để màn hình mở phòng chat đúng tiêu đề.
  final void Function(String otherName) onTap;

  const ChatTile({
    super.key,
    required this.chat,
    required this.myUid,
    required this.onTap,
  });

  @override
  State<ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {
  late Future<DocumentSnapshot<Map<String, dynamic>>> _userFuture;
  late String _otherUid;

  @override
  void initState() {
    super.initState();
    _otherUid = widget.chat.otherUid(widget.myUid);
    _userFuture = _fetchUser();
  }

  @override
  void didUpdateWidget(ChatTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newOther = widget.chat.otherUid(widget.myUid);
    // Chỉ tải lại khi đối phương đổi (thực tế hiếm xảy ra trên cùng 1 tile).
    if (newOther != _otherUid) {
      _otherUid = newOther;
      _userFuture = _fetchUser();
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> _fetchUser() {
    return FirebaseFirestore.instance.collection('users').doc(_otherUid).get();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final chat = widget.chat;
    final unread = chat.unreadFor(widget.myUid);
    final hasUnread = unread > 0;

    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: _userFuture,
      builder: (context, snapshot) {
        AppUser? user;
        if (snapshot.hasData && snapshot.data!.exists) {
          user = AppUser.fromMap(snapshot.data!.data()!);
        }
        final name = user?.displayName ?? user?.username ?? '...';

        // Preview: thêm "Bạn: " khi tin cuối do tôi gửi.
        final mineLast = chat.lastSenderId == widget.myUid;
        final preview = chat.lastMessage.isEmpty
            ? 'Chưa có tin nhắn'
            : (mineLast ? 'Bạn: ${chat.lastMessage}' : chat.lastMessage);

        final time = chat.lastMessageAt != null
            ? formatChatListTime(chat.lastMessageAt!)
            : '';

        return ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: CircleAvatar(
            radius: 26,
            backgroundColor: scheme.primaryContainer,
            backgroundImage: (user?.photoURL != null)
                ? NetworkImage(user!.photoURL!)
                : null,
            child: (user?.photoURL == null)
                ? Text(
                    name.isNotEmpty ? name[0].toUpperCase() : '?',
                    style: TextStyle(
                      color: scheme.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                : null,
          ),
          title: Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            preview,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: hasUnread ? scheme.onSurface : scheme.onSurfaceVariant,
              fontWeight: hasUnread ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (time.isNotEmpty)
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    color: hasUnread ? scheme.primary : scheme.onSurfaceVariant,
                    fontWeight: hasUnread ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              const SizedBox(height: 6),
              if (hasUnread)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: scheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  constraints: const BoxConstraints(minWidth: 22),
                  child: Text(
                    unread > 99 ? '99+' : '$unread',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: scheme.onPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              else
                const SizedBox(height: 18),
            ],
          ),
          onTap: () => widget.onTap(name),
        );
      },
    );
  }
}
