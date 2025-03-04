import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'event_list_screen.dart'; // Navigation to EventListScreen

class EventDetailsScreen extends StatefulWidget {
  final String eventId;
  const EventDetailsScreen({super.key, required this.eventId});

  @override
  _EventDetailsScreenState createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isJoined = false;
  bool isCreator = false;
  String? creatorId;

  @override
  void initState() {
    super.initState();
    _fetchEventDetails();
  }

  // Fetch event details to check if the user is the creator or a participant
  void _fetchEventDetails() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot eventDoc = await FirebaseFirestore.instance
            .collection("events")
            .doc(widget.eventId)
            .get();

        if (eventDoc.exists) {
          Map<String, dynamic> eventData =
              eventDoc.data() as Map<String, dynamic>;

          List<dynamic> participants = eventData["participants"] ?? [];
          String eventCreatorId = eventData["creatorId"] ?? "";

          setState(() {
            isJoined = participants.contains(user.uid);
            isCreator = user.uid == eventCreatorId;
            creatorId = eventCreatorId;
          });
        }
      }
    } catch (e) {
      print("Error fetching event details: $e");
    }
  }

  // Function to join the event
  void joinEvent() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection("events")
            .doc(widget.eventId)
            .update({
          "participants": FieldValue.arrayUnion([user.uid])
        });

        setState(() {
          isJoined = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("You joined the event!")),
        );
      }
    } catch (e) {
      print("Error joining event: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error joining event. Please try again.")),
      );
    }
  }

  // Function to cancel (delete) the event
  void cancelEvent() async {
    try {
      await FirebaseFirestore.instance
          .collection("events")
          .doc(widget.eventId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Event has been cancelled.")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => EventListScreen()),
      );
    } catch (e) {
      print("Error cancelling event: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error cancelling event. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Event Details")),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection("events")
            .doc(widget.eventId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData ||
              snapshot.data == null ||
              !snapshot.data!.exists) {
            return Center(child: Text("Event not found or deleted."));
          }

          var eventData = snapshot.data!.data() as Map<String, dynamic>?;

          if (eventData == null) {
            return Center(child: Text("Event details are missing."));
          }

          String title = eventData["title"] ?? "Untitled Event";
          String date = eventData["date"] ?? "No Date Provided";

          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text("Date: $date", style: TextStyle(fontSize: 18)),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: isJoined ? null : joinEvent,
                  child: Text(isJoined ? "Already Joined" : "Join Event"),
                ),
                const SizedBox(height: 20),

                // Show Cancel Event button only if the user is the creator
                if (isCreator)
                  ElevatedButton(
                    onPressed: cancelEvent,
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text("Cancel Event",
                        style: TextStyle(color: Colors.white)),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
