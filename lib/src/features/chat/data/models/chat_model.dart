import 'package:cloud_firestore/cloud_firestore.dart';

/// Metadata của một cuộc hội thoại 1-1 trong collection `chats`.
///
/// `id` (chatId) được tạo cố định từ 2 uid đã sort: `sort(uidA, uidB).join("_")`,
/// nhờ vậy 2 người luôn map vào đúng một document duy nhất.
class Chat {
  final String id;
  final List<String> participants;
  final String lastMessage;
  final DateTime? lastMessageAt;
  final String lastSenderId;
  final Map<String, int> unreadCount;
  final Map<String, DateTime> lastReadAt;

  Chat({
    required this.id,
    required this.participants,
    required this.lastMessage,
    required this.lastMessageAt,
    required this.lastSenderId,
    required this.unreadCount,
    required this.lastReadAt,
  });

  /// Tạo chatId cố định từ 2 uid.
  static String buildId(String uidA, String uidB) {
    final ids = [uidA, uidB]..sort();
    return '${ids[0]}_${ids[1]}';
  }

  /// uid của người còn lại trong cuộc chat 1-1.
  String otherUid(String myUid) =>
      participants.firstWhere((u) => u != myUid, orElse: () => myUid);

  int unreadFor(String uid) => unreadCount[uid] ?? 0;

  factory Chat.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final map = doc.data() ?? {};
    return Chat(
      id: doc.id,
      participants: List<String>.from(map['participants'] ?? const []),
      lastMessage: map['lastMessage'] as String? ?? '',
      lastMessageAt: (map['lastMessageAt'] as Timestamp?)?.toDate(),
      lastSenderId: map['lastSenderId'] as String? ?? '',
      unreadCount: Map<String, int>.from(map['unreadCount'] ?? const {}),
      // serverTimestamp có thể chưa resolve (null) trong snapshot local -> bỏ qua.
      lastReadAt: {
        for (final e
            in (map['lastReadAt'] as Map<String, dynamic>? ?? const {}).entries)
          if (e.value is Timestamp) e.key: (e.value as Timestamp).toDate(),
      },
    );
  }
}
