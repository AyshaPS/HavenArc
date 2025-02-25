import 'package:flutter/material.dart';
import 'package:havenarc/services/visitor_service.dart';
import '../mobile_scanner/mobile_scanner.dart';

class QRCheckInScreen extends StatefulWidget {
  @override
  _QRCheckInScreenState createState() => _QRCheckInScreenState();
}

class _QRCheckInScreenState extends State<QRCheckInScreen> {
  final VisitorService _visitorService = VisitorService();
  bool _isProcessing = false;

  void _onQRViewCreated(String qrCode) async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      await _visitorService.checkInWithQR(qrCode);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Visitor check-in successful!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('QR Code not valid or error: $e')),
      );
    }

    setState(() {
      _isProcessing = false;
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("QR Check-In")),
      body: Column(
        children: [
          Expanded(
            child: MobileScannerWidget(
              onScanned: (qrCode) {
                _onQRViewCreated(qrCode);
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Scan Visitor's QR Code to Check-In",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
