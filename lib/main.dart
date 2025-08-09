import 'package:flutter/material.dart';
import 'screens/login.dart';
import 'screens/register.dart';
import 'screens/home.dart';
import 'screens/add_event.dart';
import 'screens/splash.dart';

void main() {
  runApp(const EventUAS());
}

class EventUAS extends StatelessWidget {
  const EventUAS({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event UAS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/home') {
          final token = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => HomeScreen(token: token),
          );
        }

        if (settings.name == '/add_event') {
          final token = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => AddEventScreen(token: token),
          );
        }

        return null;
      },
    );
  }
}
