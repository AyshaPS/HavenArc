import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: Colors.deepPurple,
      ),
      body: user == null
          ? const Center(child: Text("Please log in to view notifications"))
          : StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection("notifications")
                  .where("userId", isEqualTo: user.uid)
                  .orderBy("timestamp", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No new notifications"));
                }

                var notifications = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    var notification = notifications[index];
                    bool isRead = notification["read"] ?? false;

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 3,
                      child: ListTile(
                        leading: Icon(
                          isRead
                              ? Icons.notifications_active
                              : Icons.notifications,
                          color: isRead ? Colors.green : Colors.red,
                        ),
                        title: Text(notification["title"],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        subtitle: Text(notification["message"],
                            style: const TextStyle(fontSize: 14)),
                        trailing: isRead
                            ? Icon(Icons.check_circle, color: Colors.green)
                            : Icon(Icons.circle, color: Colors.red),
                        onTap: () {
                          // Mark notification as read
                          _firestore
                              .collection("notifications")
                              .doc(notification.id)
                              .update({"read": true});
                        },
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
