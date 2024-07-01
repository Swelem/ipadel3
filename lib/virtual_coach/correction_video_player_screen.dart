import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '/core/app_colors.dart';

class CorrectionVideoPlayerScreen extends StatefulWidget {
  final File videoFile;

  const CorrectionVideoPlayerScreen({Key? key, required this.videoFile})
      : super(key: key);

  @override
  _CorrectionVideoPlayerScreenState createState() =>
      _CorrectionVideoPlayerScreenState(video: videoFile);
}

class _CorrectionVideoPlayerScreenState
    extends State<CorrectionVideoPlayerScreen> {
  late VideoPlayerController _videoController;
  bool _isVideoInitialized = false;
  final File video;
  late int movement;
  _CorrectionVideoPlayerScreenState({required this.video});

  @override
  void initState() {
    super.initState();
    //print(movement.toString());
    _initializeVideo();
  }

  void _initializeVideo() async {
    _videoController = VideoPlayerController.asset(widget.videoFile.path);
    try {
      await _videoController.initialize();
      _videoController.setLooping(true);
      _videoController.setVolume(0.0);
      setState(() {
        _isVideoInitialized = true;
      });
      _videoController.play();
    } catch (e) {
      //print('Error initializing video player: $e');
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
                : const CircularProgressIndicator(),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _videoController.pause();
                    // Navigator.pop(context);
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.thirdColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Back'),
                ),
                // ElevatedButton(
                //   onPressed: () {
                //     Get.to(() => MyApp(
                //           videoFile: video,
                //           movementText: movement,
                //         ));
                //   },
                //   child: Text('Confirm'),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
