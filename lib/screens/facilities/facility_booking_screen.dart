import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'facility_details_screen.dart';

class FacilityBookingScreen extends StatelessWidget {
  const FacilityBookingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Facility Booking")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("facilities").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          var facilities = snapshot.data!.docs;
          return ListView.builder(
            itemCount: facilities.length,
            itemBuilder: (context, index) {
              var facility = facilities[index];
              return ListTile(
                title: Text(facility["name"]),
                subtitle: Text(
                    "Availability: ${facility["availability"] ? "Available" : "Booked"}"),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          FacilityDetailsScreen(facilityId: facility.id),
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
