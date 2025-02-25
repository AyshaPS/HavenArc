import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VisitorDetailsScreen extends StatelessWidget {
  final QueryDocumentSnapshot visitor;

  VisitorDetailsScreen({required this.visitor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(visitor['name']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${visitor['name']}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Phone: ${visitor['phoneNumber']}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Purpose: ${visitor['purpose']}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Check-in Time: ${visitor['checkin_time']}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text(
                'Check-out Time: ${visitor['checkout_time'] ?? 'Not Checked Out'}',
                style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
