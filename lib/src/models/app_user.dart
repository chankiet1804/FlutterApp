import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;
  final String email;
  final String username;
  final String displayName;
  final String? photoURL;
  final DateTime createdAt;
  final bool isOnline;
  final DateTime? lastSeen;
  final String? activeDeviceId;
  final DateTime? activeDeviceLoginAt;
  final Map<String, String> fcmTokens;

  AppUser({
    required this.uid,
    required this.email,
    required this.username,
    required this.displayName,
    this.photoURL,
    required this.createdAt,
    this.isOnline = false,
    this.lastSeen,
    this.activeDeviceId,
    this.activeDeviceLoginAt,
    this.fcmTokens = const {},
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'username_lowercase': username.toLowerCase(),
      'displayName': displayName,
      'photoURL': photoURL,
      'createdAt': Timestamp.fromDate(createdAt),
      'isOnline': isOnline,
      'lastSeen': lastSeen != null ? Timestamp.fromDate(lastSeen!) : null,
      'activeDeviceId': activeDeviceId,
      'activeDeviceLoginAt': activeDeviceLoginAt != null
          ? Timestamp.fromDate(activeDeviceLoginAt!)
          : null,
      'fcmTokens': fcmTokens,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'] as String,
      email: map['email'] as String,
      username: map['username'] as String,
      displayName: map['displayName'] as String,
      photoURL: map['photoURL'] as String?,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      isOnline: map['isOnline'] as bool? ?? false,
      lastSeen: (map['lastSeen'] as Timestamp?)?.toDate(),
      activeDeviceId: map['activeDeviceId'] as String?,
      activeDeviceLoginAt: (map['activeDeviceLoginAt'] as Timestamp?)?.toDate(),
      fcmTokens: Map<String, String>.from(map['fcmTokens'] ?? {}),
    );
  }
}
