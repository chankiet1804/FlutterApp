import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider; // Add this import
import 'package:firebase_ui_auth/firebase_ui_auth.dart'; // And this import
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/widgets/bottom_navigation.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key, required this.clientId});

  final String clientId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen(
            providers: [
              EmailAuthProvider(),
              GoogleProvider(clientId: clientId),
            ],
            // Giới hạn bề rộng form để không bị kéo dài xấu trên màn rộng
            maxWidth: 400,
            // Hiện nút con mắt ẩn/hiện mật khẩu
            showPasswordVisibilityToggle: true,
            // Nút "Đăng nhập" dạng nền đặc (filled) thay vì viền mặc định
            styles: const {
              EmailFormStyle(signInButtonVariant: ButtonVariant.filled),
            },
            headerBuilder: (context, constraints, shrinkOffset) {
              return Container(
                margin: const EdgeInsets.only(top: 56.0),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: const FlutterLogo(size: 120),
                ),
              );
            },
            footerBuilder: (context, action) {
              return const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(
                  'By signing in, you agree to our terms and conditions.',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            },
            sideBuilder: (context, shrinkOffset) {
              // Add from here...
              return Padding(
                padding: const EdgeInsets.all(20),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: const FlutterLogo(size: 120),
                ),
              ); // To here.
            },
          );
        }

        return const BottomNavigation();
      },
    );
  }
}
