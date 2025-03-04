import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart' as local_auth;
import 'providers/facility_provider.dart';
import 'models/visitor_model.dart';

import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/events/event_list_screen.dart';
import 'screens/events/event_details_screen.dart';
import 'screens/events/create_event_screen.dart';
import 'screens/visitors/visitor_details_screen.dart';
import 'screens/visitors/visitor_list_screen.dart';
import 'screens/facilities/facility_booking_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    debugPrint("✅ Firebase Initialized Successfully");
  } catch (e, stackTrace) {
    debugPrint("❌ Firebase Initialization Failed: $e\n$stackTrace");
    return;
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<local_auth.HavenAuthProvider>(
          create: (context) =>
              local_auth.HavenAuthProvider(FirebaseAuth.instance),
        ),
        ChangeNotifierProvider<FacilityProvider>(
          create: (context) => FacilityProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<local_auth.HavenAuthProvider>(
      builder: (context, authProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'HavenArc',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: authProvider.user != null ? '/dashboard' : '/login',
          routes: {
            '/login': (context) => const LoginScreen(),
            '/signup': (context) => const SignupScreen(),
            '/dashboard': (context) => const DashboardScreen(),
            '/eventList': (context) => const EventListScreen(),
            '/createEvent': (context) => const CreateEventScreen(),
            '/visitorList': (context) => const VisitorListScreen(),
            '/facilityBooking': (context) => const FacilityBookingScreen(),
          },
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/eventDetails':
                final args = settings.arguments as String?;
                if (args == null) return null;
                return MaterialPageRoute(
                  builder: (context) => EventDetailsScreen(eventId: args),
                );

              case '/visitorDetails':
                final visitor = settings.arguments as Visitor?;
                if (visitor == null) return null;
                return MaterialPageRoute(
                  builder: (context) => VisitorDetailsScreen(visitor: visitor),
                );

              default:
                return null;
            }
          },
          onUnknownRoute: (settings) {
            debugPrint("⚠️ Unknown route: ${settings.name}");
            return MaterialPageRoute(
              builder: (context) => const Scaffold(
                body: Center(child: Text("404 - Page Not Found")),
              ),
            );
          },
        );
      },
    );
  }
}
