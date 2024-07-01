import 'package:flutter/material.dart'; // Import the SignUpScreen widget
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import '/splash_screen/splash_screen.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    future:
    Firebase.initializeApp();
    return const GetMaterialApp(
      title: 'iPadel',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SplashScreen(),
      ),
    );
  }
}
