import 'package:flutter/material.dart';
import 'package:flutter_app/src/features/chat/data/services/chat_service.dart';
import 'package:flutter_app/src/features/chat/presentation/screens/chat_room_screen.dart';
import 'package:flutter_app/src/models/app_user.dart';

/// Tìm user theo username để bắt đầu một cuộc chat mới.
class UserSearchScreen extends StatefulWidget {
  const UserSearchScreen({super.key});

  @override
  State<UserSearchScreen> createState() => _UserSearchScreenState();
}

class _UserSearchScreenState extends State<UserSearchScreen> {
  final _service = ChatService();
  final _controller = TextEditingController();
  List<AppUser> _results = [];
  bool _loading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _search(String query) async {
    // Xóa kết quả cũ để không hiển thị dữ liệu lỗi thời khi đang tìm lại.
    setState(() {
      _loading = true;
      _results = [];
    });
    try {
      final users = await _service.searchUsersByUsername(query);
      if (mounted) setState(() => _results = users);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _openChat(AppUser user) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(
        builder: (_) => ChatRoomScreen(
          otherUid: user.uid,
          otherName: user.displayName.isNotEmpty
              ? user.displayName
              : user.username,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tìm người để chat')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _controller,
              autofocus: true,
              textInputAction: TextInputAction.search,
              onSubmitted: _search,
              decoration: InputDecoration(
                hintText: 'Nhập username...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () => _search(_controller.text),
                ),
              ),
            ),
          ),
          if (_loading) const LinearProgressIndicator(),
          Expanded(
            child: ListView.builder(
              itemCount: _results.length,
              itemBuilder: (context, index) {
                final user = _results[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: user.photoURL != null
                        ? NetworkImage(user.photoURL!)
                        : null,
                    child: user.photoURL == null
                        ? Text(user.username.isNotEmpty
                            ? user.username[0].toUpperCase()
                            : '?')
                        : null,
                  ),
                  title: Text(user.displayName),
                  subtitle: Text('@${user.username}'),
                  onTap: () => _openChat(user),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
