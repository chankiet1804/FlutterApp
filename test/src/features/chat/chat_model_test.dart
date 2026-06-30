// Unit test cho phần logic thuần Dart của Chat model
// (Chat.buildId / otherUid / unreadFor).
//
// Ghi chú: Chat.fromDoc / Message.fromDoc cần một
// DocumentSnapshot<Map<String, dynamic>> thật từ cloud_firestore, nhưng repo
// chưa có `fake_cloud_firestore` (hoặc mockito) trong pubspec.yaml, nên các
// factory này KHÔNG được cover ở đây theo đúng yêu cầu "không tự ý thêm
// dependency". Cần bổ sung fake_cloud_firestore để test fromDoc trong tương lai.

import 'package:flutter_app/src/features/chat/data/models/chat_model.dart';
import 'package:flutter_test/flutter_test.dart';

Chat _buildChat({
  required String id,
  required List<String> participants,
  Map<String, int> unreadCount = const {},
}) {
  return Chat(
    id: id,
    participants: participants,
    lastMessage: 'hello',
    lastMessageAt: DateTime(2026, 6, 30),
    lastSenderId: participants.isNotEmpty ? participants.first : '',
    unreadCount: unreadCount,
    lastReadAt: const {},
  );
}

void main() {
  group('Chat.buildId', () {
    test('trả về cùng 1 chatId bất kể thứ tự 2 uid truyền vào', () {
      final idAB = Chat.buildId('uidA', 'uidB');
      final idBA = Chat.buildId('uidB', 'uidA');

      expect(idAB, idBA);
    });

    test('chatId được nối từ 2 uid đã sort tăng dần, ngăn cách bởi "_"', () {
      final id = Chat.buildId('zoe', 'alice');

      expect(id, 'alice_zoe');
    });

    test('2 cặp uid khác nhau cho ra 2 chatId khác nhau', () {
      final id1 = Chat.buildId('uidA', 'uidB');
      final id2 = Chat.buildId('uidA', 'uidC');

      expect(id1, isNot(equals(id2)));
    });

    test('uid trùng nhau (tự chat với chính mình) vẫn cho id hợp lệ', () {
      final id = Chat.buildId('uidA', 'uidA');

      expect(id, 'uidA_uidA');
    });
  });

  group('Chat.otherUid', () {
    test('trả về đúng uid của người còn lại trong cuộc chat 1-1', () {
      final chat = _buildChat(
        id: 'a_b',
        participants: ['uidA', 'uidB'],
      );

      expect(chat.otherUid('uidA'), 'uidB');
      expect(chat.otherUid('uidB'), 'uidA');
    });

    test(
      'myUid không nằm trong participants -> trả về phần tử đầu tiên '
      '(firstWhere match mọi uid != myUid, orElse không được gọi tới)',
      () {
        final chat = _buildChat(
          id: 'a_b',
          participants: ['uidA', 'uidB'],
        );

        // 'uidX' không có trong participants nên cả 'uidA' và 'uidB' đều
        // thoả điều kiện `u != myUid` -> firstWhere trả về phần tử đầu tiên.
        expect(chat.otherUid('uidX'), 'uidA');
      },
    );

    test(
      'participants chỉ có 1 uid trùng myUid -> orElse trả về chính myUid',
      () {
        final chat = _buildChat(id: 'a_a', participants: ['uidA']);

        // Phần tử duy nhất bằng myUid nên firstWhere không match ->
        // orElse trả về chính myUid.
        expect(chat.otherUid('uidA'), 'uidA');
      },
    );
  });

  group('Chat.unreadFor', () {
    test('trả về 0 khi uid không tồn tại trong unreadCount', () {
      final chat = _buildChat(
        id: 'a_b',
        participants: ['uidA', 'uidB'],
        unreadCount: const {'uidA': 3},
      );

      expect(chat.unreadFor('uidB'), 0);
    });

    test('trả về đúng số lượng tin chưa đọc khi key tồn tại', () {
      final chat = _buildChat(
        id: 'a_b',
        participants: ['uidA', 'uidB'],
        unreadCount: const {'uidA': 0, 'uidB': 5},
      );

      expect(chat.unreadFor('uidB'), 5);
    });

    test('unreadCount rỗng -> luôn trả về 0', () {
      final chat = _buildChat(
        id: 'a_b',
        participants: ['uidA', 'uidB'],
      );

      expect(chat.unreadFor('uidA'), 0);
    });
  });
}
