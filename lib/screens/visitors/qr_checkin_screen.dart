import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRCheckInScreen extends StatefulWidget {
  const QRCheckInScreen({super.key});

  @override
  _QRCheckInScreenState createState() => _QRCheckInScreenState();
}

class _QRCheckInScreenState extends State<QRCheckInScreen> {
  final MobileScannerController scannerController = MobileScannerController();

  // Function to handle the scanned QR code
  void _onQRScanned(String qrCode) async {
    try {
      // Fetch the visitor document from Firestore using the QR code as the doc ID
      DocumentSnapshot visitorDoc = await FirebaseFirestore.instance
          .collection('visitors')
          .doc(qrCode)
          .get();

      if (visitorDoc.exists) {
        // If visitor exists, fetch their data
        Map<String, dynamic>? visitorData =
            visitorDoc.data() as Map<String, dynamic>?;

        if (visitorData != null) {
          // Add a check-in record to the 'checkins' collection
          await FirebaseFirestore.instance.collection('checkins').add({
            'visitorId': qrCode,
            'name': visitorData['name'],
            'purpose': visitorData['purpose'],
            'checkInTime': Timestamp.now(),
          });

          // Show a success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Checked in: ${visitorData['name']}')),
          );

          // Close the current screen after successful check-in
          Navigator.pop(context);
        }
      } else {
        // Show an error if visitor is not found
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Visitor not found!')),
        );
      }
    } catch (e) {
      // Show a general error message if an error occurs
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error scanning QR code!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR Code')),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              controller: scannerController,
              onDetect: (BarcodeCapture barcode) {
                if (barcode.rawValue != null) {
                  _onQRScanned(barcode.rawValue!);
                }
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Scan Visitor\'s QR Code to Check-In',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

extension on BarcodeCapture {
  get rawValue => null;
}
