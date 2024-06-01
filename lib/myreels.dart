// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:video_player/video_player.dart';
// import 'reelService.dart'; // Import your reels service

// class ReelsPage2 extends StatefulWidget {
//   final User? user; // Allow User to be nullable

//   ReelsPage2({required this.user});

//   @override
//   _ReelsPageState2 createState() => _ReelsPageState2(user: user);
// }

// class _ReelsPageState2 extends State<ReelsPage2> {
//   final User? user; // Allow User to be nullable

//   _ReelsPageState2({required this.user});
//   List<String> videoUrls = []; // List to store video URLs
//   bool isLoading = false;
//   bool hasMore = true;
//   int pageSize = 5; // Number of reels to fetch per page
//   DocumentSnapshot? lastDocument; // Last document snapshot fetched

//   @override
//   void initState() {
//     super.initState();
//     fetchReels(); // Fetch initial reels when the widget is initialized
//   }

//   Future<void> fetchReels() async {
//     if (isLoading || !hasMore) return;

//     setState(() {
//       isLoading = true;
//     });

//     if (user == null) {
//       setState(() {
//         isLoading = false;
//       });
//       return;
//     }

//     // Call the paginated function to fetch reels
//     List<Map<String, dynamic>> reels = await fetchPaginatedReelsForUser(
//       user!.uid, // Pass the user ID directly
//       pageSize,
//       lastDocument: lastDocument,
//     );

//     setState(() {
//       videoUrls.addAll(reels.map((reel) => reel['videoUrl'] as String? ?? ''));
//       if (reels.isNotEmpty) {
//         lastDocument =
//             reels.last['documentSnapshot'] as DocumentSnapshot<Object?>?;
//       }
//       isLoading = false;
//       hasMore = reels.length == pageSize;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Reels"),
//       ),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance.collection('reelsMeta').snapshots(),
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (!snapshot.hasData) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//           List<DocumentSnapshot> reels = snapshot.data!.docs;
//           return ListView.builder(
//             itemCount: reels.length,
//             itemBuilder: (context, index) {
//               Map<String, dynamic> reel =
//                   reels[index].data() as Map<String, dynamic>;
//               String title = reel['title'] as String? ?? 'No title';
//               String description =
//                   reel['description'] as String? ?? 'No description';
//               return ListTile(
//                 title: Text(title),
//                 subtitle: Text(description),
//                 onTap: () {
//                   // Add onTap functionality here
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// class VideoPlayerWidget extends StatefulWidget {
//   final String videoUrl;

//   const VideoPlayerWidget({Key? key, required this.videoUrl}) : super(key: key);

//   @override
//   _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
// }

// class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
//   late VideoPlayerController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.network(widget.videoUrl)
//       ..initialize().then((_) {
//         // Ensure the first frame is shown after the video is initialized
//         setState(() {});
//       });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _controller.value.isInitialized
//         ? AspectRatio(
//             aspectRatio: _controller.value.aspectRatio,
//             child: VideoPlayer(_controller),
//           )
//         : Center(
//             child:
//                 CircularProgressIndicator()); // Show loading indicator while video is loading
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _controller.dispose();
//   }
// }
// -------------------------
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:video_player/video_player.dart';
// import 'reelService.dart'; // Import your reels service

// class ReelsPage2 extends StatefulWidget {
//   final User? user; // Allow User to be nullable

//   ReelsPage2({required this.user});

//   @override
//   _ReelsPageState2 createState() => _ReelsPageState2(user: user);
// }

// class _ReelsPageState2 extends State<ReelsPage2> {
//   final User? user; // Allow User to be nullable

//   _ReelsPageState2({required this.user});
//   List<String> videoUrls = []; // List to store video URLs
//   bool isLoading = false;
//   bool hasMore = true;
//   int pageSize = 5; // Number of reels to fetch per page
//   DocumentSnapshot? lastDocument; // Last document snapshot fetched

//   @override
//   void initState() {
//     super.initState();
//     fetchReels(); // Fetch initial reels when the widget is initialized
//   }

//   Future<void> fetchReels() async {
//     if (isLoading || !hasMore) return;

//     setState(() {
//       isLoading = true;
//     });

//     if (user == null) {
//       setState(() {
//         isLoading = false;
//       });
//       return;
//     }

//     // Call the paginated function to fetch reels
//     List<Map<String, dynamic>> reels = await fetchPaginatedReelsForUser(
//       user!.uid, // Pass the user ID directly
//       pageSize,
//       lastDocument: lastDocument,
//     );

//     setState(() {
//       videoUrls.addAll(reels.map((reel) => reel['videoUrl'] as String? ?? ''));
//       if (reels.isNotEmpty) {
//         lastDocument =
//             reels.last['documentSnapshot'] as DocumentSnapshot<Object?>?;
//       }
//       isLoading = false;
//       hasMore = reels.length == pageSize;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance.collection('reelsMeta').snapshots(),
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (!snapshot.hasData) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//           List<DocumentSnapshot> reels = snapshot.data!.docs;
//           List<String> videoUrls = reels
//               .map((doc) {
//                 var data = doc.data() as Map<String, dynamic>?;
//                 return data?['videoUrl'] as String? ?? '';
//               })
//               .where((url) => url.isNotEmpty)
//               .toList();

//           return PageView.builder(
//             scrollDirection: Axis.vertical,
//             itemCount: videoUrls.length,
//             itemBuilder: (context, index) {
//               return VideoPlayerWidget(videoUrl: videoUrls[index]);
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// class VideoPlayerWidget extends StatefulWidget {
//   final String videoUrl;

//   const VideoPlayerWidget({Key? key, required this.videoUrl}) : super(key: key);

//   @override
//   _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
// }

// class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
//   late VideoPlayerController _controller;
//   bool _isPlaying = false;

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.network(widget.videoUrl)
//       ..initialize().then((_) {
//         setState(() {
//           _controller.play();
//           _isPlaying = true;
//         });
//       });
//     _controller.setLooping(true);
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _controller.dispose();
//   }

//   void _togglePlayback() {
//     setState(() {
//       if (_isPlaying) {
//         _controller.pause();
//       } else {
//         _controller.play();
//       }
//       _isPlaying = !_isPlaying;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GestureDetector(
//         onTap: _togglePlayback,
//         child: Stack(
//           children: [
//             Center(
//               child: _controller.value.isInitialized
//                   ? AspectRatio(
//                       aspectRatio: _controller.value.aspectRatio,
//                       child: VideoPlayer(_controller),
//                     )
//                   : Center(child: CircularProgressIndicator()),
//             ),
//             if (!_isPlaying)
//               Center(
//                 child: Icon(
//                   Icons.play_arrow,
//                   size: 80.0,
//                   color: Colors.white.withOpacity(0.7),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:video_player/video_player.dart';
import 'reelService.dart'; // Import your reels service

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
                videoUrl: reelsData[index]['videoUrl']!,
                title: reelsData[index]['title']!,
                description: reelsData[index]['description']!,
                username: reelsData[index]['username']!,
              );
            },
          );
        },
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final String title;
  final String description;
  final String username;

  const VideoPlayerWidget({
    Key? key,
    required this.videoUrl,
    required this.title,
    required this.description,
    required this.username,
  }) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
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
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
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
                        icon: Icon(Icons.favorite_border, color: Colors.white),
                        onPressed: () {
                          // Handle like button press
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.comment, color: Colors.white),
                        onPressed: () {
                          // Handle comment button press
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.person, color: Colors.white),
                        onPressed: () {
                          // Handle person button press
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.file_upload, color: Colors.white),
                        onPressed: () {
                          // Handle send button press
                        },
                      ),
                    ],
                  ),
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
    _controller
        .dispose(); // Dispose the controller only when the widget is disposed
  }
}
