import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:customers_app_google_play/main_screens/customer_home.dart';
import 'package:customers_app_google_play/providers/constants2.dart';
import 'package:provider/provider.dart';

import '../providers/id_provider.dart';

const textColors = [
  Colors.white54,
  Colors.white,
  Colors.amber,
  Colors.grey,
  Colors.purple,
  Colors.teal,
];

class ThanksScreen extends StatefulWidget {
  const ThanksScreen({Key? key}) : super(key: key);

  @override
  State<ThanksScreen> createState() => _ThanksScreenState();
}

class _ThanksScreenState extends State<ThanksScreen> {
  late String docId;

  @override
  void initState() {
    AudioPlayer().play(
      AssetSource(
        'sounds/checkout.mp3',
      ),
    );
    docId = context.read<IdProvider>().getData;
    Timer(
      const Duration(seconds: 3),
      () {
        Get.offUntil(
          MaterialPageRoute(
            builder: (context) => const CustomerHomeScreen(),
          ),
          (route) => false,
        );
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: scaffoldColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/inapp/check.png',
                    color: Colors.white,
                    filterQuality: FilterQuality.high,
                    width: 150,
                  ),
                  SizedBox(height: 40.h),
                  AnimatedTextKit(
                    repeatForever: true,
                    animatedTexts: [
                      ColorizeAnimatedText(
                        "Thanks for using Craftify",
                        textStyle: TextStyle(
                          fontSize: 30.sp,
                          fontFamily: 'Dosis',
                        ),
                        colors: textColors,
                      ),
                    ],
                  ),
                  SizedBox(height: 30.h),
                  Text(
                    "You will be directed to home screen\n",
                    style: TextStyle(
                      color: textColor,
                      fontSize: 15.sp,
                      fontFamily: 'Dosis',
                      letterSpacing: 0.5.sp,
                    ),
                  ),
                  Text(
                    "automatically",
                    style: TextStyle(
                      color: textColor,
                      fontSize: 15.sp,
                      fontFamily: 'Dosis',
                      letterSpacing: 0.5.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
