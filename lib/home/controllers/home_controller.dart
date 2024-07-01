import '/home/tabs/home_reels_screen.dart';
import '/home/tabs/profile_screen.dart';
import 'package:get/get.dart';
import 'package:iPadel/virtual_coach/corrections_screen.dart';

class HomeController extends GetxController {
  final user;

  // HomeController({required this.user});

  var currentScreen = 0.obs;
  late List screens;

  HomeController({required this.user}) {
    screens = [
      //Get.to(() => HomeReelsScreen(user: user)),
      //Get.to(() => ProfileScreen(user: user)),
      HomeReelsScreen(user: user),
      ProfileScreen(user: user),
      const CorrectionsScreen(),
    ];
  }
}
