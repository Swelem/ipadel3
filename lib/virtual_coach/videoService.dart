// import 'package:http/http.dart' as http;
// import 'dart:convert';

// Future<void> summarizeVideo(String videoPath) async {
//   var apiUrl = 'http://localhost:5000/summarize-video';
//   var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
//   request.files.add(await http.MultipartFile.fromPath('video', videoPath));

//   var response = await request.send();
//   if (response.statusCode == 200) {
//     var jsonResponse = json.decode(await response.stream.bytesToString());
//     print('Summary: ${jsonResponse['summary']}');
//     // Update UI with the summary data
//   } else {
//     print('Request failed with status: ${response.statusCode}');
//     // Handle error
//   }
// }

import 'dart:io';
import 'correct_screen.dart';
import 'wrong_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import '/core/app_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:video_player/video_player.dart';
import 'videoService.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';

// void main() {
//   runApp(MyApp());
// }

final Map<String, dynamic> movementUrls = {
  '1': {'url': 'http://44.222.47.114:8000/ready-video', 'class': '0'},
  '2': {'url': 'http://44.222.47.114:8000/ready-video', 'class': '2'},
  '3': {'url': 'http://44.222.47.114:8000/smash-video', 'class': '0'},
  '4': {'url': 'http://44.222.47.114:8000/lob-video', 'class': '0'},
  '5': {'url': 'http://44.222.47.114:8000/volley-video', 'class': '0'},
  '6': {'url': 'http://44.222.47.114:8000/volley-video', 'class': '1'},
};

Future<String> convertTempToMp4(String tempFilePath) async {
  try {
    final tempFile = File(tempFilePath);
    if (await tempFile.exists()) {
      // Read the file as bytes
      final bytes = await tempFile.readAsBytes();

      // Get the directory to save the MP4 file
      final directory = await getApplicationDocumentsDirectory();
      final mp4FilePath = '${directory.path}/output_video.mp4';

      // Save the bytes to the MP4 file
      final mp4File = File(mp4FilePath);
      await mp4File.writeAsBytes(bytes);

      print('MP4 file saved at $mp4FilePath');
      return mp4FilePath;
    } else {
      print('Temp file does not exist');
      return '';
    }
  } catch (e) {
    print('Error converting temp file to MP4: $e');
    return '';
  }
}

Future<void> deleteTempFile(String tempFilePath) async {
  if (tempFilePath != null) {
    final file = File(tempFilePath!);
    if (await file.exists()) {
      await file.delete();
      print('Temp file deleted at $tempFilePath');
    }
  }
}

Future<bool> summarizeVideo(int movement, String mp4FilePath) async {
  bool flag = false;
  //final tempFile = File(videoFile.path);
  // final originalPath = widget.video.path; // Get the original file path
  // final originalFile = File(originalPath);
  // final newPath = originalPath;

  final url = Uri.parse(movementUrls[(movement + 1).toString()]['url']!);

  try {
    var request = http.MultipartRequest('POST', url);
    request.files.add(await http.MultipartFile.fromPath('video', mp4FilePath));
    //request.headers['Content-Type'] = 'multipart/form-data';

    print('Sending request to $url');
    // Log headers for comparison
    print('Request headers: ${request.headers}');
    var response = await request.send();
    var responseData = await response.stream.bytesToString();
    print('Response status: ${response.statusCode}');
    print('Response data: $responseData');

    if (response.statusCode == 200) {
      List<dynamic> summaryList = json.decode(responseData)['summary'];
      String summary = summaryList.isNotEmpty ? summaryList[0].toString() : '';
      print(summary);
      print(movementUrls[(movement + 1).toString()]['class']!);
      if (movementUrls[(movement + 1).toString()]['class']! == summary) {
        print("Response is correct");
        //Get.off(() => CorrectScreen(video: mp4FilePath));
        return flag = true;

        // Get.offNamedUntil(
        //   "/CorrectScreen",
        //   ModalRoute.withName("/HomeScreen"),
        //   arguments: {'video': mp4FilePath, 'movement': movement + 1},
        // );
      } else {
        print("Response is incorrect");
        return flag = false;
        // Get.offNamedUntil(
        //   "/WrongScreen",
        //   ModalRoute.withName("/HomeScreen"),
        //   arguments: {'video': mp4FilePath, 'movement': movement + 1},
        // );
      }

      // setState(() {
      //   _summary = summary;
      // });
    } else {
      print('Request failed with status: ${response.statusCode}');
      return flag;
    }
  } catch (error) {
    print('Error: $error');
  }
  return flag;
}

class MyApp extends StatelessWidget {
  final XFile videoFile;
  final int movementText;
  const MyApp({Key? key, required this.videoFile, required this.movementText})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Summarization App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(video: videoFile, movement: movementText),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final XFile video;
  late int movement;
  MyHomePage({required this.video, required this.movement});

  @override
  _MyHomePageState createState() =>
      _MyHomePageState(videoFile: video, movementText: movement);
}

class _MyHomePageState extends State<MyHomePage> {
  String _summary = '';
  final XFile videoFile;
  final int movementText;
  _MyHomePageState(
      {Key? key, required this.videoFile, required this.movementText});

  // Map of movement types to their respective URLs
  final Map<String, dynamic> movementUrls = {
    '1': {'url': 'http://44.222.47.114:8000/ready-video', 'class': '0'},
    '2': {'url': 'http://44.222.47.114:8000/ready-video', 'class': '2'},
    '3': {'url': 'http://44.222.47.114:8000/smash-video', 'class': '0'},
    '4': {'url': 'http://44.222.47.114:8000/lob-video', 'class': '0'},
    '5': {'url': 'http://44.222.47.114:8000/volley-video', 'class': '0'},
    '6': {'url': 'http://44.222.47.114:8000/volley-video', 'class': '1'},
  };

  Future<String> convertTempToMp4(String tempFilePath) async {
    try {
      final tempFile = File(tempFilePath);
      if (await tempFile.exists()) {
        // Read the file as bytes
        final bytes = await tempFile.readAsBytes();

        // Get the directory to save the MP4 file
        final directory = await getApplicationDocumentsDirectory();
        final mp4FilePath = '${directory.path}/output_video.mp4';

        // Save the bytes to the MP4 file
        final mp4File = File(mp4FilePath);
        await mp4File.writeAsBytes(bytes);

        print('MP4 file saved at $mp4FilePath');
        return mp4FilePath;
      } else {
        print('Temp file does not exist');
        return '';
      }
    } catch (e) {
      print('Error converting temp file to MP4: $e');
      return '';
    }
  }

  Future<void> _deleteMp4File(String mp4FilePath) async {
    if (mp4FilePath != null) {
      final file = File(mp4FilePath!);
      if (await file.exists()) {
        await file.delete();
        print('MP4 file deleted at $mp4FilePath');
      }
    }
  }

  Future<void> summarizeVideo(int movement) async {
    final tempFile = File(videoFile.path);
    final originalPath = widget.video.path; // Get the original file path
    final originalFile = File(originalPath);
    final newPath = originalPath;

    var mp4FilePath = await convertTempToMp4(tempFile.path);
    _deleteMp4File(tempFile.path);
    // try {
    //   if (await tempFile.exists()) {
    //     // Read the file as bytes
    //     final bytes = await tempFile.readAsBytes();
    //     final directory = await getApplicationDocumentsDirectory();
    //     final mp4FilePath = '${directory.path}/output_video.mp4';
    //     final mp4File = File(mp4FilePath);
    //     await mp4File.writeAsBytes(bytes);
    //     print('MP4 file saved at $mp4FilePath');
    //   } else {
    //     print('Temp file does not exist');
    //   }
    // } catch (e) {
    //   print('Error converting temp file to MP4: $e');
    // }

    // if (newPath.endsWith('.temp')) {
    //   // Construct a new file path with the desired name and extension
    //   final newPath = originalPath.replaceAll('.temp', '.mp4');
    //   await originalFile.rename(newPath);
    // } // Example: replace .temp with .mp4

    // Rename the file using Dart's File class

    //print(newPath);
    // movement += 1;
    //final url = Uri.parse('http://44.222.47.114/summarize-video');
    final url = Uri.parse(movementUrls[(movement + 1).toString()]['url']!);

    try {
      var request = http.MultipartRequest('POST', url);
      request.files
          .add(await http.MultipartFile.fromPath('video', mp4FilePath));
      //request.headers['Content-Type'] = 'multipart/form-data';

      print('Sending request to $url');
      // Log headers for comparison
      print('Request headers: ${request.headers}');
      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      print('Response status: ${response.statusCode}');
      print('Response data: $responseData');

      if (response.statusCode == 200) {
        List<dynamic> summaryList = json.decode(responseData)['summary'];
        String summary =
            summaryList.isNotEmpty ? summaryList[0].toString() : '';
        print(summary);
        print(movementUrls[(movement + 1).toString()]['class']!);
        if (movementUrls[(movement + 1).toString()]['class']! == summary) {
          print("Response is correct");
          //Get.off(() => CorrectScreen(video: mp4FilePath));

          Get.offNamedUntil(
            "/CorrectScreen",
            ModalRoute.withName("/HomeScreen"),
            arguments: {'video': mp4FilePath, 'movement': movement + 1},
          );
        } else {
          print("Response is incorrect");
          Get.offNamedUntil(
            "/WrongScreen",
            ModalRoute.withName("/HomeScreen"),
            arguments: {'video': mp4FilePath, 'movement': movement + 1},
          );
        }

        setState(() {
          _summary = summary;
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Summarization App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => summarizeVideo(widget.movement),
              child: Text('Summarize Video'),
            ),
            SizedBox(height: 20),
            Text(
              'Summary: $_summary',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
