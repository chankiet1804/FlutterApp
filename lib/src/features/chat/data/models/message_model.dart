import 'package:cloud_firestore/cloud_firestore.dart';

/// Một tin nhắn trong subcollection `chats/{chatId}/messages`.
///
/// `createdAt` có thể `null` khi `serverTimestamp` chưa được server resolve
/// (tin pending vừa gửi). Logic hiển thị phải xử lý trường hợp null này.
class Message {
  final String id;
  final String senderId;
  final String text;
  final DateTime? createdAt;
  final String type; // "text" (mở rộng sau: image, file...)

  Message({
    required this.id,
    required this.senderId,
    required this.text,
    required this.createdAt,
    this.type = 'text',
  });

  factory Message.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final map = doc.data() ?? {};
    return Message(
      id: doc.id,
      senderId: map['senderId'] as String? ?? '',
      text: map['text'] as String? ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
      type: map['type'] as String? ?? 'text',
    );
  }
}
