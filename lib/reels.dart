import 'package:flutter/material.dart';
import 'homepage.dart';

import 'package:flutter/material.dart';
import 'homepage.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: ReelsPage(),
//     );
//   }
// }

class ReelsPage extends StatelessWidget {
  final user; // Add user field

  ReelsPage({required this.user});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reels"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              color: Colors.yellow[100],
              child: Center(
                child: Text("Reel 1"),
              ),
            ),
            Container(
              height: 200,
              color: Colors.yellow[200],
              child: Center(
                child: Text("Reel 2"),
              ),
            ),
            Container(
              height: 200,
              color: Colors.yellow[300],
              child: Center(
                child: Text("Reel 3"),
              ),
            ),
            Container(
              height: 200,
              color: Colors.yellow[400],
              child: Center(
                child: Text("Reel 4"),
              ),
            ),
            Container(
              height: 200,
              color: Colors.yellow[500],
              child: Center(
                child: Text("Reel 5"),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => homepage(user: user)),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
