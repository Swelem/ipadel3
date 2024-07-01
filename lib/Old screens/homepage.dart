import 'package:flutter/material.dart';
import 'package:iPadel/myreels.dart';
import 'Loginscreen.dart';
import 'profle.dart';
import 'reels.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: homepage(),
//     );
//   }
// }

// class homepage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text("home page"),
//         ),
//         body: Container(
//           color: Colors.lightBlue[100],
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ElevatedButton(
//                   onPressed: () {},
//                   style: ElevatedButton.styleFrom(
//                     fixedSize: Size(200, 50),
//                   ),
//                   child: Text("News Feed"),
//                 ),
//                 SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => ReelsPage()),
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     fixedSize: Size(200, 50),
//                   ),
//                   child: Text("Reels"),
//                 ),
//                 SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: () {},
//                   style: ElevatedButton.styleFrom(
//                     fixedSize: Size(200, 50),
//                   ),
//                   child: Text("Available Coaches"),
//                 ),
//                 SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: () {},
//                   style: ElevatedButton.styleFrom(
//                     fixedSize: Size(200, 50),
//                   ),
//                   child: Text("AI Coach"),
//                 ),
//                 SizedBox(height: 32),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     ElevatedButton.icon(
//                       onPressed: () {},
//                       style: ElevatedButton.styleFrom(
//                         fixedSize: Size(50, 50),
//                       ),
//                       icon: Icon(Icons.home),
//                       label: SizedBox.shrink(),
//                     ),
//                     ElevatedButton.icon(
//                       onPressed: () {},
//                       style: ElevatedButton.styleFrom(
//                         fixedSize: Size(50, 50),
//                       ),
//                       icon: Icon(Icons.add),
//                       label: SizedBox.shrink(),
//                     ),
//                     ElevatedButton.icon(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => ProfilePage()),
//                         );
//                       },
//                       style: ElevatedButton.styleFrom(
//                         fixedSize: Size(50, 50),
//                       ),
//                       icon: Icon(Icons.person),
//                       label: SizedBox.shrink(),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
class homepage extends StatelessWidget {
  final user; // Add user field

  homepage({required this.user}); // Constructor
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("home page"),
      ),
      body: Container(
        color: Colors.lightBlue[100],
        padding:
            EdgeInsets.all(16), // Add padding to create space between buttons
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {},
                // Remove fixedSize constraint
                // style: ElevatedButton.styleFrom(
                //   fixedSize: Size(200, 50),
                // ),
                child: Text("News Feed"),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ReelsPage2(user: user)),
                  );
                },
                // Remove fixedSize constraint
                // style: ElevatedButton.styleFrom(
                //   fixedSize: Size(200, 50),
                // ),
                child: Text("Reels"),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {},
                // Remove fixedSize constraint
                // style: ElevatedButton.styleFrom(
                //   fixedSize: Size(200, 50),
                // ),
                child: Text("Available Coaches"),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {},
                // Remove fixedSize constraint
                // style: ElevatedButton.styleFrom(
                //   fixedSize: Size(200, 50),
                // ),
                child: Text("AI Coach"),
              ),
              SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {},
                    // Remove fixedSize constraint
                    // style: ElevatedButton.styleFrom(
                    //   fixedSize: Size(50, 50),
                    // ),
                    icon: Icon(Icons.home),
                    label: SizedBox.shrink(),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {},
                    // Remove fixedSize constraint
                    // style: ElevatedButton.styleFrom(
                    //   fixedSize: Size(50, 50),
                    // ),
                    icon: Icon(Icons.add),
                    label: SizedBox.shrink(),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfilePage(user: user)),
                      );
                    },
                    // Remove fixedSize constraint
                    // style: ElevatedButton.styleFrom(
                    //   fixedSize: Size(50, 50),
                    // ),
                    icon: Icon(Icons.person),
                    label: SizedBox.shrink(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
