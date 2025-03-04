import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HavenAuthProvider with ChangeNotifier {
  final FirebaseAuth _auth;
  User? _user;

  HavenAuthProvider(this._auth) {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();

      if (_user != null) {
        checkAndAddFacilities();
      }
    });
  }

  /// Getter for the authenticated user
  User? get user => _user;

  /// ✅ Sign In with Email & Password
  Future<void> signInWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _user = _auth.currentUser;
      notifyListeners();

      if (_user != null) {
        await checkAndAddFacilities();
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(_getAuthErrorMessage(e));
    }
  }

  /// ✅ Sign Up with Email & Password
  Future<void> signUpWithEmail(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      _user = _auth.currentUser;
      notifyListeners();

      if (_user != null) {
        await checkAndAddFacilities();
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(_getAuthErrorMessage(e));
    }
  }

  /// ✅ Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }

  /// ✅ Check & Add Facilities (Admin Only)
  Future<void> checkAndAddFacilities() async {
    final firestore = FirebaseFirestore.instance;
    final facilitiesCollection = firestore.collection("facilities");

    try {
      User? user = _auth.currentUser;
      if (user == null) {
        debugPrint(
            "⚠️ No authenticated user found! Skipping facility addition.");
        return;
      }

      IdTokenResult idTokenResult = await user.getIdTokenResult();
      Map<String, dynamic>? claims = idTokenResult.claims;

      if (claims == null || claims["admin"] != true) {
        debugPrint("⚠️ User is not an admin! Facilities won't be added.");
        return;
      }

      final existingFacilities = await facilitiesCollection.get();
      if (existingFacilities.docs.isEmpty) {
        final facilities = [
          {
            "name": "Swimming Pool",
            "description": "Olympic-sized pool with heating",
            "imageUrl": "https://example.com/swimming_pool.jpg",
            "availability": true
          },
          {
            "name": "Gym",
            "description": "Fully equipped fitness center",
            "imageUrl": "https://example.com/gym.jpg",
            "availability": true
          },
          {
            "name": "Tennis Court",
            "description": "Floodlit court with synthetic surface",
            "imageUrl": "https://example.com/tennis_court.jpg",
            "availability": true
          },
        ];

        for (var facility in facilities) {
          await facilitiesCollection
              .doc(facility["name"] as String?)
              .set(facility);
        }
        debugPrint("✅ Facilities added successfully!");
      } else {
        debugPrint("✅ Facilities already exist, skipping addition.");
      }
    } catch (e, stackTrace) {
      debugPrint(
          "❌ Failed to add facilities (Permission Issue?): $e\n$stackTrace");
    }
  }

  /// 🔹 Helper function to get better error messages
  String _getAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return "No user found with this email.";
      case 'wrong-password':
        return "Incorrect password. Try again.";
      case 'email-already-in-use':
        return "This email is already registered.";
      case 'weak-password':
        return "Password is too weak. Use a stronger password.";
      case 'invalid-email':
        return "Invalid email format.";
      default:
        return e.message ?? "Authentication error. Try again.";
    }
  }
}
