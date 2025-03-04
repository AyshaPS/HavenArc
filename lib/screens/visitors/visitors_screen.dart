import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:havenarc/models/visitor_model.dart'; // ✅ Import Visitor model
import 'visitor_details_screen.dart';
import 'qr_checkin_screen.dart'; // ✅ QR check-in screen
import 'add_visitor_screen.dart'; // ✅ Add Visitor Screen

class VisitorsScreen extends StatelessWidget {
  const VisitorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visitors Log'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const QRCheckInScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('visitors').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No visitors found.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];

              // ✅ Convert Firestore document to a Visitor object
              Visitor visitor =
                  Visitor.fromMap(doc.data() as Map<String, dynamic>, doc.id);

              return ListTile(
                title: Text(visitor.name),
                subtitle: Text('Purpose: ${visitor.purpose}'),
                trailing: const Icon(Icons.arrow_forward_ios),
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

      // ✅ Floating Action Button for adding new visitors
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddVisitorScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
