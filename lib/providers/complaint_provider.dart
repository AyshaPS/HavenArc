import 'package:flutter/material.dart';
import '../models/complaint_model.dart';
import '../services/complaint_service.dart';

class ComplaintProvider with ChangeNotifier {
  final ComplaintService _complaintService = ComplaintService();
  List<Complaint> _complaints = [];

  List<Complaint> get complaints => _complaints;

  Future<void> fetchComplaints() async {
    _complaints = await _complaintService.getUserComplaints().first;
    notifyListeners();
  }

  Future<void> submitComplaint(String title, String description) async {
    await _complaintService.submitComplaint(title, description);
    await fetchComplaints();
  }
}
