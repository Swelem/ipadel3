import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/core/app_colors.dart';
import '/auth/register_screen.dart';
import '/home/home_screen.dart';
import '../authService.dart';
import 'package:get/get.dart';
import 'forgetpass_screen.dart';

class LoginScreen extends StatefulWidget {
  final user; // Add user field

  LoginScreen({required this.user});
  @override
  _LoginScreenState createState() => _LoginScreenState(user: user);
}

class _LoginScreenState extends State<LoginScreen> {
  var user;
  _LoginScreenState({required this.user});
  bool isRememberMe = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  AuthService authInstance = new AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool isValidEmail(String email) {
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegExp.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              child: Image.asset("assets/images/logo.png", height: 269),
            ),
            const SizedBox(height: 20),
            Container(
              alignment: Alignment.center,
              child: Image.asset("assets/images/login_text.png", height: 32),
            ),
            const SizedBox(height: 40),
            Stack(
              alignment: Alignment.centerRight,
              children: [
                Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: 78,
                      margin: const EdgeInsets.only(right: 100),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(100)),
                        color: Colors.white,
                        border: Border.all(
                          color: AppColors.secondColor, // Border color
                          width: 2, // Border width
                        ),
                      ),
                      child: TextFormField(
                        controller: _emailController,
                        cursorColor: AppColors.primaryColor,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Email",
                          hintStyle: TextStyle(
                            color: AppColors.secondColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          prefixIcon: Icon(Icons.person,
                              size: 35, color: AppColors.secondColor),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(
                              RegExp(r'\s')), // Disallow spaces
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 78,
                      margin: const EdgeInsets.only(right: 100),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(100)),
                        color: Colors.white,
                        border: Border.all(
                          color: AppColors.secondColor, // Border color
                          width: 2, // Border width
                        ),
                      ),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        cursorColor: AppColors.primaryColor,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Password",
                          hintStyle: TextStyle(
                            color: AppColors.secondColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          prefixIcon: Icon(Icons.lock,
                              size: 35, color: AppColors.secondColor),
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  right: 70,
                  child: GestureDetector(
                    onTap: () async {
                      if (!isValidEmail(_emailController.text)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Please enter a valid email address.'),
                          ),
                        );
                        return;
                      }

                      user = await authInstance.login(
                          _emailController.text, _passwordController.text);
                      if (user != null) {
                        Get.offAll(() => HomeScreen(user: user));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Login failed. Please check your credentials.'),
                          ),
                        );
                      }
                    },
                    child: CircleAvatar(
                      backgroundColor: AppColors.secondColor,
                      radius: 40,
                      child: Image.asset("assets/images/arrow.png", height: 78),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: GestureDetector(
                    onTap: () {
                      Get.to(() => ForgotPassScreen());
                    },
                    child: Image.asset("assets/images/forget_password.png",
                        width: 150),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                Get.to(() => RegisterScreen());
              },
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.60),
                height: 52,
                decoration: const BoxDecoration(
                  color: AppColors.thirdColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: const Text(
                  "SIGN UP",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
