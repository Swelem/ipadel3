import 'dart:async';

import 'package:flutter/material.dart';
import '/core/app_colors.dart';
import '/auth/login_screen.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 3), () {
      var user;
      Get.off(() => LoginScreen(user: user));
    });
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            Image.asset("assets/images/logo.png"),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset("assets/images/football.png", height: 73),
                const SizedBox(width: 10),
                Image.asset("assets/images/title_splash.png", height: 74),
              ],
            )
          ],
        ),
      ),
    );
  }
}
