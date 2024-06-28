import 'package:flutter/material.dart';
import '/core/app_colors.dart';
import '/core/widgets/custom_text_field.dart';
import '/auth/login_screen.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ipadel3/userauth.dart';
import '../authService.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confpasswordController = TextEditingController();
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
  AuthService authInstance = AuthService();
  String? _errorMessage;
  bool _isPasswordHidden = true;
  bool _isConfirmPasswordHidden = true;
  bool isLoading = false;
  @override
  void dispose() {
    _fnameController.dispose();
    _lnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confpasswordController.dispose();
    _mobileNumberController.dispose();
    _birthdayController.dispose();
    _nationalityController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.thirdColor),
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          color: AppColors.thirdColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        child: SingleChildScrollView(
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "CREATE ACCOUNT",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "Sign up and check our latest updates",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.85,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 30,
                      ),
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          customTextField(
                            controller: _fnameController,
                            hintText: "First Name",
                            obscureText: false,
                          ),
                          customTextField(
                            controller: _lnameController,
                            hintText: "Last Name",
                            obscureText: false,
                          ),
                          customTextField(
                            controller: _emailController,
                            hintText: "E-mail Address",
                            obscureText: false,
                          ),
                          customTextField(
                            controller: _usernameController,
                            hintText: "Username",
                            obscureText: false,
                          ),
                          Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              customTextField(
                                controller: _passwordController,
                                hintText: "Password",
                                obscureText: _isPasswordHidden,
                              ),
                              IconButton(
                                icon: Icon(
                                  _isPasswordHidden
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordHidden = !_isPasswordHidden;
                                  });
                                },
                              ),
                            ],
                          ),
                          Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              customTextField(
                                controller: _confpasswordController,
                                hintText: "Confirm Password",
                                obscureText: _isConfirmPasswordHidden,
                              ),
                              IconButton(
                                icon: Icon(
                                  _isConfirmPasswordHidden
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isConfirmPasswordHidden =
                                        !_isConfirmPasswordHidden;
                                  });
                                },
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (_passwordController.text !=
                                  _confpasswordController.text) {
                                String error = "Passwords do not match";
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(error)));

                                return;
                              } else {
                                setState(() {
                                  isLoading = true; // Start loading
                                });
                                String? error = await authInstance.register(
                                  _emailController.text,
                                  _passwordController.text,
                                  _fnameController.text,
                                  _lnameController.text,
                                  _usernameController.text,
                                );
                                if (error == null) {
                                  // Registration successful, navigate to login screen
                                  Get.offAll(() => LoginScreen(user: null));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(error),
                                    ),
                                  );
                                  // Registration failed, show error message
                                }
                              setState(() {
                                  isLoading = false; // Stop loading
                                });
                              }
                            },
                            child: isLoading
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : Image.asset(
                                    "assets/images/signup.png",
                                    height: 60,
                                  ),
                          ),
                          //  ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "Already have an account?",
                                  style: TextStyle(fontSize: 15),
                                ),
                                const SizedBox(width: 5),
                                GestureDetector(
                                  child: Image.asset(
                                    "assets/images/sign_in.png",
                                    height: 45,
                                  ),
                                  onTap: () {
                                    Get.offAll(() => LoginScreen(user: null));
                                    // Get.off(() => RegisterScreen());
                                    // Get.back();
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                              height: 20), // Add some padding at the bottom
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Image.asset(
                "assets/images/logo_sign_up.png",
                height: 159,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
