import 'package:flutter/material.dart';
import '/core/app_colors.dart';
import '/auth/login_screen.dart';
import 'package:get/get.dart';
import '../../authService.dart';
import '/home/tabs/home_reels_screen.dart';

class ProfileScreen extends StatefulWidget {
  final user; // Add user field

  ProfileScreen({required this.user});
  @override
  _ProfileScreenState createState() => _ProfileScreenState(user: user);
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user; // Add user field

  _ProfileScreenState({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              "assets/images/profile_screen.png",
              fit: BoxFit.fill,
              height: MediaQuery.of(context).size.height * 0.40,
              width: double.infinity,
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  //Image.asset("assets/images/profile_image.png", height: 150),
                  Text(
                    "CONTACT US:",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.only(topLeft: Radius.circular(20)),
                            color: AppColors.thirdColor,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "CONTACT US:",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(Icons.call,
                                          color: AppColors.primaryColor),
                                      SizedBox(width: 10),
                                      Text(
                                        "+201019211216",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.primaryColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(Icons.location_pin,
                                          color: AppColors.primaryColor),
                                      SizedBox(width: 10),
                                      Expanded(
                                          child: Text(
                                        "behind Nozha Airport, Alexandria, Egypt",
                                        style: TextStyle(
                                            color: AppColors.primaryColor,
                                            fontWeight: FontWeight.bold),
                                      )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20)),
                                color: AppColors.thirdColor,
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 30),
                                child: Text(
                                  "About US:",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: () async {
                                AuthService authService = AuthService();
                                await authService.logout();
                                Get.offAll(() => LoginScreen(user: null));
                              },
                              child: Container(
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(20)),
                                  color: AppColors.thirdColor,
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 30),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Logout",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Icon(Icons.logout, color: Colors.red),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
