import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stemm_test/constant/colors.dart';
import 'package:stemm_test/controller/auth_controller.dart';

class MyCustomTextField extends StatelessWidget {
  final TextInputType? inputType;
  final bool isPassword;
  final Function? toggle;
  final String hint;
  final TextEditingController controller;

  MyCustomTextField({
    this.inputType,
    required this.controller,
    this.toggle,
    required this.hint,
    this.isPassword = false,
    super.key,
  });
  final authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    TextTheme theme = Theme.of(context).textTheme;
    return Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: TextFormField(
          keyboardType: inputType,
          controller: controller,
          style: theme.displayMedium!.copyWith(fontSize: 16),
          autocorrect: false,
          obscureText:
              isPassword == true ? authController.showPassword.value : false,
          cursorColor: AppColor.white,
          decoration: InputDecoration(
            suffixIcon: isPassword
                ? Obx(() {
                    return InkWell(
                      onTap: () {
                        toggle!();
                      },
                      child: authController.showPassword.value == true
                          ? const Icon(
                              Icons.remove_red_eye_outlined,
                              color: AppColor.orange,
                            )
                          : const Icon(
                              Icons.visibility_off,
                              color: AppColor.orange,
                            ),
                    );
                  })
                : null,
            hintText: hint,
            hintStyle: theme.bodyLarge,
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColor.orange),
            ),
          ),
          validator: (v) {
            if (v!.isEmpty) {
              return "Required";
            }
            return null;
          },
        ));
  }
}
