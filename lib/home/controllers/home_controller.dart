import '/home/tabs/home_reels_screen.dart';
import '/home/tabs/profile_screen.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final user;

  // HomeController({required this.user});

  var currentScreen = 0.obs;
  late List screens;

  HomeController({required this.user}) {
    screens = [
      HomeReelsScreen(user: user),
      ProfileScreen(user: user),
    ];
  }
}
