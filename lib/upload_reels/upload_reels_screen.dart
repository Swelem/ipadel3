import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '/core/app_colors.dart';
import '/core/widgets/custom_text_field.dart';
import '../reelService.dart'; // Import your reelService file
import 'package:get/get.dart';

File? _video;

class UploadReelsScreen extends StatefulWidget {
  final user;

  const UploadReelsScreen({required this.user});

  @override
  State<UploadReelsScreen> createState() => _UploadReelsScreenState(user: user);
}

class _UploadReelsScreenState extends State<UploadReelsScreen> {
  TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  var user;
  bool _isUploading = false; // Track upload state

  _UploadReelsScreenState({required this.user});

  @override
  void initState() {
    super.initState();
    user = widget.user;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<File?> _getVideo(ImageSource source) async {
    final pickedFile = await ImagePicker().pickVideo(source: source);

    setState(() {
      if (pickedFile != null) {
        _video = File(pickedFile.path);
        print(_video?.path);
      } else {
        print('No video selected.');
      }
    });
    return _video;
  }

  void _startUpload() async {
    setState(() {
      _isUploading = true; // Start uploading
    });

    if (_video != null) {
      File? galleryFile = File(_video!.path);

      var uid = user.uid;

      var querySnapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      String username = querySnapshot.data()?['username'];

      try {
        await uploadReel(
          uid,
          galleryFile.path,
          _titleController.text,
          _descController.text,
          _tagsController.text.split(','), // Split tags into a list
          username,
        );

        // Show success message or navigate to another screen upon successful upload
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Reel uploaded successfully!'),
          ),
        );
      } catch (e) {
        // Handle specific errors thrown by uploadReel function
        String errorMessage = 'Failed to upload reel';
        if (e is FirebaseException) {
          // Handle Firebase-related errors
          errorMessage = 'Firebase Error: ${e.message}';
        } else if (e is FormatException) {
          // Handle format-related errors
          errorMessage = 'Invalid format: $e';
        } else {
          // Handle generic errors
          errorMessage = 'Error: $e';
        }

        // Show error message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
          ),
        );
      } finally {
        setState(() {
          _isUploading = false; // Finish uploading
        });
      }
    } else {
      // Show error message for no video selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No video selected.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primaryColor),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "Upload Reel",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Divider(
              color: AppColors.thirdColor,
              endIndent: 200,
            ),
            Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  customTextField(
                      controller: _titleController, hintText: "Title"),
                  customTextField(
                      controller: _descController, hintText: "Caption"),
                  customTextField(
                      controller: _tagsController, hintText: "Tags"),
                  GestureDetector(
                    onTap: () async {
                      _video = await _getVideo(ImageSource.gallery) as File?;
                      _startUpload();
                    },
                    child: Container(
                      height: 60, // Set a specific height for the container
                      child: Image.asset(
                        "assets/images/upload_video.png",
                        height: 60,
                      ),
                    ),
                  ),
                  SizedBox(height: 20), // Adjust spacing as needed
                  if (_isUploading)
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
