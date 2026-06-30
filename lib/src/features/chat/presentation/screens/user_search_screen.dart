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
  bool _searched = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _search(String query) async {
    if (query.trim().isEmpty) return;
    // Xóa kết quả cũ để không hiển thị dữ liệu lỗi thời khi đang tìm lại.
    setState(() {
      _loading = true;
      _searched = true;
      _results = [];
    });
    try {
      final users = await _service.searchUsersByUsername(query);
      if (mounted) setState(() => _results = users);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tìm kiếm thất bại. Hãy thử lại.')),
        );
      }
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
    final scheme = Theme.of(context).colorScheme;

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
                hintText: 'Nhập tên hoặc username...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: scheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () => _search(_controller.text),
                ),
              ),
            ),
          ),
          if (_loading) const LinearProgressIndicator(),
          Expanded(child: _buildBody(scheme)),
        ],
      ),
    );
  }

  Widget _buildBody(ColorScheme scheme) {
    if (!_searched) {
      return _hint(
        scheme,
        Icons.person_search_outlined,
        'Nhập tên hoặc username để tìm người trò chuyện.',
      );
    }
    if (!_loading && _results.isEmpty) {
      return _hint(
        scheme,
        Icons.search_off,
        'Không tìm thấy người dùng nào.',
      );
    }
    return ListView.builder(
      itemCount: _results.length,
      itemBuilder: (context, index) {
        final user = _results[index];
        return ListTile(
          leading: CircleAvatar(
            radius: 24,
            backgroundColor: scheme.primaryContainer,
            backgroundImage:
                user.photoURL != null ? NetworkImage(user.photoURL!) : null,
            child: user.photoURL == null
                ? Text(
                    user.username.isNotEmpty
                        ? user.username[0].toUpperCase()
                        : '?',
                    style: TextStyle(
                      color: scheme.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                : null,
          ),
          title: Text(
            user.displayName.isNotEmpty ? user.displayName : user.username,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text('@${user.username}'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _openChat(user),
        );
      },
    );
  }

  Widget _hint(ColorScheme scheme, IconData icon, String text) {
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
