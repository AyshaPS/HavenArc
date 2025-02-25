import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Request permission for notifications
  Future<void> requestNotificationPermissions() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("Notification permission granted.");
    } else {
      print("Notification permission denied.");
    }
  }

  // Get the device FCM token
  Future<String?> getDeviceToken() async {
    return await _firebaseMessaging.getToken();
  }

  // Save token to Firestore for a user
  Future<void> saveTokenToDatabase(String userId) async {
    String? token = await getDeviceToken();
    if (token != null) {
      await _firestore
          .collection('users')
          .doc(userId)
          .update({'fcmToken': token});
    }
  }

  // Send a notification to a user
  Future<void> sendNotification(
      String userId, String title, String body) async {
    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(userId).get();
    if (userDoc.exists && userDoc['fcmToken'] != null) {
      String token = userDoc['fcmToken'];
      // Here, you would call a cloud function or backend service to send the notification
      print("Sending notification to token: $token");
    }
  }

  // Listen for incoming messages
  void listenForNotifications() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("New notification received: ${message.notification?.title}");
    });
  }
}
