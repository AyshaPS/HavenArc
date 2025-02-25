import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ComplaintDetailsScreen extends StatefulWidget {
  final String complaintId;
  final String complaintText;
  final String status;

  const ComplaintDetailsScreen({
    Key? key,
    required this.complaintId,
    required this.complaintText,
    required this.status,
  }) : super(key: key);

  @override
  _ComplaintDetailsScreenState createState() => _ComplaintDetailsScreenState();
}

class _ComplaintDetailsScreenState extends State<ComplaintDetailsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _updateComplaintStatus(String newStatus) async {
    try {
      await _firestore.collection("complaints").doc(widget.complaintId).update({
        "status": newStatus,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Status updated to: $newStatus")),
      );

      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Complaint Details"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Complaint Description:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(widget.complaintText, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            const Text(
              "Current Status:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(widget.status, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            if (widget.status != "Resolved") ...[
              ElevatedButton(
                onPressed: () => _updateComplaintStatus("Resolved"),
                child: const Text("Mark as Resolved"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => _updateComplaintStatus("In Progress"),
                child: const Text("Mark as In Progress"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
