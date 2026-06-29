import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/app_user.dart';

class UserService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  /// Lưu thông tin user khi đăng nhập hoặc đăng ký.
  ///
  /// Dùng `merge: true` để chỉ cập nhật/thêm các field trong [AppUser]
  /// mà không ghi đè toàn bộ document (giữ lại các field đã có sẵn).
  ///
  /// Các field có giá trị `null` sẽ được lọc bỏ trước khi ghi, tránh việc
  /// `merge: true` ghi đè một field đang có dữ liệu thành `null`.
  Future<void> setAppUser(AppUser user) async {
    try {
      // Lọc bỏ các entry null để không ghi đè dữ liệu cũ trên Firestore.
      final data = <String, dynamic>{}
        ..addAll(user.toMap())
        ..removeWhere((key, value) => value == null);

      await db
          .collection("users")
          .doc(user.uid)
          .set(data, SetOptions(merge: true));
      print('✅ User set successfully');
    } catch (e) {
      print('❌ Lỗi ghi Firestore: $e');
    }
  }

  Future<void> set_user() async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user!.uid;
    try {
      await db.collection("users").doc(uid).set({
        "displayName": user.displayName,
        "email": user.email,
      }, SetOptions(merge: true));
      print('✅ User set successfully');
    } catch (e) {
      print('❌ Lỗi ghi Firestore: $e');
    }
  }

  Future<void> get_city() async {
    try {
      final docRef = db.collection("cities").doc("SF");
      final doc = await docRef.get();
      if (doc.exists) {
        print('✅ Document data: ${doc.data()}');
      } else {
        print('❌ Document does not exist');
      }
    } catch (e) {
      print('❌ Lỗi đọc Firestore: $e');
    }
  }
}
