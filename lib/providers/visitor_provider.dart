import 'package:flutter/material.dart';
import '../models/visitor_model.dart';
import '../services/visitor_service.dart';

class VisitorProvider with ChangeNotifier {
  final VisitorService _visitorService = VisitorService();
  List<Visitor> _visitors = [];

  List<Visitor> get visitors => _visitors;

  Future<void> fetchVisitors() async {
    try {
      _visitorService.getUserVisitors().listen((visitorList) {
        _visitors = visitorList;
        notifyListeners();
      }, onError: (error) {
        print("Error fetching visitors: $error");
      });
    } catch (e) {
      print("Exception in fetchVisitors: $e");
    }
  }

  Future<void> registerVisitor(Visitor visitor) async {
    try {
      await _visitorService.registerVisitor(visitor);
      await fetchVisitors(); // Fetch updated list
    } catch (e) {
      print("Error registering visitor: $e");
    }
  }
}
