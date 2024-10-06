
import 'package:flutter/material.dart';
import 'package:stemm_test/constant/colors.dart';

class CommonBorderWidget extends StatelessWidget {
  final String title;
  final String data;
  final Color color;
  final double height;
  const CommonBorderWidget(
      {super.key,
      required this.title,
      this.height = 100,
      required this.data,
      this.color = AppColor.lightGreen});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        alignment: Alignment.center,
        // width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
            color: color,
            width: 3,
          ),
          color: AppColor.darkBlue,
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 3),
                color: Colors.grey.withOpacity(.5),
                blurRadius: 5),
          ],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(data),
          ],
        ));
  }
}
