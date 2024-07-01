import 'package:flutter/material.dart';
import '/core/app_colors.dart';
import '/core/widgets/custom_text_field.dart';
import '/auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:iPadel/userauth.dart';
import '../authService.dart';

class ForgotPassScreen extends StatefulWidget {
  @override
  _ForgotPassScreenState createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  final TextEditingController _emailController = TextEditingController();

  String? _emailErrorText;
  AuthService authInstance = AuthService();
  String? _errorMessage;
  bool isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    setState(() {
      isLoading = true; // Start loading
    });
    try {
      await authInstance.resetPassword(_emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password reset email sent'),
        ),
      );
      Get.offAll(() => LoginScreen(user: null));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${error.toString()}'),
        ),
      );
    }
    setState(() {
      isLoading = false; // Stop loading
    });
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
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Forgot your Password?",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Enter your Email",
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
                height: MediaQuery.of(context).size.height * 0.75,
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
                  child: Column(
                    children: [
                      customTextField(
                        controller: _emailController,
                        hintText: "E-mail Address",
                        obscureText: false,
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () async {
                          await _resetPassword();
                        },
                        child: isLoading
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : Image.asset(
                                "assets/images/submit.png",
                                height: 60,
                              ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Remembered Your Password?",
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
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // const SizedBox(height: 20), // Add some padding at the bottom
              // Image.asset(
              //   "assets/images/logo_sign_up.png",
              //   height: 159,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
