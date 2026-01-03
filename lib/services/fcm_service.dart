import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/src/widgets/framework.dart';

class FCMService {
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<void> init(BuildContext context) async {
    await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    final token = await _fcm.getToken();
    debugPrint("🔥 FCM TOKEN: $token");

    await _saveTokenToFirestore(token);

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationClick);
  }

  static Future<void> _saveTokenToFirestore(String? token) async {
    final user = _auth.currentUser;
    if (user == null || token == null) return;

    await _db.collection('users').doc(user.uid).set({
      'fcmToken': token,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  static void _handleForegroundMessage(RemoteMessage message) {
    if (message.notification != null) {
      debugPrint("📩 Foreground Notification:");
      debugPrint("Title: ${message.notification!.title}");
      debugPrint("Body : ${message.notification!.body}");
    }
  }

  static void _handleNotificationClick(RemoteMessage message) {
    debugPrint("🔔 Notifikasi ditekan");
    debugPrint("Data: ${message.data}");
  }
}
