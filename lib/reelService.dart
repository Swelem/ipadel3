import 'dart:io';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:ipadel3/main.dart';
import 'package:path/path.dart' as Path;
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart' as db;
import 'authService.dart';
import 'package:camera/camera.dart'; // For accessing the device camera
import 'package:image_picker/image_picker.dart'; // For selecting images and videos from the gallery
import 'package:video_player/video_player.dart'; // For displaying video files
//import 'package:flutter_ffmpeg/flutter_ffmpeg.dart'; // For executing FFmpeg commands

// Upload reel video to Firebase Storage
Future<String> uploadReel(
    String userId,
//String caption,
    String videoFilePath,
    String title,
    String desc,
    List<String> tags,
    String username) async {
  // Upload video file
  String reelId = '$userId-${DateTime.now().millisecondsSinceEpoch}';
  Reference storageRef =
      FirebaseStorage.instance.ref().child('reels/$userId/$reelId.mp4');
  UploadTask uploadTask = storageRef.putFile(File(videoFilePath));
  print('Uploading reel: $userId, $videoFilePath');
  // Get download URL after upload completes
  String videoUrl = await (await uploadTask).ref.getDownloadURL();

  await FirebaseFirestore.instance.collection('reelsMeta').doc(reelId).set({
    'userId': userId,
    'videoUrl': videoUrl,
    'timestamp': FieldValue.serverTimestamp(),
    'likeCount': 0,
    'commentCount': 0,
    'title': title,
    'description': desc,
    'tags': tags,
    'username': username
  });
  return reelId;
}

Future<List<Map<String, dynamic>>> fetchReelsForUser(String userId) async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('reelsMeta')
      .where('userId', isEqualTo: userId)
      .orderBy('timestamp', descending: true)
      .limit(10)
      .get();

  List<Map<String, dynamic>> reels = [];
  for (var doc in querySnapshot.docs) {
    reels.add(doc.data() as Map<String, dynamic>);
  }

  return reels;
}

Future<List<Map<String, dynamic>>> fetchPaginatedReelsForUser(
    String userId, int pageSize,
    {DocumentSnapshot? lastDocument}) async {
  var query = FirebaseFirestore.instance
      .collection('reelsMeta')
      .orderBy('timestamp', descending: true)
      .limit(pageSize);

  if (lastDocument != null) {
    query = query.startAfterDocument(lastDocument);
  }

  QuerySnapshot querySnapshot = await query.get();

  List<Map<String, dynamic>> reels = [];
  for (var doc in querySnapshot.docs) {
    reels.add(doc.data() as Map<String, dynamic>);
  }

  return reels;
}

Future<List<Map<String, dynamic>>> fetchAllReels() async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('reelsMeta')
      .orderBy('timestamp', descending: true)
      .limit(10)
      .get();

  List<Map<String, dynamic>> reels = [];
  for (var doc in querySnapshot.docs) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>;
    reels.add(data);
  }

  return reels;
}

Future<void> toggleLikeReel(String reelId, String userId) async {
  DocumentReference reelRef =
      FirebaseFirestore.instance.collection('allReels').doc(reelId);

  // Check if the user has already liked the reel
  DocumentSnapshot reelSnapshot = await reelRef.get();
  Map<String, dynamic>? reelData = reelSnapshot.data() as Map<String, dynamic>;
  List<String>? likes = reelData['likes'];

  if (likes != null && likes.contains(userId)) {
    // If the user has liked the reel, unlike it
    await reelRef.update({
      'likeCount': FieldValue.increment(-1),
      'likes': FieldValue.arrayRemove([userId]),
    });
  } else {
    // If the user hasn't liked the reel, like it
    await reelRef.update({
      'likeCount': FieldValue.increment(1),
      'likes': FieldValue.arrayUnion([userId]),
    });
  }
}

Future<void> addComment(
    String reelId, String userId, String commentText, String username) async {
  CollectionReference commentRef = FirebaseFirestore.instance
      .collection('reelsMeta')
      .doc(reelId)
      .collection('comments');
  await commentRef.add({
    'userId': userId,
    'username': username,
    'commentText': commentText,
    'likeCount': 0,
    'timestamp': FieldValue.serverTimestamp(),
  });
  String commentId = commentRef.id;
}

Future<void> deleteComment(String reelId, String commentId) async {
  DocumentReference commentRef = FirebaseFirestore.instance
      .collection('reelsMeta')
      .doc(reelId)
      .collection('comments')
      .doc(commentId);
  await commentRef.delete();
}

Future<List<Map<String, dynamic>>> fetchCommentsForReel(String reelId) async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('allReels')
      .doc(reelId)
      .collection('comments')
      .orderBy('timestamp', descending: true)
      .get();

  List<Map<String, dynamic>> comments = [];
  for (var doc in querySnapshot.docs) {
    comments.add(doc.data() as Map<String, dynamic>);
  }

  return comments;
}

Future<List<Map<String, dynamic>>> searchReelsByTags(List<String> tags) async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('reelsMeta')
      .where('tags', arrayContainsAny: tags)
      .get();

  List<Map<String, dynamic>> reels = [];
  for (var doc in querySnapshot.docs) {
    reels.add(doc.data() as Map<String, dynamic>);
  }

  return reels;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Permission Request Example')),
        body: PermissionRequestWidget(),
      ),
    );
  }
}

class PermissionRequestWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          PermissionStatus permissionResult =
              await Permission.manageExternalStorage.request();
          if (permissionResult == PermissionStatus.granted) {
            AuthService authInstance = new AuthService();
            var user =
                await authInstance.login("seifswelm@gmail.com", "seif2001");
            var uid = user!.uid;
            var querySnapshot = await FirebaseFirestore.instance
                .collection('users')
                .doc(uid)
                .get();
            String username = querySnapshot.data()?['username'];

            // Reference to Firestore collection
            var usersCollection =
                FirebaseFirestore.instance.collection('users');

            // Show options for capturing video from camera or selecting from gallery
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Capture or Select Video'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () =>
                          captureVideoFromCamera(context, user!.uid, username),
                      child: Text('Capture from Camera'),
                    ),
                    ElevatedButton(
                      onPressed: () =>
                          selectVideoFromGallery(user!.uid, username),
                      child: Text('Select from Gallery'),
                    ),
                  ],
                ),
              ),
            );
          } else {
            // Handle permission denied
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Permission Denied'),
                content: Text(
                    'You denied access to storage. Please grant the permission in the app settings.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      openAppSettings(); // Open app settings
                    },
                    child: Text('Open Settings'),
                  ),
                ],
              ),
            );
          }
        },
        child: Text('Request Storage Permission'),
      ),
    );
  }
}

// // Function to capture video from camera
// Future<void> captureVideoFromCamera(String userId) async {
//   final User? user = FirebaseAuth.instance.currentUser;
//   if (user == null) {
//     // Handle the case where the user is not authenticated
//     print("User is not authenticated.");
//     return;
//   }
//   final pickedFile = await ImagePicker().pickVideo(source: ImageSource.camera);
//   if (pickedFile != null) {
//     String videoFilePath = pickedFile.path;
//     await uploadReel(userId, "hi", videoFilePath, "the best reel22",
//         "I like this reel very much22", ["the", "best", "reel22"]);
//   }
// }

Future<void> captureVideoFromCamera(
    BuildContext context, String userId, String username) async {
  final User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    print("User is not authenticated.");
    return;
  }

  // Request camera permission
  PermissionStatus permissionResult = await Permission.camera.request();
  if (permissionResult == PermissionStatus.granted) {
    // Initialize the camera
    List<CameraDescription> cameras = await availableCameras();
    CameraController controller =
        CameraController(cameras[0], ResolutionPreset.medium);
    await controller.initialize();

    // Show a dialog with camera preview and controls
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            CameraPreview(controller), // Display the camera preview
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FloatingActionButton(
                  child: Icon(Icons.videocam),
                  onPressed: () async {
                    // Start recording
                    await controller.startVideoRecording();
                  },
                ),
                FloatingActionButton(
                  child: Icon(Icons.stop),
                  onPressed: () async {
                    // Stop recording
                    XFile videoFile = await controller.stopVideoRecording();
                    // Upload the video file
                    String videoFilePath = videoFile.path;
                    String reelId = await uploadReel(
                        userId,
                        videoFilePath,
                        "the best reel22445555",
                        "I like this reel very much22445555",
                        ["the", "best", "reel22445555"],
                        username);
                    // Optionally, add a comment after uploading
                    await addComment(reelId, userId, "HIIIIIIII44", username);
                    // Dispose of the controller to free up resources
                    controller.dispose();
                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  } else {
    // Handle permission denied
    print("Camera permission not granted.");
  }
}

// Function to select video from gallery
Future<void> selectVideoFromGallery(String userId, String username) async {
  final User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    // Handle the case where the user is not authenticated
    print("User is not authenticated.");
    return;
  }
  //final pickedFile = await ImagePicker().pickVideo(source: ImageSource.gallery);
  final XFile? pickedFile =
      await ImagePicker().pickVideo(source: ImageSource.gallery);
  if (pickedFile != null) {
    File? galleryFile = File(pickedFile.path);
    String reelId;
    reelId = await uploadReel(userId, pickedFile.path, "Testing 1",
        "I like this reel very much", ["First", "Real", "Reel"], username);
    addComment(reelId, userId, "HIIIIIIII", username);
  }
}
