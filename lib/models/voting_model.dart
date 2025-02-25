import 'package:cloud_firestore/cloud_firestore.dart';

class Voting {
  String id;
  String title;
  String description;
  List<String> options;
  Map<String, int> votes;
  DateTime startTime;
  DateTime endTime;
  String createdBy;

  Voting({
    required this.id,
    required this.title,
    required this.description,
    required this.options,
    required this.votes,
    required this.startTime,
    required this.endTime,
    required this.createdBy,
  });

  factory Voting.fromMap(Map<String, dynamic> data, String documentId) {
    return Voting(
      id: documentId,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      options: List<String>.from(data['options'] ?? []),
      votes: Map<String, int>.from(data['votes'] ?? {}),
      startTime: (data['startTime'] as Timestamp).toDate(),
      endTime: (data['endTime'] as Timestamp).toDate(),
      createdBy: data['createdBy'] ?? '',
    );
  }

  get totalVotes => null;

  get endDate => null;

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'options': options,
      'votes': votes,
      'startTime': startTime,
      'endTime': endTime,
      'createdBy': createdBy,
    };
  }
}
