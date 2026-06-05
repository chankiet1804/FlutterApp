import 'package:firebase_auth/firebase_auth.dart' as fba;
import 'package:flutter/material.dart';
import 'package:flutter_app/src/state/counter_provider.dart';
import 'package:provider/provider.dart';

/// Banner chào mừng: hiện "Xin chào, [tên]" kèm icon bàn tay vẫy (animation)
/// và hiệu ứng mờ dần + trượt lên khi xuất hiện.
class WelcomeBanner extends StatefulWidget {
  const WelcomeBanner({super.key});

  @override
  State<WelcomeBanner> createState() => _WelcomeBannerState();
}

class _WelcomeBannerState extends State<WelcomeBanner>
    with SingleTickerProviderStateMixin {
  // Animation vẫy tay: xoay qua lại liên tục
  late final AnimationController _waveController;
  late final Animation<double> _wave;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    )..repeat(reverse: true);
    _wave = Tween<double>(begin: -0.25, end: 0.25).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  // Tên hiển thị: ưu tiên displayName, fallback phần trước @ của email
  String _displayName(fba.User? user) {
    final name = user?.displayName?.trim();
    if (name != null && name.isNotEmpty) return name;
    final email = user?.email;
    if (email != null && email.contains('@')) return email.split('@').first;
    return 'bạn';
  }

  @override
  Widget build(BuildContext context) {
    // Sinh ColorScheme từ màu của provider -> gradient, chữ, bóng đều đổi theo
    final colorScheme = ColorScheme.fromSeed(
      seedColor: context.watch<CounterProvider>().color,
    );
    final user = fba.FirebaseAuth.instance.currentUser;
    final name = _displayName(user);

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
      builder: (context, t, child) {
        // t: 0 -> 1, dùng cho mờ dần + trượt lên
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, (1 - t) * 16),
            child: child,
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colorScheme.primary, colorScheme.tertiary],
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Xin chào',
                        style: TextStyle(
                          fontSize: 16,
                          color: colorScheme.onPrimary.withValues(alpha: 0.9),
                        ),
                      ),
                      const SizedBox(width: 6),
                      // Bàn tay vẫy qua lại
                      AnimatedBuilder(
                        animation: _wave,
                        builder: (context, child) => Transform.rotate(
                          angle: _wave.value,
                          alignment: Alignment.bottomCenter,
                          child: child,
                        ),
                        child: const Text('👋', style: TextStyle(fontSize: 18)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Chúc bạn một ngày tốt lành!',
                    style: TextStyle(
                      fontSize: 13,
                      color: colorScheme.onPrimary.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
