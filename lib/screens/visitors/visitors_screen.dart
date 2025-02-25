import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'visitor_details_screen.dart';
import 'qr_checkin_screen.dart'; // QR check-in screen

class VisitorsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visitors Log'),
        actions: [
          IconButton(
            icon: Icon(Icons.qr_code_scanner),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QRCheckInScreen(),
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
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No visitors found.'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var visitor = snapshot.data!.docs[index];
              return ListTile(
                title: Text(visitor['name']),
                subtitle: Text('Purpose: ${visitor['purpose']}'),
                trailing: Icon(Icons.arrow_forward_ios),
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
