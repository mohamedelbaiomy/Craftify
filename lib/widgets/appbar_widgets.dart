import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';

import '../providers/constants2.dart';

class AppBarBackButton extends StatelessWidget {
  final Function() onPressed;
  const AppBarBackButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        PixelArtIcons.arrow_left,
        color: textColor,
        size: 15.5.sp,
      ),
      onPressed: onPressed,
    );
  }
}

class BlackBackButton extends StatelessWidget {
  const BlackBackButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.arrow_back_ios_new,
        color: buttonsColor,
      ),
      onPressed: () {
        Get.back();
      },
    );
  }
}

class AppBarTitle extends StatelessWidget {
  const AppBarTitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: textColor,
        fontSize: 20,
        letterSpacing: 1.5,
        fontFamily: 'Dosis',
      ),
    );
  }
}
