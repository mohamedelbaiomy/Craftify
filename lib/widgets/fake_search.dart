import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../minor_screens/search.dart';
import '../providers/constants2.dart';

/*
class FakeSearch extends StatelessWidget {
  const FakeSearch({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(const SearchScreen(), transition: Transition.upToDown);
      },
      child: Container(
        height: 35,
        decoration: BoxDecoration(
          border: Border.all(color: textColor, width: 1.4),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(
                    Icons.search,
                    color: textColor,
                  ),
                ),
                Text(
                  'What are you looking for?',
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor,
                    fontFamily: 'Dosis',
                  ),
                ),
              ],
            ),
            Container(
              height: 30,
              width: 72,
              decoration: BoxDecoration(
                  color: scaffoldColor,
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: Text(
                  'Search',
                  style: TextStyle(
                      fontFamily: 'Dosis', fontSize: 15, color: textColor),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
*/

class FakeSearch2 extends StatelessWidget {
  const FakeSearch2({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(const SearchScreen(), transition: Transition.upToDown);
      },
      child: Container(
        height: 33.h,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white54, width: 1.3.w),
          borderRadius: BorderRadius.circular(20).r,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10).r,
                  child: Icon(
                    Icons.search,
                    color: textColor,
                  ),
                ),
                Text(
                  'What are you looking for?',
                  style: TextStyle(
                    fontSize: 12.sp,
                    letterSpacing: 1.sp,
                    color: textColor,
                    fontFamily: 'Dosis',
                  ),
                ),
              ],
            ),
/*
            Container(
              height: 20.h,
              width: 35.w,
              margin: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(10).r,
              ),
              child: Center(
                child: Text(
                  'Search',
                  style: TextStyle(
                      fontFamily: 'Dosis', fontSize: 11.sp, color: textColor),
                ),
              ),
            )
*/
          ],
        ),
      ),
    );
  }
}
