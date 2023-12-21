import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _nationalityController = TextEditingController();

  String? _gender;

  Widget buildTextField(String label, TextEditingController controller,
      {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: label,
            fillColor: Colors.white,
            filled: true,
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        fillColor: Colors.white,
        filled: true,
      ),
      value: _gender,
      hint: Text('Select Gender'),
      items: <String>['Male', 'Female'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _gender = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xffe3f2fd),
              Color(0xffbbdefb),
              Color(0xff90caf9),
              Color(0xff64b5f6),
              Color(0xff42a5f5),
              Color(0xff2196f3),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              buildTextField('Email', _emailController),
              buildTextField('Password', _passwordController, isPassword: true),
              buildTextField('Mobile Number', _mobileNumberController),
              buildTextField('Birthday (YYYY-MM-DD)', _birthdayController),
              buildTextField('Nationality', _nationalityController),
              SizedBox(height: 20),
              buildGenderDropdown(),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Sign Up'),
                onPressed: () {
                  // Handle sign up logic
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white, // Button background color
                  onPrimary: Colors.black, // Button text color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
