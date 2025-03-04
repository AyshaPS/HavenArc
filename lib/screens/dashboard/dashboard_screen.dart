import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:havenarc/screens/dashboard/profile_screen.dart';
import 'package:havenarc/screens/dashboard/settings_screen.dart';
import 'package:havenarc/screens/facilities/facility_booking_screen.dart';
import '../auth/login_screen.dart';
import '../events/event_list_screen.dart';
import '../visitors/visitors_screen.dart'; // ✅ Import Visitors Screen
// ✅ Import Facility Booking Screen

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
  }

  void _logout() async {
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: _logout,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(user?.displayName ?? "User"),
              accountEmail: Text(user?.email ?? "user@example.com"),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 50, color: Colors.blue),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.event),
              title: const Text("Events"),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const EventListScreen()), // ✅ Navigate to events
              ),
            ),
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text("Visitors"),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const VisitorsScreen()),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text("Facility Booking"),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const FacilityBookingScreen()),
              ), // ✅ Navigate to Facility Booking
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text("Logout"),
              onTap: _logout,
            ),
          ],
        ),
      ),
      body: Center(
        child: Text(
          "Welcome, ${user?.displayName ?? "User"}!",
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
