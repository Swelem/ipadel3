import 'package:flutter/material.dart';
import 'loginScreen.dart';
import 'signup_screen.dart'; // Import the SignUpScreen widget

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login UI',
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
      routes: {
        '/signup': (context) =>
            SignUpScreen(), // Define the route for the sign-up screen
      },
    );
  }
}
