import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '/core/app_colors.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'videoService.dart';
import 'correct_screen.dart';
import 'wrong_screen.dart';

class VideoPlayerScreen extends StatefulWidget {
  final XFile videoFile;
  final int movementText;

  const VideoPlayerScreen(
      {Key? key, required this.videoFile, required this.movementText})
      : super(key: key);

  @override
  _VideoPlayerScreenState createState() =>
      _VideoPlayerScreenState(video: videoFile, movement: movementText);
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoController;
  bool _isVideoInitialized = false;
  bool _isLoading = false;
  final XFile video;
  late int movement;
  _VideoPlayerScreenState({required this.video, required this.movement});

  @override
  void initState() {
    super.initState();
    print(movement.toString());
    _initializeVideo();
  }

  Future<void> _confirmAction() async {
    setState(() {
      _isLoading = true;
    });
    //print(movement.toString() + "\nHello be");
    var mp4FilePath = await convertTempToMp4(video.path);
    bool flag = await summarizeVideo(movement, mp4FilePath);
    deleteTempFile(video.path);
    // Call summarizeVideo with movement
    if (flag == true) {
      print("flag is ");
      print(flag);
      // Get.offNamedUntil(
      //   "/CorrectScreen",
      //   ModalRoute.withName("/HomeScreen"),
      //   arguments: {'video': video.path, 'movement': movement + 1},
      // );
      Get.off(
        () => CorrectScreen(
          video: mp4FilePath,
          movement: movement + 1,
        ),
      );
    } else {
      if (flag == false) {
        print("flag is ");
        print(flag);
        // Get.offNamedUntil(
        //   "/CorrectScreen",
        //   ModalRoute.withName("/HomeScreen"),
        //   arguments: {'video': video.path, 'movement': movement + 1},
        // );
        Get.off(
          () => WrongScreen(
            video: mp4FilePath,
            movement: movement + 1,
          ),
        );
      }
    }
  }

  // Optionally, navigate to another screen or perform other actions
  // Get.to(() => AnotherScreen());

  void _initializeVideo() async {
    _videoController = VideoPlayerController.file(File(widget.videoFile.path));
    try {
      await _videoController.initialize();
      _videoController.setLooping(true);
      _videoController.setVolume(0.0);
      setState(() {
        _isVideoInitialized = true;
      });
      _videoController.play();
    } catch (e) {
      print('Error initializing video player: $e');
      // Handle initialization error
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
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
                    BorderRadius.only(bottomRight: Radius.circular(125))),
          ),
          Center(
            child: _isVideoInitialized
                ? AspectRatio(
                    aspectRatio: _videoController.value.aspectRatio,
                    child: VideoPlayer(_videoController),
                  )
                : CircularProgressIndicator(),
          ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          _videoController.pause();
                          File(widget.videoFile.path).deleteSync();
                          Get.back();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isLoading
                        ? AppColors.thirdColor
                        : AppColors.thirdColor,
                    foregroundColor: _isLoading ? Colors.white : Colors.white,
                  ),
                  child: Text('Try Again'),
                ),
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          // print(movement.toString() + "\nHello be");
                          // // Navigator.push(
                          // //   context,
                          // //   MaterialPageRoute(
                          // //     builder: (context) => MyApp(
                          // //       videoFile: video,
                          // //       movementText: movement,
                          // //     ),
                          // //   ),
                          // // );
                          // // Get.to(() => MyApp(
                          // //       videoFile: video,
                          // //       movementText: movement,
                          // //     ));
                          // summarizeVideo(movement);
                          _confirmAction();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isLoading
                        ? AppColors.thirdColor
                        : AppColors.thirdColor,
                    foregroundColor: _isLoading ? Colors.white : Colors.white,
                  ),
                  child: Text('Confirm'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
