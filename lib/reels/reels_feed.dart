import 'package:flutter/material.dart';
import 'reels_video_player.dart';

class ReelsFeed extends StatelessWidget {
  final List<String> videoUrls;

  const ReelsFeed({Key? key, required this.videoUrls}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: videoUrls.length,
      itemBuilder: (context, index) {
        return ReelsVideoPlayer(videoUrl: videoUrls[index]);
      },
    );
  }
}
