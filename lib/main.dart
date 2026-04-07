import 'package:flutter/material.dart';
import 'package:flutter_app/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

const clientId =
    '239460398195-s7iasek07mon8gnt8b1ubl6pb5qp1ih5.apps.googleusercontent.com';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp(clientId: clientId));
}
