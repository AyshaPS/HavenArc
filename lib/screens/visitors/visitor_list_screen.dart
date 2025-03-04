import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:havenarc/models/visitor_model.dart';
import 'package:havenarc/widgets/visitor_card.dart';
import 'visitor_details_screen.dart';

class VisitorListScreen extends StatelessWidget {
  const VisitorListScreen({super.key});

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
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No visitors found.'));
          }

          // ✅ Fix: Convert Firestore documents into `Visitor` objects
          List<Visitor> visitors = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Visitor.fromMap(data, doc.id);
          }).toList();

          return ListView.builder(
            itemCount: visitors.length,
            itemBuilder: (context, index) {
              final visitor = visitors[index];

              return VisitorCard(
                visitor:
                    visitor, // ✅ Corrected: Passing a `Visitor` object, not a Firestore document
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          VisitorDetailsScreen(visitor: visitor),
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
