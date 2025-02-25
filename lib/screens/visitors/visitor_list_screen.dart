import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:havenarc/models/visitor_model.dart';
import 'package:havenarc/widgets/visitor_card.dart';
import 'visitor_details_screen.dart';

class VisitorListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visitors Log'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('visitors').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            debugPrint("❌ Firestore Error: ${snapshot.error}");
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            debugPrint("❌ No visitors found in Firestore.");
            return const Center(child: Text('No visitors found.'));
          }

          // Convert Firestore documents to Visitor objects safely
          List<Visitor> visitors = snapshot.data!.docs
              .map((doc) {
                try {
                  final data = doc.data()
                      as Map<String, dynamic>?; // Ensure data is a map
                  if (data == null) {
                    debugPrint(
                        "⚠️ Skipped a visitor document because it's null: ${doc.id}");
                    return null;
                  }
                  return Visitor.fromMap(data,
                      doc.id); // Ensure Visitor model can handle missing data
                } catch (e) {
                  debugPrint("⚠️ Error parsing visitor document ${doc.id}: $e");
                  return null;
                }
              })
              .whereType<Visitor>()
              .toList(); // Remove null values safely

          // If visitors list is empty after filtering, return a message
          if (visitors.isEmpty) {
            return const Center(child: Text('No valid visitor records found.'));
          }

          return ListView.builder(
            itemCount: visitors.length,
            itemBuilder: (context, index) {
              final visitor = visitors[index]; // Ensure visitor is not null
              return VisitorCard(
                visitor: visitor,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VisitorDetailsScreen(
                        visitor: visitor,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
