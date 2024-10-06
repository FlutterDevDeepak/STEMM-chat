import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stemm_test/constant/colors.dart';
import 'package:stemm_test/controller/auth_controller.dart';
import 'package:stemm_test/views/auth/login_screen.dart';
import 'package:stemm_test/widgets/my_textfield.dart';
import '../../constant/app_text.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});
  final authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    TextTheme theme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 35,
              ),
              const Text(
                "STEMM CHAT",
                style: TextStyle(fontSize: 25),
              ),
              Text(
                AppStrings.signUp,
                textAlign: TextAlign.center,
                style: theme.displayLarge!.copyWith(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              const SizedBox(
                height: 20,
              ),
              Obx(() {
                return CircleAvatar(
                  backgroundImage: authController.profileImage.value == "" ? null : FileImage(File(authController.profileImage.value)),
                  radius: 60,
                  child: IconButton(
                      onPressed: () {
                        authController.pickImage();
                      },
                      icon: const Icon(Icons.photo_camera_back)),
                );
              }),
              MyCustomTextField(
                hint: AppStrings.nameHint,
                controller: authController.nameController,
              ),
              MyCustomTextField(
                inputType: TextInputType.emailAddress,
                hint: AppStrings.emailHint,
                controller: authController.emailController,
              ),
              Builder(builder: (context) {
                return MyCustomTextField(
                  toggle: () {
                    authController.togglePass();
                  },
                  hint: AppStrings.passHint,
                  isPassword: true,
                  controller: authController.passwordController,
                );
              }),
              MyCustomTextField(
                toggle: () {
                  authController.togglePass();
                },
                hint: AppStrings.confPassHint,
                isPassword: true,
                controller: authController.confirmPasswordController,
              ),
              const SizedBox(
                height: 25,
              ),
              Obx(() {
                return InkWell(
                  onTap: () async {
                    if (authController.passwordController.text != authController.confirmPasswordController.text) {
                      Get.snackbar("Oh no!", "Password and Confirm password should be same");
                    } else {
                      bool res = await authController.registerUser();

                      if (res == true) {
                        debugPrint(res.toString());
                        Get.to(() => LoginScreen());
                      }
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      gradient: const LinearGradient(
                        colors: [
                          AppColor.orange,
                          AppColor.lightOrange,
                        ],
                      ),
                    ),
                    child: authController.isLoading.value == true
                        ? const CircularProgressIndicator(
                            color: AppColor.white,
                          )
                        : Text(
                            AppStrings.signUp,
                            style: theme.displayMedium!.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                  ),
                );
              }),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppStrings.alreadyAccount,
                    style: theme.displayMedium!.copyWith(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(() => LoginScreen());
                    },
                    child: Text(
                      AppStrings.signIn,
                      style: theme.displayMedium!.copyWith(fontWeight: FontWeight.bold, fontSize: 15, color: AppColor.orange),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      )),
    );
  }
}
