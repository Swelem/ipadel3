// import 'dart:io';
// import 'dart:async';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';
// import '/core/app_colors.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:camera/camera.dart';
// import 'package:video_player/video_player.dart';

// class VirtualCoachScreen extends StatefulWidget {
//   const VirtualCoachScreen({super.key});

//   @override
//   State<VirtualCoachScreen> createState() => _VirtualCoachScreenState();
// }

// List<String> movementImages = [
//   "assets/icons/ready1.png",
//   "assets/icons/ready2.png",
//   "assets/icons/smach.png",
//   "assets/icons/lob.png",
//   "assets/icons/volley1.png",
//   "assets/icons/volley2.png",
//   // Add more image paths for each movement
// ];
// List<String> movementTexts = [
//   "Ready Position\n\tBackcourt",
//   "Ready Position\n\tAt Net",
//   "Smach",
//   "Lob",
//   "\tVolley\n\tForehand ",
//   "\tVolley\n\tBackhand",

//   // Add corresponding text for each movement
// ];

// class _VirtualCoachScreenState extends State<VirtualCoachScreen>
//     with TickerProviderStateMixin {
//   late CameraController _cameraController;
//   late XFile? _videoFile;
//   File? _video;
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   Timer? _timer;
//   int _countdown = 10; // Initial countdown value
//   AnimationController? _animationController;
//   Animation<double>? _animation;
//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: _countdown),
//     );
//     _animation = Tween<double>(begin: 0, end: 1).animate(_animationController!)
//       ..addStatusListener((status) {
//         if (status == AnimationStatus.completed) {
//           // Start recording after countdown
//           _startRecording();
//         }
//       });
//   }

//   // Future<void> _getVideo(ImageSource source) async {
//   //   final pickedFile = await ImagePicker().pickVideo(source: source);

//   //   setState(() {
//   //     if (pickedFile != null) {
//   //       _video = File(pickedFile.path);
//   //     } else {
//   //       print('No video selected.');
//   //     }
//   //   });
//   // }

//   Future<void> _playSound(String assetPath) async {
//     await _audioPlayer.play(AssetSource(assetPath));
//   }

//   void _startCountdown() async {
//     await _playSound('countdown_sound.mp3'); // Play countdown sound

//     // Start countdown animation
//     _animationController!.forward(from: 0);

//     // Wait for 3 seconds (duration of the countdown animation)
//     await Future.delayed(Duration(seconds: _countdown));

//     // Play stop sound (optional)
//     _playSound('stop_sound.mp3');
//   }

//   void _startRecording() async {
//     // Start recording
//     await _getVideo(ImageSource.camera);

//     // Wait for 5 seconds before stopping the recording
//     await Future.delayed(Duration(seconds: 5));

//     // Optionally play stop sound
//     // _playSound('assets/stop_sound.mp3');
//   }

//   @override
//   void dispose() {
//     _animationController?.dispose();
//     _timer?.cancel();
//     _audioPlayer.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             height: MediaQuery.of(context).size.height * 0.50,
//             decoration: const BoxDecoration(
//                 color: AppColors.thirdColor,
//                 borderRadius:
//                     BorderRadius.only(bottomRight: Radius.circular(250))),
//           ),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: MediaQuery.of(context).size.height * 0.08),
//               const Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 15),
//                 child: Text(
//                   "Choose Movement",
//                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               const Divider(
//                 color: Colors.white,
//                 endIndent: 200,
//               ),
//               Expanded(
//                 child: GridView.builder(
//                   padding: const EdgeInsets.all(25),
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2, // Number of columns
//                     crossAxisSpacing: 10.0, // Spacing between columns
//                     mainAxisSpacing: 10.0, // Spacing between rows
//                   ),
//                   itemCount:
//                       movementImages.length, // Number of items in the grid
//                   itemBuilder: (context, index) {
//                     return GestureDetector(
//                         onTap: () {
//                           _startCountdown();
//                         },
//                         child: Material(
//                           elevation: 5, // Adjust the elevation as needed
//                           borderRadius: BorderRadius.circular(20),
//                           child: Container(
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Image.asset(movementImages[index],
//                                       height: 50),
//                                   const SizedBox(height: 10),
//                                   Text(
//                                     movementTexts[index],
//                                     style:
//                                         TextStyle(fontWeight: FontWeight.bold),
//                                   ),
//                                 ],
//                               )),
//                         ));
//                   },
//                 ),
//               ),
//             ],
//           ),
//           Positioned(
//             bottom: 20,
//             left: 0,
//             right: 0,
//             child: Center(
//               child: AnimatedBuilder(
//                 animation: _animation!,
//                 builder: (context, child) {
//                   return _animation!.value > 0
//                       ? Text(
//                           (_countdown - (_animation!.value * _countdown))
//                               .ceil()
//                               .toString(),
//                           style: TextStyle(
//                             fontSize: 50,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black,
//                           ),
//                         )
//                       : Container();
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:io';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '/core/app_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:video_player/video_player.dart';
import 'video_player_screen.dart';

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
  "Ready Position\n\t\tBackcourt",
  "Ready Position\n\tAt Net",
  "Smash",
  "Lob",
  "\tVolley\n\tForehand ",
  "\tVolley\n\tBackhand",
  // Add corresponding text for each movement
];

class _VirtualCoachScreenState extends State<VirtualCoachScreen>
    with TickerProviderStateMixin {
  late CameraController _cameraController;
  bool _isCameraReady = false;
  bool _isCountdownInProgress = false;
  bool _showCameraPreview = false;

  late int _selectedMovementIndex;

  late XFile? _videoFile;
  File? _video;
  final AudioPlayer _audioPlayer = AudioPlayer();
  Timer? _timer;
  int _countdown = 10; // Initial countdown value
  AnimationController? _animationController;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the camera controller
    _initializeCamera();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: _countdown),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController!)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          // Start recording after countdown
          setState(() {
            _isCountdownInProgress = false;
            _showCameraPreview = true; // Show camera preview after countdown
          });
          _startRecording();
        }
      });
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        throw 'No camera available';
      }
      final firstCamera = cameras.first;
      _cameraController = CameraController(
        firstCamera,
        ResolutionPreset.low,
        enableAudio: false,
      );

      await _cameraController.initialize();
      if (mounted) {
        setState(() {
          _isCameraReady = true;
        }); // Update the state to ensure camera preview is shown
      }
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  Future<void> _playSound(String assetPath) async {
    await _audioPlayer.play(AssetSource(assetPath));
  }

  void _startCountdown() async {
    await _playSound('countdown_sound.mp3'); // Play countdown sound

    // Start countdown animation
    _animationController!.forward(from: 0);

    // Wait for countdown duration
    await Future.delayed(Duration(seconds: _countdown));

    // Optionally play stop sound
    // _playSound('stop_sound.mp3');
    setState(() {
      _isCountdownInProgress = true; // Reset countdown in progress
    });
  }

  void _startRecording() async {
    try {
      _videoFile = null;
      await _cameraController.startVideoRecording();

      // Optionally play start recording sound
      // _playSound('start_recording_sound.mp3');

      // Wait for recording duration (5 seconds in this case)
      await Future.delayed(Duration(seconds: 5));

      // Stop recording
      _videoFile = await _cameraController.stopVideoRecording();
      _playSound('stop_sound.mp3');
      setState(() {
        _showCameraPreview = false; // Reset countdown in progress
      });
      // Navigate to video player screen after recording
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => VideoPlayerScreen(
      //       videoFile: _videoFile!,
      //       movementText: _selectedMovementIndex,
      //     ),
      Get.to(() => VideoPlayerScreen(
            videoFile: _videoFile!,
            movementText: _selectedMovementIndex,
          ));
      // ),
      // );

      // Optionally play stop recording sound
    } catch (e) {
      print('Error starting video recording: $e');
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _animationController?.dispose();
    _audioPlayer.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // Handle Android back button press
          if (_showCameraPreview || _isCountdownInProgress) {
            // If camera preview is shown or countdown is in progress, cancel recording
            await _cameraController.stopVideoRecording();
            setState(() {
              _showCameraPreview = false;
              _isCountdownInProgress = false;
            });
            return false; // Do not pop the route
          } else {
            // Otherwise, allow popping the route (navigate back to home)
            return true;
          }
        },
        child: Scaffold(
          body: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.50,
                decoration: const BoxDecoration(
                    color: AppColors.thirdColor,
                    borderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(250))),
              ),
              Positioned(
                top: 25, // Adjust this value based on your UI
                left: 10, // Adjust this value based on your UI
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: AppColors.primaryColor),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.11),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      "Choose Movement",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                              setState(() {
                                _selectedMovementIndex = index;
                                _isCountdownInProgress = true;
                                _startCountdown();
                              });
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
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )),
                            ));
                      },
                    ),
                  ),
                ],
              ),
              if (_isCountdownInProgress)
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _animation!,
                      builder: (context, child) {
                        return _animation!.value > 0
                            ? Text(
                                (_countdown - (_animation!.value * _countdown))
                                    .ceil()
                                    .toString(),
                                style: TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              )
                            : Container();
                      },
                    ),
                  ),
                ),
              if (_isCameraReady && _showCameraPreview)
                Positioned.fill(
                  child: AspectRatio(
                    aspectRatio: _cameraController.value.aspectRatio,
                    child: CameraPreview(_cameraController),
                  ),
                ),
            ],
          ),
        ));
  }
}
