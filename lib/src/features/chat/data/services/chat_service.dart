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

  /// Tìm user theo username hoặc displayName (chứa [query], không phân biệt hoa
  /// thường). Lọc phía client để bao được cả user doc cũ thiếu
  /// `username_lowercase` — phù hợp quy mô nhỏ của app.
  Future<List<AppUser>> searchUsersByUsername(String query) async {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return [];

    final snap = await _db.collection('users').limit(50).get();

    final results = <AppUser>[];
    for (final doc in snap.docs) {
      if (doc.id == _myUid) continue; // loại bỏ chính mình
      final data = doc.data();
      final username = (data['username'] as String? ?? '').toLowerCase();
      final displayName = (data['displayName'] as String? ?? '').toLowerCase();
      if (username.contains(q) || displayName.contains(q)) {
        results.add(_userFromDoc(doc.id, data));
      }
    }
    return results;
  }

  /// Map user doc "khoan dung": bù field thiếu ở doc cũ để không crash như
  /// `AppUser.fromMap` (vốn yêu cầu field bắt buộc).
  AppUser _userFromDoc(String id, Map<String, dynamic> data) {
    final username = data['username'] as String? ?? '';
    return AppUser(
      uid: data['uid'] as String? ?? id,
      email: data['email'] as String? ?? '',
      username: username,
      displayName: data['displayName'] as String? ?? username,
      photoURL: data['photoURL'] as String?,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
