import 'package:customers_app_google_play/widgets/appbar_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:customers_app_google_play/providers/constants2.dart';
import 'package:icons_plus/icons_plus.dart';

class ContactMe extends StatefulWidget {
  const ContactMe({super.key});

  @override
  State<ContactMe> createState() => _ContactMeState();
}

class _ContactMeState extends State<ContactMe> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        backgroundColor: scaffoldColor,
        elevation: 0,
        leading: AppBarBackButton(
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 800),
            delay: const Duration(milliseconds: 400),
            childAnimationBuilder: (widget) => SlideAnimation(
              horizontalOffset: 10,
              child: FadeInAnimation(
                child: widget,
              ),
            ),
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 800),
                  //delay: const Duration(milliseconds: 800),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    horizontalOffset: 20,
                    child: FadeInAnimation(
                      child: widget,
                    ),
                  ),
                  children: [
                    SizedBox(width: 5.w),
                    SizedBox(
                      height: 130.h,
                      width: 140.w,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10).r,
                        child: Image.asset(
                          filterQuality: FilterQuality.high,
                          fit: BoxFit.cover,
                          "assets/images/Contact_me.jpg",
                        ),
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Mohamed Elbaiomy",
                          style: TextStyle(
                            fontFamily: "EnglishSC",
                            letterSpacing: 1.sp,
                            fontSize: 21.sp,
                            fontWeight: FontWeight.w200,
                            color: textColor,
                          ),
                        ),
                        SizedBox(height: 15.h),
                        Text(
                          "Studying at Faculty of Computers &\nArtificial Intelligence Benha University",
                          style: TextStyle(
                            fontFamily: "Dosis",
                            letterSpacing: 1.sp,
                            fontSize: 10.sp,
                            color: textColor,
                          ),
                        ),
                        SizedBox(height: 15.h),
                        Text(
                          "وَمَا كَانَ اللَّهُ مُعَذِّبَهُمْ وَهُمْ يَسْتَغْفِرُونَ",
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontFamily: "Dosis",
                            letterSpacing: 1.sp,
                            fontSize: 11.sp,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25.h),
              Padding(
                padding: const EdgeInsets.only(left: 5).r,
                child: Align(
                  alignment: AlignmentDirectional.topStart,
                  child: Text(
                    "Craftify",
                    style: TextStyle(
                      color: textColor,
                      fontSize: 22.sp,
                      letterSpacing: 3.sp,
                      fontFamily: 'EnglishSC',
                      fontWeight: FontWeight.w500,
                    ),
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              Padding(
                padding: const EdgeInsets.only(left: 17).r,
                child: Align(
                  alignment: AlignmentDirectional.topStart,
                  child: Text(
                    "an online application that allows users to purchase handmade items from artisans and Crafters around Egypt. "
                    "It provides a convenient way for customers to find unique, one-of-a-kind items that are not available in stores. "
                    "\n\nThe application features a wide selection of handmade items ranging from clothing, home decor and more. "
                    "Customers can browse through the different categories to find the perfect item for their needs."
                    "\n\nThe application also offers secure payment options and fast shipping to ensure customer satisfaction. "
                    "With its easy-to-use interface and wide selection of handmade products, this e-commerce application is an ideal choice for those looking for unique gifts or special items.",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14.sp,
                      letterSpacing: 1.9.sp,
                      fontFamily: 'Dosis',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Padding(
                padding: const EdgeInsets.only(left: 5, bottom: 10).r,
                child: Text(
                  "Technologies",
                  style: TextStyle(
                    color: textColor,
                    fontSize: 15.sp,
                    letterSpacing: 3.sp,
                    fontFamily: 'Dosis',
                    fontWeight: FontWeight.bold,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              /*Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Logo(Logos.flutter),
                  Logo(Logos.firebase),
                ],
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
