import 'package:flutter/material.dart';
import '/core/app_colors.dart';
import '/home/controllers/home_controller.dart';
import '/upload_reels/upload_reels_screen.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  final user; // Add user field

  HomeScreen({required this.user});
  @override
  _HomeScreenState createState() => _HomeScreenState(user: user);
}

class _HomeScreenState extends State<HomeScreen> {
  var user;
  late HomeController controller;
  _HomeScreenState({required user});

  @override
  void initState() {
    super.initState();
    controller = Get.put(HomeController(user: widget.user));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: AppColors.primaryColor,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Obx(
              () => controller.screens[controller.currentScreen.value],
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset("assets/images/bottom_navigation.png"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () {
                        controller.currentScreen.value = 0;
                      },
                      icon: const Icon(Icons.add, color: Colors.transparent),
                    ),
                    IconButton(
                      onPressed: () {
                        Get.to(() => UploadReelsScreen(user: user));
                      },
                      icon: const Icon(Icons.add, color: Colors.transparent),
                    ),
                    IconButton(
                      onPressed: () {
                        controller.currentScreen.value = 1;
                      },
                      icon: const Icon(Icons.add, color: Colors.transparent),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
