import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/features/chat/data/models/chat_model.dart';
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
    final unread = widget.chat.unreadFor(widget.myUid);

    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: _userFuture,
      builder: (context, snapshot) {
        AppUser? user;
        if (snapshot.hasData && snapshot.data!.exists) {
          user = AppUser.fromMap(snapshot.data!.data()!);
        }
        final name = user?.displayName ?? user?.username ?? '...';

        return ListTile(
          leading: CircleAvatar(
            backgroundImage: (user?.photoURL != null)
                ? NetworkImage(user!.photoURL!)
                : null,
            child: (user?.photoURL == null)
                ? Text(name.isNotEmpty ? name[0].toUpperCase() : '?')
                : null,
          ),
          title: Text(name),
          subtitle: Text(
            widget.chat.lastMessage,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: unread > 0
              ? Badge(label: Text(unread > 99 ? '99+' : '$unread'))
              : null,
          onTap: () => widget.onTap(name),
        );
      },
    );
  }
}
