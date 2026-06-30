import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/src/features/chat/data/models/chat_model.dart';
import 'package:flutter_app/src/features/chat/data/models/message_model.dart';
import 'package:flutter_app/src/models/app_user.dart';

/// Mọi thao tác Firestore cho tính năng chat 1-1.
///
/// Cấu trúc dữ liệu:
/// - `chats/{chatId}`               metadata cuộc hội thoại (xem [Chat]).
/// - `chats/{chatId}/messages/{id}` các tin nhắn (xem [Message]).
class ChatService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String get _myUid => FirebaseAuth.instance.currentUser!.uid;

  CollectionReference<Map<String, dynamic>> get _chats =>
      _db.collection('chats');

  CollectionReference<Map<String, dynamic>> _messagesRef(String chatId) =>
      _chats.doc(chatId).collection('messages');

  /// Stream danh sách hội thoại của tôi, mới nhất lên đầu (cho màn Inbox).
  ///
  /// Cần composite index: participants (array-contains) + lastMessageAt (desc).
  Stream<List<Chat>> streamMyChats() {
    return _chats
        .where('participants', arrayContains: _myUid)
        .orderBy('lastMessageAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(Chat.fromDoc).toList());
  }

  /// Stream metadata một cuộc chat (để biết đối phương đã đọc tới đâu).
  Stream<Chat?> streamChat(String chatId) {
    return _chats.doc(chatId).snapshots().map(
          (doc) => doc.exists ? Chat.fromDoc(doc) : null,
        );
  }

  /// Stream tin nhắn của một cuộc chat, mới → cũ (cho ListView reverse).
  Stream<List<Message>> streamMessages(String chatId) {
    return _messagesRef(chatId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(Message.fromDoc).toList());
  }

  /// Gửi một tin nhắn text. Dùng batch để message + metadata luôn đồng bộ.
  Future<void> sendMessage({
    required String otherUid,
    required String text,
  }) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final chatId = Chat.buildId(_myUid, otherUid);
    final chatRef = _chats.doc(chatId);
    final msgRef = _messagesRef(chatId).doc();

    final batch = _db.batch();

    // 1) Thêm tin nhắn mới.
    batch.set(msgRef, {
      'senderId': _myUid,
      'text': trimmed,
      'createdAt': FieldValue.serverTimestamp(),
      'type': 'text',
    });

    // 2) Cập nhật metadata: preview, thời gian, tăng unread cho người nhận.
    //    Dùng merge để tự tạo document ở lần gửi đầu tiên. Chỉ chạm unread của
    //    người nhận để không reset nhầm unread của chính mình (merge map nông
    //    giữ nguyên các key khác). Reset unread của tôi là việc của markAsRead.
    batch.set(chatRef, {
      'participants': [_myUid, otherUid],
      'lastMessage': trimmed,
      'lastMessageAt': FieldValue.serverTimestamp(),
      'lastSenderId': _myUid,
      'unreadCount': {otherUid: FieldValue.increment(1)},
    }, SetOptions(merge: true));

    await batch.commit();
  }

  /// Đánh dấu đã đọc khi tôi mở phòng chat: reset unread + cập nhật lastReadAt.
  /// Một lần ghi duy nhất, không đụng tới từng tin nhắn.
  Future<void> markAsRead(String chatId) async {
    await _chats.doc(chatId).set({
      'unreadCount': {_myUid: 0},
      'lastReadAt': {_myUid: FieldValue.serverTimestamp()},
    }, SetOptions(merge: true));
  }

  /// Tìm user theo username (prefix search trên `username_lowercase`).
  Future<List<AppUser>> searchUsersByUsername(String query) async {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return [];

    // Range query [q, q + '') để tìm theo tiền tố.
    final snap = await _db
        .collection('users')
        .orderBy('username_lowercase')
        .startAt([q])
        .endAt(['$q'])
        .limit(20)
        .get();

    return snap.docs
        .map((d) => AppUser.fromMap(d.data()))
        .where((u) => u.uid != _myUid) // loại bỏ chính mình
        .toList();
  }
}
