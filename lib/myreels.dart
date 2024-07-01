import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:video_player/video_player.dart';
import 'reelService.dart'; // Import your reels service
import '/upload_reels/upload_reels_screen.dart';
import 'package:get/get.dart';
import 'commentswidget.dart';

class ReelsPage2 extends StatefulWidget {
  final User? user;

  ReelsPage2({required this.user});

  @override
  _ReelsPageState2 createState() => _ReelsPageState2(user: user);
}

class _ReelsPageState2 extends State<ReelsPage2> {
  final User? user;

  _ReelsPageState2({required this.user});
  List<Map<String, String>> reelsData = [];
  bool isLoading = false;
  bool hasMore = true;
  int pageSize = 5;
  DocumentSnapshot? lastDocument;

  @override
  void initState() {
    super.initState();
    preloadReels();
  }

  Future<void> preloadReels() async {
    // Preload the first two pages of reels (10 reels)
    await fetchReels();
  }

  Future<void> fetchReels() async {
    if (isLoading || !hasMore) return;

    setState(() {
      isLoading = true;
    });

    if (user == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    List<Map<String, dynamic>> reels = await fetchPaginatedReelsForUser(
      user!.uid,
      pageSize,
      lastDocument: lastDocument,
    );

    setState(() {
      reelsData.addAll(reels.map((reel) => {
            'videoUrl': reel['videoUrl'] as String? ?? '',
            'title': reel['title'] as String? ?? 'No title',
            'description': reel['description'] as String? ?? 'No description',
            'username': reel['username'] as String? ?? 'No username'
          }));
      if (reels.isNotEmpty) {
        lastDocument =
            reels.last['documentSnapshot'] as DocumentSnapshot<Object?>?;
      }
      isLoading = false;
      hasMore = reels.length == pageSize;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('reelsMeta').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          List<DocumentSnapshot> reels = snapshot.data!.docs;
          List<Map<String, String>> reelsData = reels
              .map((doc) {
                var data = doc.data() as Map<String, dynamic>?;
                return {
                  'reelId': doc.id,
                  'videoUrl': data?['videoUrl'] as String? ?? '',
                  'title': data?['title'] as String? ?? 'No title',
                  'description':
                      data?['description'] as String? ?? 'No description',
                  'username': data?['username'] as String? ?? 'No username'
                };
              })
              .where((data) => data['videoUrl']!.isNotEmpty)
              .toList();

          return PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: reelsData.length,
            itemBuilder: (context, index) {
              return VideoPlayerWidget(
                  reelid: reelsData[index]['reelId']!,
                  videoUrl: reelsData[index]['videoUrl']!,
                  title: reelsData[index]['title']!,
                  description: reelsData[index]['description']!,
                  username: reelsData[index]['username']!,
                  user: user);
            },
          );
        },
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String reelid;
  final String videoUrl;
  final String title;
  final String description;
  final String username;
  final user;

  const VideoPlayerWidget({
    Key? key,
    required this.reelid,
    required this.videoUrl,
    required this.title,
    required this.description,
    required this.username,
    required this.user,
  }) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState(user: user);
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  final user;
  int _likeCount = 0;
  int _commentCount = 0;
  _VideoPlayerWidgetState({required this.user});
  bool _isPlaying = false;
  bool _hasError = false;
  bool _liked = false;
  bool _showComments = false;
  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
    _checkIfLiked();
    _fetchLikeCount();
  }

  void _initializeVideoPlayer() {
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          _controller.play();
          _isPlaying = true;
          _hasError = false;
        });
      }).catchError((error) {
        setState(() {
          _hasError = true;
        });
      });
    _controller.setLooping(true);
  }

  Future<void> _checkIfLiked() async {
    // Check if the current user has already liked this video
    if (widget.user != null) {
      bool liked = await checkIfLiked(widget.reelid, widget.user!.uid);
      setState(() {
        _liked = liked;
      });
    }
  }

  Future<void> _toggleLike() async {
    if (widget.user != null) {
      await toggleLike(widget.reelid, widget.user!.uid);
      _fetchLikeCount();
      _checkIfLiked();
      // setState(() {
      //   _liked = !_liked; // Toggle the liked state
      // });
    }
  }

  Future<void> _fetchLikeCount() async {
    // Fetch the current like count from Firestore
    int likeCount = await fetchLikeCount(widget.reelid);
    setState(() {
      _likeCount = likeCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          _hasError
              ? Center(
                  child: Text(
                    'Error loading video',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                )
              : _controller.value.isInitialized
                  // ? AspectRatio(
                  //     aspectRatio: _controller.value.aspectRatio,
                  //     child: VideoPlayer(_controller),
                  //   )
                  // : Center(child: CircularProgressIndicator()),
                  ? FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: _controller.value.size.width,
                        height: _controller.value.size.height,
                        child: VideoPlayer(_controller),
                      ),
                    )
                  : Center(child: CircularProgressIndicator()),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black.withOpacity(0.5),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title + '\t' + '@' + widget.username,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    widget.description,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Get.back();
                        },
                      ),
                      // IconButton(
                      //   icon: Icon(
                      //     _liked ? Icons.favorite : Icons.favorite_border,
                      //     color: _liked ? Colors.red : Colors.white,
                      //   ),
                      //   onPressed: () {
                      //     _toggleLike();
                      //   },
                      // ),
                      // Text(
                      //   '$_likeCount',
                      //   style: TextStyle(color: Colors.white),
                      // ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(
                              _liked ? Icons.favorite : Icons.favorite_border,
                              color: _liked ? Colors.red : Colors.white,
                            ),
                            onPressed: () {
                              _toggleLike();
                            },
                          ),
                          SizedBox(
                              height:
                                  0), // Adjust spacing between icon and text
                          Text(
                            '$_likeCount',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      // IconButton(
                      //   icon: Icon(Icons.comment, color: Colors.white),
                      //   onPressed: () {
                      //     // Handle comment button press
                      //   },
                      // ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.comment,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                // _showComments = !_showComments;
                              });
                            },
                          ),
                          SizedBox(
                              height:
                                  0), // Adjust spacing between icon and text
                          Text(
                            '$_commentCount',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(Icons.file_upload, color: Colors.white),
                        onPressed: () {
                          Get.off(() => UploadReelsScreen(user: user));
                          // Handle send button press
                        },
                      ),
                    ],
                  ),
                  // if (_showComments)
                  //   Container(
                  //     padding: EdgeInsets.symmetric(vertical: 8),
                  //     child: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Text(
                  //           'Comments Section Placeholder',
                  //           style: TextStyle(color: Colors.white),
                  //         ),
                  //         // Replace with your comments widget
                  //         // Example:
                  //         // CommentWidget(reelId: widget.reelid),
                  //       ],
                  //     ),
                  //   ),
                  if (_showComments)
                    CommentsWidget(reelId: widget.reelid, user: widget.user),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.pause();
    _controller
        .dispose(); // Dispose the controller only when the widget is disposed
  }
}
