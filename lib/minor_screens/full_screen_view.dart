import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lottie/lottie.dart';
import 'package:customers_app_google_play/providers/constants2.dart';

import '../widgets/appbar_widgets.dart';

class FullScreenView extends StatefulWidget {
  final List<dynamic> imagesList;
  const FullScreenView({Key? key, required this.imagesList}) : super(key: key);

  @override
  State<FullScreenView> createState() => _FullScreenViewState();
}

class _FullScreenViewState extends State<FullScreenView> {
  final PageController _controller = PageController();
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: scaffoldColor,
        leading: AppBarBackButton(
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    backgroundColor: Colors.grey.shade200,
                    child: SizedBox(
                      height: 240.h,
                      width: 280.h,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(height: 18.h),
                          Lottie.asset(
                            "assets/json/126953-zoom-in.json",
                            filterQuality: FilterQuality.high,
                            repeat: true,
                            height: 100.h,
                            fit: BoxFit.cover,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12).r,
                            child: Text(
                              "You can zoom in",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20.sp,
                                letterSpacing: 1.sp,
                                fontFamily: 'Dosis',
                              ),
                            ),
                          ),
                          MaterialButton(
                            onPressed: () {
                              Get.back();
                            },
                            color: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13).r,
                            ),
                            child: Text(
                              "Close",
                              style: TextStyle(
                                fontFamily: 'Dosis',
                                color: Colors.white,
                                letterSpacing: 1.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            icon: Icon(
              PixelArtIcons.notification,
              size: 20.sp,
              color: Colors.white60,
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Center(
            child: Text(
              ('${index + 1}') + ('/') + (widget.imagesList.length.toString()),
              style: TextStyle(
                fontFamily: 'Dosis',
                fontSize: 17.sp,
                letterSpacing: 8.sp,
                color: textColor,
              ),
            ),
          ),
          SizedBox(
            height: 300.h,
            child: PageView(
              onPageChanged: (value) {
                setState(
                  () {
                    index = value;
                  },
                );
              },
              controller: _controller,
              children: images(),
            ),
          ),
          SizedBox(
            height: 130.h,
            child: imageView(),
          )
        ],
      ),
    );
  }

  Widget imageView() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: widget.imagesList.length,
      /* physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics(),
      ),*/
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            _controller.jumpToPage(index);
          },
          child: Container(
            margin: const EdgeInsets.all(7).r,
            width: 140.w,
            decoration: BoxDecoration(
              border: Border.all(width: 3.w, color: Colors.black),
              borderRadius: BorderRadius.circular(10).r,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(9).r,
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
                imageUrl: widget.imagesList[index],
                placeholder: (context, url) => SpinKitThreeBounce(
                  color: Colors.white60,
                  size: 15.sp,
                ),
                errorWidget: (context, url, error) => Lottie.asset(
                  "assets/json/imageError.json",
                  filterQuality: FilterQuality.high,
                  height: 45.h,
                  width: 200.w,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> images() {
    return List.generate(
      widget.imagesList.length,
      (index) {
        return Padding(
          padding: const EdgeInsets.all(10).r,
          child: InteractiveViewer(
            transformationController: TransformationController(),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(7).r,
              child: CachedNetworkImage(
                imageUrl: widget.imagesList[index].toString(),
                filterQuality: FilterQuality.high,
                fit: BoxFit.cover,
                placeholder: (context, url) => SpinKitThreeBounce(
                  color: Colors.white60,
                  size: 25.sp,
                ),
                errorWidget: (context, url, error) => Lottie.asset(
                  "assets/json/imageError.json",
                  filterQuality: FilterQuality.high,
                  height: 45.sp,
                  width: 200.w,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
