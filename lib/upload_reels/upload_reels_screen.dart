import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import "../reelService.dart";
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '/core/app_colors.dart';
import '/core/widgets/custom_text_field.dart';
import 'package:wave_linear_progress_indicator/wave_linear_progress_indicator.dart';

File? _video;
TextEditingController _titleController = TextEditingController();
final TextEditingController _descController = TextEditingController();
final TextEditingController _tagsController = TextEditingController();

class UploadReelsScreen extends StatefulWidget {
  final user;
  const UploadReelsScreen({required this.user});

  @override
  State<UploadReelsScreen> createState() => _UploadReelsScreenState(user: user);
}

class _UploadReelsScreenState extends State<UploadReelsScreen> {
  var user;
  _UploadReelsScreenState({required this.user});

  Future<void> _getVideo(ImageSource source) async {
    final pickedFile = await ImagePicker().pickVideo(source: source);

    setState(() {
      if (pickedFile != null) {
        _video = File(pickedFile.path);
        print(_video?.path);
      } else {
        print('No video selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "Hi, User",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(
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
                      _getVideo(ImageSource.gallery);

                      if (_video != null) {
                        File? galleryFile = File(_video!.path);

                        var uid = user.uid;
                        print(uid + "hi");
                        var querySnapshot = await FirebaseFirestore.instance
                            .collection('users')
                            .doc(uid)
                            .get();
                        String username = querySnapshot.data()?['username'];
                        print(username + "hi");
                        await uploadReel(
                            user.uid,
                            galleryFile.path,
                            _titleController.text,
                            _descController.text,
                            _tagsController.text
                                .split(','), // Split tags into a list
                            username);
                      }
                    },
                    child: Container(
                      height: 60, // Set a specific height for the container
                      child: Image.asset(
                        "assets/images/upload_video.png",
                        height: 60,
                      ),
                    ),
                  ),
                  SizedBox(height: 79),
                  WaveLinearProgressIndicator(
                    value: 0.1,
                    enableBounceAnimation: true,
                    waveColor: AppColors.primaryColor,
                    color: AppColors.primaryColor,
                    waveBackgroundColor:
                        AppColors.primaryColor.withOpacity(0.1),
                    backgroundColor: Colors.grey[150],
                    minHeight: 20,
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
