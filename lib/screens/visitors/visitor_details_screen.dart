import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:havenarc/models/visitor_model.dart';

class VisitorDetailsScreen extends StatelessWidget {
  final Visitor visitor;

  const VisitorDetailsScreen({super.key, required this.visitor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(visitor.name.isNotEmpty ? visitor.name : "Visitor Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                backgroundImage:
                    (visitor.imageUrl != null && visitor.imageUrl!.isNotEmpty)
                        ? NetworkImage(visitor.imageUrl!)
                        : null,
                child: (visitor.imageUrl == null || visitor.imageUrl!.isEmpty)
                    ? const Icon(Icons.person, size: 50, color: Colors.grey)
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoTile("Name", visitor.name),
            _buildInfoTile("Purpose", visitor.purpose),
            _buildInfoTile("Date", _formatDate(visitor.visitDate)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        "$title: ${value ?? 'N/A'}",
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }

  String _formatDate(dynamic visitDate) {
    if (visitDate is Timestamp) {
      return visitDate
          .toDate()
          .toLocal()
          .toString()
          .split(' ')[0]; // Converts to YYYY-MM-DD format
    } else if (visitDate is String && visitDate.isNotEmpty) {
      return visitDate; // If it's already a valid string date
    } else {
      return "N/A"; // Handles null values
    }
  }
}
