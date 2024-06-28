import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/core/app_colors.dart';
import 'correction_video_player_screen.dart';

class CorrectionsScreen extends StatefulWidget {
  const CorrectionsScreen({super.key});

  @override
  State<CorrectionsScreen> createState() => _CorrectionsScreenState();
}

List<String> movementImages = [
  "assets/icons/ready1.png",
  "assets/icons/ready2.png",
  "assets/icons/smach.png",
  "assets/icons/lob.png",
  "assets/icons/volley1.png",
  "assets/icons/volley2.png",
  // Add more image paths for each movement
];
List<String> movementTexts = [
  "1 Ready Position\n\tBackcourt",
  "2 Ready Position\n\tAt Net",
  "3 Smach",
  "4 Lob",
  "5 \tVolley\n\tForehand ",
  "6 \tVolley\n\tBackhand",
  // Add corresponding text for each movement
];
final Map<int, String> correctionPaths = {
  1: 'assets/corrections/ready.mp4',
  2: 'assets/corrections/ready.mp4',
  3: 'assets/corrections/smash.mp4',
  4: 'assets/corrections/lob.mp4',
  5: 'assets/corrections/volley1.mp4',
  6: 'assets/corrections/volley2.mp4',
};

class _CorrectionsScreenState extends State<CorrectionsScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  void _performAction(int index) {
    switch (index) {
      case 0:
        final mp4File = File(correctionPaths[index + 1]!);
        Get.to(() => CorrectionVideoPlayerScreen(videoFile: mp4File));
        print("Action 2 performed");
        break;
      case 1:
        var mp4File = File(correctionPaths[index + 1]!);
        Get.to(() => CorrectionVideoPlayerScreen(videoFile: mp4File));
        // Action for "3 Smach"
        print("Action 3 performed");
        break;
      case 2:
        var mp4File = File(correctionPaths[index + 1]!);
        Get.to(() => CorrectionVideoPlayerScreen(videoFile: mp4File));
        // Action for "4 Lob"
        print("Action 4 performed");
        break;
      case 3:
        var mp4File = File(correctionPaths[index + 1]!);
        Get.to(() => CorrectionVideoPlayerScreen(videoFile: mp4File));
        // Action for "5 Volley Forehand"
        print("Action 5 performed");
        break;
      case 4:
        var mp4File = File(correctionPaths[index + 1]!);
        Get.to(() => CorrectionVideoPlayerScreen(videoFile: mp4File));
        // Action for "6 Volley Backhand"
        print("Action 6 performed");
        break;
      case 5:
        var mp4File = File(correctionPaths[index + 1]!);
        Get.to(() => CorrectionVideoPlayerScreen(videoFile: mp4File));
        // Action for "6 Volley Backhand"
        print("Action 6 performed");
        break;
      default:
        print("No action assigned");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true; // Allow popping the route (navigate back to home)
      },
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.50,
              decoration: const BoxDecoration(
                color: AppColors.thirdColor,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(250),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    "Choose Movement",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(
                  color: Colors.white,
                  endIndent: 200,
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(25),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Number of columns
                      crossAxisSpacing: 10.0, // Spacing between columns
                      mainAxisSpacing: 10.0, // Spacing between rows
                    ),
                    itemCount:
                        movementImages.length, // Number of items in the grid
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          _performAction(index);
                        },
                        child: Material(
                          elevation: 5, // Adjust the elevation as needed
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(movementImages[index], height: 50),
                                const SizedBox(height: 10),
                                Text(
                                  movementTexts[index],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
