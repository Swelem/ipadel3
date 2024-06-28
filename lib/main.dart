import 'package:flutter/material.dart';
import 'loginScreen.dart';
import 'signup_screen.dart'; // Import the SignUpScreen widget
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   var user;

//   @override
//   Widget build(BuildContext context) {
//     future:
//     Firebase.initializeApp();
//     return MaterialApp(
//       title: 'Flutter Login UI',
//       debugShowCheckedModeBanner: false,
//       home: LoginScreen(user: user),
//       routes: {
//         '/signup': (context) =>
//             SignUpScreen(), // Define the route for the sign-up screen
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
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
