import 'package:flutter/material.dart';
import 'reels_feed.dart';

class ReelsScreen extends StatelessWidget {
  const ReelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reels'),
        centerTitle: true,
      ),
      body: const ReelsFeed(
        videoUrls: [
          "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
        ],
      ),
    );
  }
}
