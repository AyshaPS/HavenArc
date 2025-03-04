import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
// ignore: depend_on_referenced_packages
import 'package:qr_flutter/qr_flutter.dart';

class AddVisitorScreen extends StatefulWidget {
  const AddVisitorScreen({super.key});

  @override
  _AddVisitorScreenState createState() => _AddVisitorScreenState();
}

class _AddVisitorScreenState extends State<AddVisitorScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _purposeController = TextEditingController();
  String? visitorId;

  void _saveVisitor() async {
    if (_nameController.text.isEmpty || _purposeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields.")),
      );
      return;
    }

    String newVisitorId = const Uuid().v4(); // Generate unique visitor ID
    await FirebaseFirestore.instance
        .collection('visitors')
        .doc(newVisitorId)
        .set({
      'name': _nameController.text,
      'purpose': _purposeController.text,
      'visitorId': newVisitorId,
      'createdAt': Timestamp.now(),
    });

    setState(() {
      visitorId = newVisitorId; // Store ID for QR code generation
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Visitor added successfully!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Visitor')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Visitor Name'),
            ),
            TextField(
              controller: _purposeController,
              decoration: const InputDecoration(labelText: 'Purpose of Visit'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveVisitor,
              child: const Text('Save Visitor'),
            ),
            const SizedBox(height: 20),
            if (visitorId != null) ...[
              const Text("Visitor QR Code",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              QrImageView(
                data: visitorId!,
                version: QrVersions.auto,
                size: 200.0,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
