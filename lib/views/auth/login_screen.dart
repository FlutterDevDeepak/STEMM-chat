import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stemm_test/constant/colors.dart';
import 'package:stemm_test/controller/auth_controller.dart';
import 'package:stemm_test/views/auth/register_screen.dart';
import 'package:stemm_test/widgets/my_textfield.dart';
import '../../constant/app_text.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final authController = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                SizedBox(
                  height: size.height / 6,
                ),
                const Text(
                  "STEMM CHAT",
                  style: TextStyle(fontSize: 25),
                ),
                Text(
                  AppStrings.signIn,
                  textAlign: TextAlign.center,
                  style: theme.displayLarge!.copyWith(fontWeight: FontWeight.bold, fontSize: 30),
                ),
                const SizedBox(
                  height: 20,
                ),
                MyCustomTextField(
                  hint: AppStrings.emailHint,
                  controller: authController.emailController,
                ),
                MyCustomTextField(
                  toggle: () {
                    authController.togglePass();
                  },
                  hint: AppStrings.passHint,
                  controller: authController.passwordController,
                  isPassword: true,
                ),
                const SizedBox(
                  height: 25,
                ),
                Obx(() {
                  return InkWell(
                    onTap: () async {
                      bool res = await authController.loginUser();

                      if (res == true) {
                        debugPrint(res.toString());
                        // Get.offAll(() => Sign());
                      }
                      debugPrint(res.toString());
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
                              AppStrings.signIn,
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
                      AppStrings.donTAccount,
                      style: theme.displayMedium!.copyWith(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(() => RegisterScreen());
                      },
                      child: Text(
                        AppStrings.signUp,
                        style: theme.displayMedium!.copyWith(fontWeight: FontWeight.bold, fontSize: 15, color: AppColor.orange),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
