import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/state/counter_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

const clientId =
    '239460398195-s7iasek07mon8gnt8b1ubl6pb5qp1ih5.apps.googleusercontent.com';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(
    ChangeNotifierProvider(
      create: (context) {
        final provider = CounterProvider();
        provider.loadCounter();
        return provider;
      },
      child: const MyApp(clientId: clientId),
    ),
  );
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Background message: ${message.messageId}');
}
