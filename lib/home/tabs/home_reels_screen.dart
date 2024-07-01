import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '/core/app_colors.dart';
import '/reels/reels_screen.dart';
import '/virtual_coach/virtual_coach_screen.dart';
import 'package:get/get.dart';
import 'package:iPadel/myreels.dart';
import '../../Loginscreen.dart';
import '../../profle.dart';
import '../../reels.dart';

class HomeReelsScreen extends StatelessWidget {
  final user;
  HomeReelsScreen({required this.user});
  String name = "user";

  Future<String> fetchUserData() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        return userDoc['firstName'] ?? 'User';
      }
    } catch (e) {
      // Handle errors here
      print("Error fetching user data: $e");
    }
    return 'User';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topRight,
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: FutureBuilder<String>(
                    future: fetchUserData(),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text(
                          "Error: ${snapshot.error}",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        );
                      } else if (snapshot.hasData) {
                        name = snapshot.data!;
                        return Text(
                          "Hi, ${snapshot.data}",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        );
                      } else {
                        return Text(
                          "User not found",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        );
                      }
                    },
                  ),
                ),
                const Divider(
                  color: AppColors.thirdColor,
                  endIndent: 200,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: Column(
                    children: [
                      GestureDetector(
                        child: customHomeItem(
                            title: "Reels",
                            textColor: Colors.white,
                            backgroundColor: AppColors.primaryColor),
                        onTap: () {
                          Get.to(ReelsPage2(user: user));
                        },
                      ),
                      GestureDetector(
                          onTap: () {
                            Get.to(() => VirtualCoachScreen());
                          },
                          child: customHomeItem(
                              title: "Virtual AI Coach",
                              textColor: Colors.black,
                              backgroundColor: AppColors.thirdColor)),
                      customHomeItemWithIcon(
                          title: "News Feed",
                          textColor: Colors.white,
                          backgroundColor: Colors.grey),
                      customHomeItemWithIcon(
                          title: "Court Booking",
                          textColor: Colors.white,
                          backgroundColor: Colors.grey),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.20)
              ],
            ),
          ),
          // Image.asset("assets/icons/home_icon1.png", height: 120),
        ],
      ),
    );
  }

  Widget customHomeItem({
    required String title,
    required Color textColor,
    required Color backgroundColor,
  }) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.symmetric(vertical: 15),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget customHomeItemWithIcon({
    required String title,
    required Color textColor,
    required Color backgroundColor,
  }) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.symmetric(vertical: 15),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: textColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Icon(Icons.lock, color: Colors.white, size: 37),
        ],
      ),
    );
  }
}
