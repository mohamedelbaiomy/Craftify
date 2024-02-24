import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../minor_screens/product_details.dart';
import '../providers/constants2.dart';

class ProductHotDealsModel extends StatefulWidget {
  final dynamic products;

  const ProductHotDealsModel({Key? key, required this.products})
      : super(key: key);

  @override
  State<ProductHotDealsModel> createState() => _ProductHotDealsModelState();
}

class _ProductHotDealsModelState extends State<ProductHotDealsModel> {
  @override
  Widget build(BuildContext context) {
    var onSale = widget.products['discount'];
    return InkWell(
      onTap: () {
        Get.to(
          ProductDetailsScreen(
            proList: widget.products,
          ),
          transition: Transition.rightToLeftWithFade,
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 5, left: 5, top: 5).r,
        child: Stack(
          children: [
            SizedBox(
              width: double.infinity.w,
              height: 210.h,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5).r,
                clipBehavior: Clip.antiAlias,
                child: CachedNetworkImage(
                  imageUrl: widget.products['proimages'][0],
                  fit: BoxFit.fill,
                  height: 210.h,
                  filterQuality: FilterQuality.high,
                  fadeInCurve: Curves.fastOutSlowIn,
                  placeholder: (context, url) => SpinKitThreeBounce(
                    color: Colors.white60,
                    size: 25.sp,
                  ),
                  errorWidget: (context, url, error) => Lottie.asset(
                    "assets/json/imageError.json",
                    filterQuality: FilterQuality.high,
                    repeat: true,
                    height: 45.h,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            onSale != 0
                ? Positioned(
                    top: 30.sp,
                    left: 0,
                    child: Container(
                      height: 24.h,
                      width: 78.w,
                      decoration: BoxDecoration(
                        color: scaffoldColor,
                        borderRadius: BorderRadius.only(
                          topRight: const Radius.circular(10).r,
                          bottomRight: const Radius.circular(10).r,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Save ${onSale.toString()} %',
                          style: TextStyle(
                            fontFamily: 'Dosis',
                            color: textColor,
                            letterSpacing: 1.sp,
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(
                    color: Colors.transparent,
                  ),
          ],
        ),
      ),
    );
  }
}
