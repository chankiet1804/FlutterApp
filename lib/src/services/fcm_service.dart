import 'package:firebase_messaging/firebase_messaging.dart';

class FCMService {
  static Future<void> init() async {
    final messaging = FirebaseMessaging.instance;

    // Xin quyền → sẽ hiện popup "Allow notifications?"
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('✅ User granted permission');
    } else {
      print('❌ User denied permission');
      // Có thể show dialog hướng dẫn user vào Settings bật thủ công
    }
    final token = await messaging.getToken();
    print('✅ FCM Token: $token');

    FirebaseMessaging.onMessage.listen((message) {
      print('Foreground: ${message.notification?.title}');
    });
  }

  /// Xử lý khi người dùng bấm vào notification để mở app.
  static Future<void> setupInteractedMessage() async {
    // App đang bị kill, mở từ notification
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // App đang chạy nền, bấm notification để đưa lên foreground
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  static void _handleMessage(RemoteMessage message) {
    print('User tapped notification: ${message.data}');

    final type = message.data['type'];
    switch (type) {
      case 'home':
        print('Navigate to HomeScreen');
        break;
      // Thêm các type khác tùy app của bạn, vd:
      // case 'chat':
      //   navigatorKey.currentState?.push(
      //     MaterialPageRoute<void>(builder: (_) => const ChatScreen()),
      //   );
      //   break;
    }
  }
}
