import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import 'package:firebase_database/firebase_database.dart';
import 'package:iPadel/userauth.dart';
import 'authService.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _nationalityController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  String? _emailErrorText;
  String? _textErrorText;
  String? _numErrorText;
  String? _passErrorText;
  String? _fnameErrorText;
  String? _lnameErrorText;
  String? _usernameErrorText;

  String? _gender;
  AuthService authInstance = new AuthService();

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
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: label,
            fillColor: Colors.white,
            filled: true,
            errorText: _textErrorText,
          ),
          validator: (value) => _textErrorText,
          onChanged: _validateText,
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget buildLnameField(String label, TextEditingController controller,
      {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: label,
            fillColor: Colors.white,
            filled: true,
            errorText: _lnameErrorText,
          ),
          validator: (value) => _lnameErrorText,
          onChanged: _validateLname,
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget buildFnameField(String label, TextEditingController controller,
      {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: label,
            fillColor: Colors.white,
            filled: true,
            errorText: _fnameErrorText,
          ),
          validator: (value) => _fnameErrorText,
          onChanged: _validateFname,
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget buildUsernameField(String label, TextEditingController controller,
      {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: label,
            fillColor: Colors.white,
            filled: true,
            errorText: _usernameErrorText,
          ),
          validator: (value) => _usernameErrorText,
          onChanged: _validateFname,
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget buildNumberField(String label, TextEditingController controller,
      {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: label,
            fillColor: Colors.white,
            filled: true,
            errorText: _numErrorText,
          ),
          validator: (value) => _numErrorText,
          onChanged: _validateNumber,
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget buildPasswordField(String label, TextEditingController controller,
      {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: label,
            fillColor: Colors.white,
            filled: true,
            errorText: _passErrorText,
          ),
          validator: (value) => _passErrorText,
          onChanged: _validatePassword,
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget buildEmailTextField(String label, TextEditingController controller,
      {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: _emailController,
          obscureText: isPassword,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: label,
            fillColor: Colors.white,
            filled: true,
            errorText: _emailErrorText,
          ),
          validator: (value) => _emailErrorText,
          onChanged: _validateEmail,
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

  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1915, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
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
              buildFnameField('First Name', _fnameController),
              buildLnameField('Last Name', _lnameController),
              buildEmailTextField('Email', _emailController),
              buildUsernameField('Username:', _usernameController),
              buildPasswordField('Password', _passwordController,
                  isPassword: true),
              buildNumberField('Mobile Number', _mobileNumberController),
              //buildTextField('Birthday (YYYY-MM-DD)', _birthdayController),
              Align(
                  alignment: Alignment.topLeft,
                  child: Text("Birthday:",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ))),

              ElevatedButton(
                onPressed: () => _selectDate(context),
                child: const Text('Select date'),
              ),
              Text("${selectedDate.toLocal()}".split(' ')[0],
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 20.0,
              ),
              buildTextField('Nationality', _nationalityController),
              SizedBox(height: 20),
              buildGenderDropdown(),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Sign Up'),
                onPressed: () {
                  //   authInstance.register(
                  //       _emailController.text,
                  //       _passwordController.text,
                  //       _fnameController.text,
                  //       _lnameController.text,
                  //       selectedDate.toString(),
                  //       _mobileNumberController.text,
                  //       _nationalityController.text,
                  //       _gender!,
                  //       _usernameController.text);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white, // Button text color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _validateEmail(String value) {
    if (value.isEmpty) {
      setState(() {
        _emailErrorText = 'Email is required';
      });
    } else if (!isTextValid(value, emailValid)) {
      setState(() {
        _emailErrorText = 'Enter a valid email address';
      });
    } else {
      setState(() {
        _emailErrorText = null;
      });
    }
  }

  void _validateText(String value) {
    if (value.isEmpty) {
      setState(() {
        _textErrorText = 'This Field is required';
      });
    } else if (!isTextValid(value, nameValid)) {
      setState(() {
        _textErrorText = 'Enter valid data';
      });
    } else {
      setState(() {
        _textErrorText = null;
      });
    }
  }

  void _validateLname(String value) {
    if (value.isEmpty) {
      setState(() {
        _lnameErrorText = 'This Field is required';
      });
    } else if (!isTextValid(value, nameValid)) {
      setState(() {
        _lnameErrorText = 'Enter valid Last Name';
      });
    } else {
      setState(() {
        _lnameErrorText = null;
      });
    }
  }

  void _validateFname(String value) {
    if (value.isEmpty) {
      setState(() {
        _fnameErrorText = 'This Field is required';
      });
    } else if (!isTextValid(value, nameValid)) {
      setState(() {
        _fnameErrorText = 'Enter valid First Name';
      });
    } else {
      setState(() {
        _fnameErrorText = null;
      });
    }
  }

  void _validateNumber(String value) {
    if (value.isEmpty) {
      setState(() {
        _numErrorText = 'This Field is required';
      });
    } else if (!isTextValid(value, numValid)) {
      setState(() {
        _numErrorText = 'Enter a valid Number';
      });
    } else {
      setState(() {
        _numErrorText = null;
      });
    }
  }

  void _validatePassword(String value) {
    if (value.isEmpty) {
      setState(() {
        _passErrorText = 'This Field is required';
      });
    } else if (!isTextValid(value, passValid)) {
      setState(() {
        _passErrorText = 'Enter a valid Number';
      });
    } else {
      setState(() {
        _passErrorText = null;
      });
    }
  }

  bool isTextValid(String text, String valid) {
    // Basic validation using regex
    // You can implement more complex validation if needed
    return RegExp(valid).hasMatch(text);
  }

  String nameValid = r'^[a-z]+$';
  String numValid = r'\d';
  String passValid =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  String emailValid = r'^[\w-\.]+@[a-zA-Z]+\.[a-zA-Z]{2,}$';
}
