import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:stemm_test/constant/colors.dart';
import 'package:stemm_test/views/auth/login_screen.dart';
import 'package:stemm_test/views/chat/chat_list_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      checkLogin();
    });
  }

  checkLogin() async {
    if (auth.currentUser == null) {
      Get.offAll(() => LoginScreen());
    } else {
      Get.offAll(() => const ChatListScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColor.darkBlue,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              SizedBox(
                height: 100,
              ),
              Spacer(),
              Text(
                "STEMM TEST",
                style: TextStyle(fontSize: 25),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Register and chat",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
