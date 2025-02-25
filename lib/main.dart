import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/events/event_list_screen.dart';
import 'screens/events/event_details_screen.dart';
import 'screens/events/create_event_screen.dart';
import 'screens/visitors/visitor_details_screen.dart'; // ✅ Added Visitor Details Screen
import 'screens/visitors/visitor_list_screen.dart'; // ✅ Added Visitor List Screen
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HavenArc',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/eventList': (context) => const EventListScreen(),
        '/createEvent': (context) => const CreateEventScreen(),
        '/visitorList': (context) =>
            VisitorListScreen(), // ✅ Added Correct Visitor List Route
        '/visitorDetails': (context) => VisitorDetailsScreen(
              visitor: null,
            ), // ✅ Added Visitor Details Route
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/eventDetails') {
          final args =
              settings.arguments as String; // Event ID passed as argument
          return MaterialPageRoute(
            builder: (context) => EventDetailsScreen(eventId: args),
          );
        }
        return null;
      },
    );
  }
}
