import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:havenarc/screens/events/event_list_screen.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  DateTime? _selectedDate;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Function to pick a date
  void _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    setState(() {
      _selectedDate = picked;
      _dateController.text = DateFormat('yyyy-MM-dd').format(picked!);
    });
  }

  // Function to create an event
  void _createEvent() async {
    String title = _titleController.text.trim();
    User? user = _auth.currentUser; // Get current user

    if (title.isEmpty || _selectedDate == null || user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter title and date!")),
      );
      return;
    }

    await FirebaseFirestore.instance.collection("events").add({
      "title": title,
      "date": _dateController.text,
      "participants": [],
      "creatorId": user.uid, // Store event creator's ID
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Event Created Successfully!")),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const EventListScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Event")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Event Title"),
              onChanged: (_) => setState(() {}), // Update button state
            ),
            TextField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: "Event Date",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ),
              readOnly: true,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: Navigator.of(context).pop,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed:
                      _titleController.text.isNotEmpty && _selectedDate != null
                          ? _createEvent
                          : null, // Disable if title or date is empty
                  child: const Text("Create Event"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
