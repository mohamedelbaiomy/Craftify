import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../models/product_hotdeals_model.dart';
import '../providers/constants2.dart';

class HomeScreenHotDeals extends StatefulWidget {
  const HomeScreenHotDeals({Key? key}) : super(key: key);

  @override
  State<HomeScreenHotDeals> createState() => _HomeScreenHotDealsState();
}

class _HomeScreenHotDealsState extends State<HomeScreenHotDeals>
    with AutomaticKeepAliveClientMixin<HomeScreenHotDeals> {
  final Stream<QuerySnapshot> _prodcutsStream = FirebaseFirestore.instance
      .collection('products')
      .where('discount', isNotEqualTo: 0)
      .limit(10)
      .snapshots();
  bool shouldKeepAlive = true;

  @override
  bool get wantKeepAlive => shouldKeepAlive;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder<QuerySnapshot>(
      stream: _prodcutsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            Container();
            break;
          default:
            if (snapshot.hasError) {
              return Text(
                'Something went wrong',
                style: TextStyle(
                  fontFamily: 'Dosis',
                  color: textColor,
                  fontSize: 10.sp,
                  letterSpacing: 1.sp,
                ),
              );
            }

            if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  'Check back soon',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Dosis',
                    fontSize: 15.sp,
                    color: Colors.white60,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.sp,
                  ),
                ),
              );
            }

            return AnimationLimiter(
              child: Swiper(
                autoplay: true,
                pagination: const SwiperPagination(),
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  return AnimationConfiguration.synchronized(
                    duration: const Duration(milliseconds: 500),
                    child: SlideAnimation(
                      verticalOffset: 5,
                      horizontalOffset: 5,
                      child: FadeInAnimation(
                        child: ProductHotDealsModel(
                          products: snapshot.data!.docs[index],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
        }
        return Container();
      },
    );
  }
}
