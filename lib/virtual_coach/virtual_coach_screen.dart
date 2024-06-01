import 'dart:io';

import 'package:flutter/material.dart';
import '/core/app_colors.dart';
import 'package:image_picker/image_picker.dart';

class VirtualCoachScreen extends StatefulWidget {
  const VirtualCoachScreen({super.key});

  @override
  State<VirtualCoachScreen> createState() => _VirtualCoachScreenState();
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
  "Ready Position\n\tBackcourt",
  "Ready Position\n\tAt Net",
  "Smach",
  "Lob",
  "\tVolley\n\tForehand ",
  "\tVolley\n\tBackhand",

  // Add corresponding text for each movement
];

class _VirtualCoachScreenState extends State<VirtualCoachScreen> {
  File? _video;

  Future<void> _getVideo(ImageSource source) async {
    final pickedFile = await ImagePicker().pickVideo(source: source);

    setState(() {
      if (pickedFile != null) {
        _video = File(pickedFile.path);
      } else {
        print('No video selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.50,
            decoration: const BoxDecoration(
                color: AppColors.thirdColor,
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(250))),
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
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of columns
                    crossAxisSpacing: 10.0, // Spacing between columns
                    mainAxisSpacing: 10.0, // Spacing between rows
                  ),
                  itemCount:
                      movementImages.length, // Number of items in the grid
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () {
                          _getVideo(ImageSource.camera);
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
                                  Image.asset(movementImages[index],
                                      height: 50),
                                  const SizedBox(height: 10),
                                  Text(
                                    movementTexts[index],
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )),
                        ));
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
