// Unit test cho helper định dạng thời gian chat (formatMessageTime /
// formatChatListTime). Logic thuần Dart, không phụ thuộc Firebase.
//
// Mọi mốc thời gian được tính tương đối với DateTime.now() để test không phụ
// thuộc vào ngày giờ chạy thật (tránh flaky theo ngày trong tuần / cuối tháng).

import 'package:flutter_app/src/features/chat/presentation/utils/time_format.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('formatMessageTime', () {
    test('trả về giờ:phút dạng HH:mm, có padding số 0', () {
      final dt = DateTime(2026, 6, 30, 9, 5);

      expect(formatMessageTime(dt), '09:05');
    });

    test('giờ phút 2 chữ số giữ nguyên', () {
      final dt = DateTime(2026, 6, 30, 23, 59);

      expect(formatMessageTime(dt), '23:59');
    });

    test('biên đầu ngày 00:00', () {
      final dt = DateTime(2026, 6, 30, 0, 0);

      expect(formatMessageTime(dt), '00:00');
    });

    test('chuyển sang local time trước khi format (toLocal)', () {
      // UTC 00:30 -> giờ local phụ thuộc múi giờ máy chạy test, nhưng kết quả
      // phải khớp với DateTime.toLocal() của chính input đó (không được giữ
      // nguyên giờ UTC nếu local khác UTC).
      final utc = DateTime.utc(2026, 6, 30, 0, 30);
      final expected = utc.toLocal();

      expect(
        formatMessageTime(utc),
        '${expected.hour.toString().padLeft(2, '0')}:'
        '${expected.minute.toString().padLeft(2, '0')}',
      );
    });
  });

  group('formatChatListTime', () {
    test('hôm nay -> trả về giờ:phút (happy path)', () {
      final now = DateTime.now();
      final dt = DateTime(now.year, now.month, now.day, 8, 30);

      expect(formatChatListTime(dt), formatMessageTime(dt));
    });

    test('thời điểm trong tương lai cùng ngày hôm nay -> vẫn coi là hôm nay', () {
      // diffDays <= 0 bao gồm cả trường hợp "trong tương lai" (đồng hồ lệch nhẹ).
      final now = DateTime.now();
      final dt = DateTime(now.year, now.month, now.day, 23, 59);

      expect(formatChatListTime(dt), formatMessageTime(dt));
    });

    test('biên đầu ngày hôm nay 00:00 -> vẫn là giờ:phút, không phải "Hôm qua"', () {
      final now = DateTime.now();
      final dt = DateTime(now.year, now.month, now.day, 0, 0);

      expect(formatChatListTime(dt), '00:00');
    });

    test('hôm qua -> trả về "Hôm qua"', () {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final dt = DateTime(
        yesterday.year,
        yesterday.month,
        yesterday.day,
        15,
        0,
      );

      expect(formatChatListTime(dt), 'Hôm qua');
    });

    test('biên cuối ngày hôm qua 23:59 -> vẫn là "Hôm qua"', () {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final dt = DateTime(
        yesterday.year,
        yesterday.month,
        yesterday.day,
        23,
        59,
      );

      expect(formatChatListTime(dt), 'Hôm qua');
    });

    test('2 ngày trước (trong tuần, < 7 ngày) -> trả về nhãn thứ T2..CN', () {
      const labels = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
      final twoDaysAgo = DateTime.now().subtract(const Duration(days: 2));
      final dt = DateTime(
        twoDaysAgo.year,
        twoDaysAgo.month,
        twoDaysAgo.day,
        10,
        0,
      );

      expect(formatChatListTime(dt), labels[dt.weekday - 1]);
    });

    test('6 ngày trước (biên trong tuần) -> vẫn trả về nhãn thứ', () {
      const labels = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
      final sixDaysAgo = DateTime.now().subtract(const Duration(days: 6));
      final dt = DateTime(
        sixDaysAgo.year,
        sixDaysAgo.month,
        sixDaysAgo.day,
        10,
        0,
      );

      expect(formatChatListTime(dt), labels[dt.weekday - 1]);
    });

    test('7 ngày trước (biên ra ngoài tuần) -> trả về dd/MM', () {
      final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
      final dt = DateTime(
        sevenDaysAgo.year,
        sevenDaysAgo.month,
        sevenDaysAgo.day,
        10,
        0,
      );
      final expected =
          '${dt.day.toString().padLeft(2, '0')}/'
          '${dt.month.toString().padLeft(2, '0')}';

      expect(formatChatListTime(dt), expected);
    });

    test('cũ hơn nhiều (30 ngày trước) -> trả về dd/MM với padding số 0', () {
      final old = DateTime.now().subtract(const Duration(days: 30));
      final dt = DateTime(old.year, old.month, old.day, 12, 0);
      final expected =
          '${dt.day.toString().padLeft(2, '0')}/'
          '${dt.month.toString().padLeft(2, '0')}';

      expect(formatChatListTime(dt), expected);
    });

    test('chuyển sang local time trước khi tính diffDays (toLocal)', () {
      // Một thời điểm UTC mà khi toLocal() có thể đổi sang ngày khác tuỳ múi
      // giờ máy chạy test; hàm phải dùng giờ local để so sánh ngày, không
      // phải giờ UTC gốc.
      final nowLocal = DateTime.now();
      final utcDt = DateTime.utc(
        nowLocal.year,
        nowLocal.month,
        nowLocal.day,
      ).subtract(const Duration(hours: 1)); // gần biên nửa đêm UTC

      final expectedLocal = utcDt.toLocal();
      final today = DateTime(nowLocal.year, nowLocal.month, nowLocal.day);
      final that = DateTime(
        expectedLocal.year,
        expectedLocal.month,
        expectedLocal.day,
      );
      final diffDays = today.difference(that).inDays;

      String expected;
      if (diffDays <= 0) {
        expected = formatMessageTime(expectedLocal);
      } else if (diffDays == 1) {
        expected = 'Hôm qua';
      } else if (diffDays < 7) {
        const labels = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
        expected = labels[expectedLocal.weekday - 1];
      } else {
        expected =
            '${expectedLocal.day.toString().padLeft(2, '0')}/'
            '${expectedLocal.month.toString().padLeft(2, '0')}';
      }

      expect(formatChatListTime(utcDt), expected);
    });
  });
}
