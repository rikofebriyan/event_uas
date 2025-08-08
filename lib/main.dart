import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/add_event_screen.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const BookEventApp());
}

class BookEventApp extends StatelessWidget {
  const BookEventApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookEvent',
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
