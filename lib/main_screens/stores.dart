import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:customers_app_google_play/main_screens/visit_store.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import '../providers/constants2.dart';
import '../widgets/appbar_widgets.dart';
import 'dart:async';

class StoresScreen extends StatefulWidget {
  const StoresScreen({super.key});

  @override
  State<StoresScreen> createState() => _StoresScreenState();
}

class _StoresScreenState extends State<StoresScreen>
    with AutomaticKeepAliveClientMixin<StoresScreen> {
  final Stream<QuerySnapshot> suppliersStream =
      FirebaseFirestore.instance.collection('suppliers').snapshots();
  bool shouldKeepAlive = true;

  @override
  bool get wantKeepAlive => shouldKeepAlive;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
  GlobalKey<LiquidPullToRefreshState>();

  Future<void> _handleRefresh() {
    final Completer<void> completer = Completer<void>();
    Timer(const Duration(seconds: 1), () {
      completer.complete();
    });
    setState(() {});
    return completer.future.then<void>((_) {
      ScaffoldMessenger.of(_scaffoldKey.currentState!.context).showSnackBar(
        SnackBar(
          content: const Text('Refresh complete'),
          action: SnackBarAction(
            label: 'RETRY',
            backgroundColor: Colors.white,
            textColor: Colors.black,
            onPressed: () {
              _refreshIndicatorKey.currentState!.show();
            },
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: scaffoldColor,
        title: const AppBarTitle(title: 'Stores'),
      ),
      body: LiquidPullToRefresh(
        key: _refreshIndicatorKey,
        onRefresh: _handleRefresh,
        showChildOpacityTransition: false,
        backgroundColor: scaffoldColor,
        color: textColor,
        child: StreamBuilder<QuerySnapshot>(
          stream: suppliersStream,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return AnimationLimiter(
                child: StaggeredGridView.countBuilder(
                  shrinkWrap: true,
                  /*physics: const BouncingScrollPhysics(
                    decelerationRate: ScrollDecelerationRate.normal,
                    parent: AlwaysScrollableScrollPhysics(),
                  ),*/
                  crossAxisCount: 1,
                  staggeredTileBuilder: (context) => const StaggeredTile.fit(1),
                  mainAxisSpacing: 20.h,
                  padding: const EdgeInsets.only(
                    bottom: 15,
                    top: 15,
                  ).r,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return AnimationConfiguration.staggeredGrid(
                      position: index,
                      duration: const Duration(seconds: 2),
                      columnCount: snapshot.data!.docs.length,
                      child: FadeInAnimation(
                        child: GestureDetector(
                          onTap: () {
                            Get.to(
                              VisitStore(
                                suppId: snapshot.data!.docs[index]['sid'],
                              ),
                              transition: Transition.leftToRightWithFade,
                            );
                          },
                          child: Column(
                            children: [
                              SizedBox(
                                height: 170.h,
                                width: 260.w,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10).r,
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot.data!.docs[index]
                                        ['storelogo'],
                                    filterQuality: FilterQuality.medium,
                                    fit: BoxFit.cover,
                                    fadeInCurve: Curves.fastOutSlowIn,
                                    placeholder: (context, url) =>
                                        const SpinKitRotatingCircle(
                                      color: Colors.white60,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Lottie.asset(
                                      "assets/json/imageError.json",
                                      filterQuality: FilterQuality.high,
                                      height: 50.h,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 15.h),
                              Text(
                                snapshot.data!.docs[index]['storename']
                                    .toUpperCase(),
                                style: TextStyle(
                                  fontFamily: 'Dosis',
                                  fontSize: 24.sp,
                                  letterSpacing: 1.sp,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
            return Container(); /*const Center(
              child: Text(
                'No Stores yet => Loading ..',
                style: TextStyle(
                    fontFamily: 'Dosis', color: textColor, fontSize: 25),
              ),
            );*/
          },
        ),
      ),
    );
  }
}
