import 'package:flutter/material.dart';
import 'homepage.dart';
import 'authService.dart';
import 'loginScreen.dart';

// void main() {
//   runApp(ProfilePage());
// }

class ProfilePage extends StatefulWidget {
  final user; // Add user field

  ProfilePage({required this.user});
  @override
  _ProfilePageState createState() => _ProfilePageState(user: user);
}

class _ProfilePageState extends State<ProfilePage> {
  final user; // Add user field

  _ProfilePageState({required this.user});
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        color: Color.fromARGB(255, 76, 160, 243), // baby blue color
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Contact Us information
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Text('Contact Us:'),
                      Text('Phone: +201153240059'),
                      Text(
                          'Location: Airport road off Ring Road, behind Nozha Airport, Alexandria, Egypt'),
                    ],
                  ),
                ),
              ),
              // Logout and About Us buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      AuthService authService = AuthService();
                      // Logout logic here
                      // Assuming you are using FirebaseAuth for authentication
                      await authService.logout();
                      ;
                      // Navigate to the login screen
                      Navigator.popUntil(context, (route) => route.isFirst);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginScreen(user: null)),
                      );
                    },
                    child: Text('Logout'),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to About Us page
                    },
                    child: Text('About Us'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        clipBehavior: Clip.antiAlias,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => homepage(user: user)),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                // Add logic here
              },
            ),
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                setState(() {
                  _currentIndex = 1;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
