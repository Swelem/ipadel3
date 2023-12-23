import 'package:flutter/material.dart';
import 'loginScreen.dart';
import 'signup_screen.dart'; // Import the SignUpScreen widget
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() {
  runApp(MyApp());
  
  
}


class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    future : Firebase.initializeApp();
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






