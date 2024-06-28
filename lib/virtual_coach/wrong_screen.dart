import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '/core/app_colors.dart';

// void main() {
//   runApp(MyApp());
// }
final Map<int, String> correctionPaths = {
  1: 'assets/corrections/ready.mp4',
  2: 'assets/corrections/ready.mp4',
  3: 'assets/corrections/smash.mp4',
  4: 'assets/corrections/lob.mp4',
  5: 'assets/corrections/volley1.mp4',
  6: 'assets/corrections/volley2.mp4',
};

class MyApp extends StatelessWidget {
  final video;
  final movement;

  const MyApp({required this.video, required this.movement});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WrongScreen(video: video, movement: movement),
    );
  }
}

class WrongScreen extends StatefulWidget {
  final video;
  final movement;

  const WrongScreen({required this.video, required this.movement});
  @override
  _WrongScreenState createState() => _WrongScreenState(videoPath: video);
}

class _WrongScreenState extends State<WrongScreen> {
  final videoPath;
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  _WrongScreenState({required this.videoPath});

  bool isShowingCorrectForm = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      videoPath,
    )..setLooping(true);
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.play();
  }

  void _toggleForm(bool value) async {
    setState(() {
      //isShowingCorrectForm = value;
      String nextVideoPath = value
          ? videoPath // Retrieve correct video path based on movement
          : correctionPaths[widget.movement] ??
              ''; // Show original wrong video path
      _controller.pause();
      _controller.dispose();
      if (value == true) {
        _controller = VideoPlayerController.network(
          nextVideoPath,
        )..setLooping(true);
      } else {
        _controller = VideoPlayerController.asset(
          nextVideoPath,
        )..setLooping(true);
      }
      _initializeVideoPlayerFuture = _controller.initialize();

      _controller.play();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final double aspectRatio = 4 / 7;
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        leading: Container(),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          color: AppColors.thirdColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        child: SingleChildScrollView(
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    //height: MediaQuery.of(context).size.height * 0.85,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 30,
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            "assets/images/wrong_coach.png", // Replace with your image path
                            height: 100,
                          ),
                          const Text(
                            "Oops!",
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          FutureBuilder(
                            future: _initializeVideoPlayerFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _controller.value.isPlaying
                                          ? _controller.pause()
                                          : _controller.play();
                                    });
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: AspectRatio(
                                      aspectRatio:
                                          _controller.value.aspectRatio,

                                      //aspectRatio,
                                      //child: FittedBox(
                                      // fit: BoxFit.cover,
                                      // child: SizedBox(
                                      //   width:
                                      //       _controller.value.size?.width ??
                                      //           0,
                                      //   height: _controller
                                      //           .value.size?.height ??
                                      //       0,
                                      child: VideoPlayer(_controller),
                                      //),
                                    ),
                                  ),
                                );
                              } else {
                                return const CircularProgressIndicator();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Image.asset(
                "assets/images/logo_sign_up.png",
                height: 159,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isShowingCorrectForm == false) {
            setState(() {
              print(videoPath);
              _toggleForm(false);
            });
            isShowingCorrectForm = true;
          } else {
            setState(() {
              print(videoPath);
              _toggleForm(true);
            });
            isShowingCorrectForm = false;
          }
        },
        tooltip: isShowingCorrectForm ? 'Show Your Form' : 'Show Correct Form',
        child: isShowingCorrectForm
            ? const Icon(Icons.person)
            : const Icon(Icons.check), // Use your preferred icon for toggling
      ),
    );
  }
}
