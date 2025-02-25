import 'package:cloud_firestore/cloud_firestore.dart';

class Complaint {
  String id;
  String userId;
  String title;
  String description;
  String status;
  DateTime timestamp;

  Complaint({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.status,
    required this.timestamp,
  });

  // Convert object to Firestore Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'status': status,
      'timestamp': Timestamp.fromDate(
          timestamp), // Convert DateTime to Firestore Timestamp
    };
  }

  // Create object from Firestore Map
  factory Complaint.fromMap(Map<String, dynamic> map, String documentId) {
    return Complaint(
      id: documentId,
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      status: map['status'] ?? 'Pending',
      timestamp: (map['timestamp'] as Timestamp)
          .toDate(), // Convert Firestore Timestamp to DateTime
    );
  }
}
