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

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Summarization App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _summary = '';

  Future<void> _summarizeVideo() async {
    final url = Uri.parse('http://192.168.1.6:5000/summarize-video');

    try {
      var request = http.MultipartRequest('POST', url);
      Directory? downloadsDir = await getDownloadsDirectory();
      request.files.add(await http.MultipartFile.fromPath(
        'video',
        '/storage/emulated/0/Download/test.mp4', // Provide the video file path
      ));

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      List<dynamic> summaryList = json.decode(responseData)['summary'];
      String summary = summaryList.isNotEmpty ? summaryList[0].toString() : '';

      setState(() {
        _summary = summary;
      });
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
              onPressed: _summarizeVideo,
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
