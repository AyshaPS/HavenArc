import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackModel {
  String id;
  String userId;
  String feedbackText;
  double sentimentScore;
  DateTime timestamp;

  FeedbackModel({
    required this.id,
    required this.userId,
    required this.feedbackText,
    required this.sentimentScore,
    required this.timestamp,
  });

  // Convert a FeedbackModel object into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'feedbackText': feedbackText,
      'sentimentScore': sentimentScore,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // Create a FeedbackModel object from a Map
  factory FeedbackModel.fromMap(Map<String, dynamic> map, String documentId) {
    return FeedbackModel(
      id: documentId,
      userId: map['userId'] ?? '',
      feedbackText: map['feedbackText'] ?? '',
      sentimentScore: (map['sentimentScore'] ?? 0).toDouble(),
      timestamp: (map['timestamp'] != null)
          ? DateTime.parse(map['timestamp'])
          : DateTime.now(),
    );
  }

  // Convert Firestore DocumentSnapshot to FeedbackModel
  factory FeedbackModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return FeedbackModel.fromMap(data, doc.id);
  }
}
