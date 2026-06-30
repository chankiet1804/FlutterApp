// Helpers định dạng thời gian cho UI chat (không phụ thuộc package ngoài).

String _two(int n) => n.toString().padLeft(2, '0');

/// Giờ:phút theo local, ví dụ "09:05".
String formatMessageTime(DateTime dt) {
  final local = dt.toLocal();
  return '${_two(local.hour)}:${_two(local.minute)}';
}

/// Thời gian rút gọn cho danh sách inbox:
/// hôm nay -> giờ, hôm qua -> "Hôm qua", trong tuần -> thứ, còn lại -> dd/MM.
String formatChatListTime(DateTime dt) {
  final local = dt.toLocal();
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final that = DateTime(local.year, local.month, local.day);
  final diffDays = today.difference(that).inDays;

  if (diffDays <= 0) return formatMessageTime(local);
  if (diffDays == 1) return 'Hôm qua';
  if (diffDays < 7) {
    const labels = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
    return labels[local.weekday - 1];
  }
  return '${_two(local.day)}/${_two(local.month)}';
}
