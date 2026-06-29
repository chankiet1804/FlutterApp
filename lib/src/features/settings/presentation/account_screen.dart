import 'package:firebase_auth/firebase_auth.dart' as fba;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileScreen(
      appBar: AppBar(title: const Text('Account Settings'), centerTitle: true),
      avatar: _buildAvatar(context),
      // Hỏi xác nhận trước khi xoá tài khoản (hành động không hoàn tác được)
      showDeleteConfirmationDialog: true,
      actions: [
        SignedOutAction((context) {
          Navigator.of(context).pop();
        }),
      ],
      // (B) Thẻ thông tin tài khoản chèn giữa phần providers và cụm nút Sign out / Delete
      children: [
        const SizedBox(height: 24),
        _buildInfoCard(context),
        const SizedBox(height: 8),
      ],
    );
  }

  // ---------- (A) Avatar ----------

  Widget _buildAvatar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final user = fba.FirebaseAuth.instance.currentUser;
    const size = 96.0;

    // Nội dung bên trong vòng: ảnh thật nếu có, ngược lại là chữ cái đầu
    final Widget inner = user?.photoURL != null
        ? const UserAvatar(size: size)
        : Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.primaryContainer,
            ),
            child: Text(
              _initials(user),
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
          );

    return Align(
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colorScheme.primary, colorScheme.tertiary],
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: inner,
      ),
    );
  }

  // Lấy 1-2 chữ cái đầu từ tên hiển thị, fallback sang email
  String _initials(fba.User? user) {
    final name = user?.displayName?.trim();
    if (name != null && name.isNotEmpty) {
      final parts = name.split(RegExp(r'\s+'));
      if (parts.length >= 2) {
        return (parts.first[0] + parts.last[0]).toUpperCase();
      }
      return name.characters.take(2).toString().toUpperCase();
    }
    final email = user?.email;
    if (email != null && email.isNotEmpty) {
      return email[0].toUpperCase();
    }
    return '?';
  }

  // ---------- (B) Thẻ thông tin ----------

  Widget _buildInfoCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final user = fba.FirebaseAuth.instance.currentUser;
    final verified = user?.emailVerified ?? false;
    final created = user?.metadata.creationTime;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _infoRow(
            context,
            icon: Icons.email_outlined,
            label: 'Email',
            value: user?.email ?? '—',
          ),
          Divider(height: 1, color: colorScheme.outlineVariant),
          _infoRow(
            context,
            icon: verified ? Icons.verified_outlined : Icons.error_outline,
            label: 'Trạng thái email',
            value: verified ? 'Đã xác minh' : 'Chưa xác minh',
            valueColor: verified ? Colors.green.shade600 : colorScheme.error,
          ),
          if (created != null) ...[
            Divider(height: 1, color: colorScheme.outlineVariant),
            _infoRow(
              context,
              icon: Icons.event_outlined,
              label: 'Ngày tham gia',
              value: _formatDate(created),
            ),
          ],
        ],
      ),
    );
  }

  Widget _infoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 22, color: colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: valueColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final local = date.toLocal();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(local.day)}/${two(local.month)}/${local.year}';
  }
}
