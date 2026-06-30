// Unit test cho phần logic thuần Dart của Message model (constructor).
//
// Ghi chú: Message.fromDoc cần một DocumentSnapshot<Map<String, dynamic>>
// thật từ cloud_firestore, nhưng repo chưa có `fake_cloud_firestore` (hoặc
// mockito) trong pubspec.yaml, nên factory này KHÔNG được cover ở đây theo
// đúng yêu cầu "không tự ý thêm dependency". Cần bổ sung fake_cloud_firestore
// để test fromDoc trong tương lai.

import 'package:flutter_app/src/features/chat/data/models/message_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Message constructor', () {
    test('type mặc định là "text" khi không truyền vào', () {
      final message = Message(
        id: 'msg1',
        senderId: 'uidA',
        text: 'hello',
        createdAt: DateTime(2026, 6, 30),
      );

      expect(message.type, 'text');
    });

    test('createdAt có thể null (tin pending vừa gửi, server chưa resolve)', () {
      final message = Message(
        id: 'msg1',
        senderId: 'uidA',
        text: 'hello',
        createdAt: null,
      );

      expect(message.createdAt, isNull);
    });

    test('giữ nguyên type tùy chỉnh khi được truyền vào', () {
      final message = Message(
        id: 'msg1',
        senderId: 'uidA',
        text: '',
        createdAt: null,
        type: 'image',
      );

      expect(message.type, 'image');
    });

    test('text rỗng vẫn tạo được Message hợp lệ (validate empty là việc của ChatService.sendMessage)', () {
      final message = Message(
        id: 'msg1',
        senderId: 'uidA',
        text: '',
        createdAt: null,
      );

      expect(message.text, isEmpty);
    });
  });
}
