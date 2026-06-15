import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

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
