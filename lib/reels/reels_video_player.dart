import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class ReelsVideoPlayer extends StatefulWidget {
  final String videoUrl;

  const ReelsVideoPlayer({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _ReelsVideoPlayerState createState() => _ReelsVideoPlayerState();
}

class _ReelsVideoPlayerState extends State<ReelsVideoPlayer> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      });
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: _videoPlayerController.value.aspectRatio,
      autoPlay: true,
      looping: true,
      showControls: false, // Hide controls for a cleaner look
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _chewieController != null &&
        _chewieController!.videoPlayerController.value.isInitialized
        ? Chewie(
      controller: _chewieController!,
    )
        : Center(
      child: CircularProgressIndicator(),
    );
  }
}
