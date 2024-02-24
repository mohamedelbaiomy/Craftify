import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customers_app_google_play/widgets/Delayed_Widget_Code.dart';
import 'package:customers_app_google_play/widgets/appbar_widgets.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:lottie/lottie.dart';
import 'package:customers_app_google_play/providers/id_provider.dart';
import 'package:open_settings/open_settings.dart';
import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:url_launcher/url_launcher.dart';
import '../minor_screens/ask_upload.dart';
import '../models/store_model.dart';
import '../providers/constants2.dart';
import '../widgets/buttons.dart';

class VisitStore extends StatefulWidget {
  final String suppId;
  const VisitStore({Key? key, required this.suppId}) : super(key: key);

  @override
  State<VisitStore> createState() => _VisitStoreState();
}

class _VisitStoreState extends State<VisitStore> {
  bool following = false;
  String customerId = "";

  List<String> subscriptionList = [];
  checkUserSubscription() {
    FirebaseFirestore.instance
        .collection('suppliers')
        .doc(widget.suppId)
        .collection('subscriptions')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        subscriptionList.add(doc['customerid']);
      }
    }).whenComplete(() {
      following = subscriptionList.contains(context.read<IdProvider>().getData);
    });
  }

  @override
  void initState() {
    customerId = context.read<IdProvider>().getData;
    customerId == "" ? null : checkUserSubscription();
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
      GlobalKey<LiquidPullToRefreshState>();

  Future<void> _handleRefresh() {
    final Completer<void> completer = Completer<void>();
    Timer(const Duration(seconds: 1), () {
      completer.complete();
    });
    setState(() {
      customerId = context.read<IdProvider>().getData;
      customerId == "" ? null : checkUserSubscription();
    });
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

  CollectionReference suppliers =
      FirebaseFirestore.instance.collection('suppliers');

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> prodcutsStream = FirebaseFirestore.instance
        .collection('products')
        .where('sid', isEqualTo: widget.suppId)
        .snapshots();
    return FutureBuilder<DocumentSnapshot>(
      future: suppliers.doc(widget.suppId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Something went wrong",
                  style: TextStyle(
                    fontFamily: 'Dosis',
                    letterSpacing: 1.sp,
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 23.sp,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  "You have to Log In",
                  style: TextStyle(
                    fontFamily: 'Dosis',
                    letterSpacing: 1.sp,
                    color: Colors.white60,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                  ),
                ),
                SizedBox(height: 10.h),
                Container(
                  height: 32.h,
                  width: 60.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: textColor),
                  ),
                  child: MaterialButton(
                    onPressed: () {
                      Get.offNamed('/customer_login');
                    },
                    child: Text(
                      'Log In',
                      style: TextStyle(fontFamily: 'Dosis', color: textColor),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Document does not exist",
                  style: TextStyle(
                    fontFamily: 'Dosis',
                    color: textColor,
                    fontSize: 17.sp,
                    letterSpacing: 0.5.sp,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "talk to the founder",
                      style: TextStyle(
                        fontFamily: 'Dosis',
                        color: textColor,
                        fontSize: 18.sp,
                        letterSpacing: 1.sp,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        var whatsapp = "+201009429689";
                        final Uri url = Uri.parse(
                            "whatsapp://send?phone=$whatsapp&text=Document Existence in the app and i need the solution ( Store page )");
                        Future<void> _launchUrl() async {
                          if (!await launchUrl(
                            url,
                            mode: LaunchMode.externalApplication,
                          )) {
                            throw 'Could not launch $url';
                          }
                        }

                        _launchUrl();
                      },
                      icon: const Icon(
                        FontAwesomeIcons.whatsapp,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Material(
            color: scaffoldColor,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinKitWaveSpinner(
                    color: textColor,
                    size: 45.sp,
                  ),
                  SizedBox(height: 50.h),
                  DelayedWidget(
                    delayDuration: const Duration(seconds: 4),
                    child: Text(
                      "Check Your Connection",
                      style: TextStyle(
                        fontFamily: 'Dosis',
                        fontSize: 16.sp,
                        decoration: TextDecoration.none,
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.4.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            backgroundColor: scaffoldColor,
/*
            appBar: AppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: 80.h,
              flexibleSpace: data['coverimage'] == ''
                  ? Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          filterQuality: FilterQuality.high,
                          fit: BoxFit.fill,
                          image: AssetImage(
                            "images/coverimage.jpg",
                          ),
                        ),
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          filterQuality: FilterQuality.high,
                          fit: BoxFit.fill,
                          image: CachedNetworkImageProvider(
                            data['coverimage'],
                          ),
                        ),
                      ),
                    ),
              backgroundColor: Colors.transparent,
              leading: const AppBarBackButton(),
              title: Row(
                children: [
                  Container(
                    height: 75.h,
                    width: 80.w,
                    decoration: BoxDecoration(
                      border: Border.all(width: 2.w, color: Colors.black),
                      borderRadius: BorderRadius.circular(35).r,
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        filterQuality: FilterQuality.high,
                        image: CachedNetworkImageProvider(
                          data['storelogo'],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 95.h,
                    width: 185.w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['storename'].toUpperCase(),
                          style: TextStyle(
                            fontFamily: 'Dosis',
                            letterSpacing: 1.sp,
                            fontSize: 17.sp,
                            color: textColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        customerId == ""
                            ? SizedBox(height: 24.h)
                            : StatefulBuilder(
                                builder: (BuildContext context,
                                    StateSetter setState) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      CommonButton(
                                        borderRadius: 7.sp,
                                        title: following == true
                                            ? 'following'
                                            : 'FOLLOW',
                                        onPressed: following == false
                                            ? () {
                                                FirebaseMessaging.instance
                                                    .subscribeToTopic(
                                                        'Mohamed');
                                                String id = context
                                                    .read<IdProvider>()
                                                    .getData;
                                                FirebaseFirestore.instance
                                                    .collection('suppliers')
                                                    .doc(widget.suppId)
                                                    .collection('subscriptions')
                                                    .doc(id)
                                                    .set({
                                                  'customerid': id,
                                                });
                                                setState(() {
                                                  following = true;
                                                });
                                              }
                                            : () {
                                                FirebaseMessaging.instance
                                                    .unsubscribeFromTopic(
                                                        'Mohamed');
                                                String id = context
                                                    .read<IdProvider>()
                                                    .getData;
                                                FirebaseFirestore.instance
                                                    .collection('suppliers')
                                                    .doc(widget.suppId)
                                                    .collection('subscriptions')
                                                    .doc(id)
                                                    .delete();
                                                setState(() {
                                                  following = false;
                                                });
                                              },
                                        width: 0.21.w,
                                        height: 24.h,
                                        borderColor: following == false
                                            ? textColor
                                            : scaffoldColor,
                                        textColor: following == false
                                            ? textColor
                                            : scaffoldColor,
                                        fillColor: following == false
                                            ? scaffoldColor
                                            : textColor,
                                        letterSpacing: 1,
                                      ),
                                      CommonButton(
                                        borderRadius: 7.sp,
                                        title: "Ask",
                                        onPressed: () {
                                          Get.to(
                                            AskScreen(suppId: widget.suppId),
                                            transition:
                                                Transition.leftToRightWithFade,
                                          );
                                        },
                                        width: 0.16.w,
                                        height: 24.h,
                                        borderColor: scaffoldColor,
                                        textColor: scaffoldColor,
                                        fillColor: textColor,
                                        letterSpacing: 2.sp,
                                      ),
                                    ],
                                  );
                                },
                              ),
                      ],
                    ),
                  )
                ],
              ),
            ),
*/
            body: LiquidPullToRefresh(
              key: _refreshIndicatorKey,
              onRefresh: _handleRefresh,
              showChildOpacityTransition: false,
              backgroundColor: scaffoldColor,
              color: textColor,
              child: Stack(
                children: [
                  data['coverimage'] == ''
                      ? SizedBox(
                          height: 100.h,
                          width: double.infinity,
                          child: Image.asset(
                            "assets/images/coverimage.jpg",
                            filterQuality: FilterQuality.high,
                            fit: BoxFit.fill,
                            repeat: ImageRepeat.repeat,
                          ),
                        )
                      : SizedBox(
                          height: 100.h,
                          width: double.infinity,
                          child: CachedNetworkImage(
                            imageUrl: data['coverimage'],
                            filterQuality: FilterQuality.high,
                            fit: BoxFit.fill,
                            repeat: ImageRepeat.repeat,
                            placeholder: (context, url) =>
                                const SpinKitThreeBounce(
                              color: Colors.white60,
                              size: 30,
                            ),
                            errorWidget: (context, url, error) => Lottie.asset(
                              "assets/json/imageError.json",
                              filterQuality: FilterQuality.high,
                              height: 50,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                  Positioned(
                    top: 45.sp,
                    child: AppBarBackButton(
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ),
                  Positioned(
                    top: 60.sp,
                    left: 140.sp,
                    child: Container(
                      height: 75.h,
                      width: 80.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        //border: Border.all(width: 2.w, color: Colors.black),
                        //borderRadius: BorderRadius.circular(35).r,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.high,
                          image: CachedNetworkImageProvider(
                            data['storelogo'],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 420).r,
                    child: Center(
                      child: Text(
                        data['storename'].toUpperCase(),
                        style: TextStyle(
                          fontFamily: 'Dosis',
                          letterSpacing: 1.sp,
                          fontSize: 17.sp,
                          color: textColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 115.sp,
                    width: 360.sp,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 20.sp,
                        right: 20.sp,
                      ),
                      child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CommonButton(
                                borderRadius: 7.sp,
                                title:
                                    following == true ? 'following' : 'FOLLOW',
                                onPressed: following == false
                                    ? () {
                                        FirebaseMessaging.instance
                                            .subscribeToTopic(
                                                "${widget.suppId}store");
                                        String id =
                                            context.read<IdProvider>().getData;
                                        FirebaseFirestore.instance
                                            .collection('suppliers')
                                            .doc(widget.suppId)
                                            .collection('subscriptions')
                                            .doc(id)
                                            .set({
                                          'customerid': id,
                                        });
                                        setState(() {
                                          following = true;
                                        });
                                      }
                                    : () {
                                        FirebaseMessaging.instance
                                            .unsubscribeFromTopic(
                                                "${widget.suppId}store");
                                        String id =
                                            context.read<IdProvider>().getData;
                                        FirebaseFirestore.instance
                                            .collection('suppliers')
                                            .doc(widget.suppId)
                                            .collection('subscriptions')
                                            .doc(id)
                                            .delete();
                                        setState(() {
                                          following = false;
                                        });
                                      },
                                width: 0.20.w,
                                height: 24.h,
                                borderColor: following == false
                                    ? textColor
                                    : scaffoldColor,
                                textColor: following == false
                                    ? textColor
                                    : scaffoldColor,
                                fillColor: following == false
                                    ? scaffoldColor
                                    : textColor,
                                letterSpacing: 0.5,
                              ),
                              following != true
                                  ? const SizedBox()
                                  : Padding(
                                      padding:
                                          const EdgeInsets.only(right: 110).r,
                                      child: IconButton(
                                        onPressed: () async {
                                          await OpenSettings
                                              .openNotificationSetting();
                                        },
                                        icon: Icon(
                                          Icons.edit_notifications,
                                          color: Colors.grey,
                                          size: 20.sp,
                                        ),
                                      ),
                                    ),
                              CommonButton(
                                borderRadius: 7.sp,
                                title: "ask",
                                onPressed: () {
                                  customerId == ""
                                      ? logInDialog(context)
                                      : Get.to(
                                          AskScreen(suppId: widget.suppId),
                                          transition:
                                              Transition.leftToRightWithFade,
                                        );
                                },
                                width: 0.18.w,
                                height: 24.h,
                                borderColor: scaffoldColor,
                                textColor: scaffoldColor,
                                fillColor: textColor,
                                letterSpacing: 2.sp,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 190).r,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: prodcutsStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Something went wrong",
                                  style: TextStyle(
                                    fontFamily: 'Dosis',
                                    letterSpacing: 1.sp,
                                    color: textColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 23.sp,
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                Text(
                                  "You have to Log In",
                                  style: TextStyle(
                                    fontFamily: 'Dosis',
                                    letterSpacing: 1.sp,
                                    color: Colors.white60,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.sp,
                                  ),
                                ),
                                SizedBox(height: 15.h),
                                Container(
                                  height: 32.h,
                                  width: 70.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8).r,
                                    border: Border.all(color: textColor),
                                  ),
                                  child: MaterialButton(
                                    onPressed: () {
                                      Get.offNamed('/customer_login');
                                    },
                                    child: Text(
                                      'Log In',
                                      style: TextStyle(
                                          fontFamily: 'Dosis',
                                          color: textColor),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return productsSpinkit;
                        }

                        if (snapshot.data!.docs.isEmpty) {
                          return Center(
                            child: Text(
                              'This Store \n\n has no items yet !',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Dosis',
                                fontSize: 22.sp,
                                color: textColor,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.4.sp,
                              ),
                            ),
                          );
                        }

                        return AnimationLimiter(
                          child: StaggeredGridView.countBuilder(
                            padding: EdgeInsets.zero,
                            /*physics: const BouncingScrollPhysics(
                              decelerationRate: ScrollDecelerationRate.normal,
                            ),*/
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            crossAxisCount: 2,
                            itemBuilder: (context, index) {
                              return AnimationConfiguration.staggeredGrid(
                                position: index,
                                duration: const Duration(milliseconds: 900),
                                columnCount: snapshot.data!.docs.length,
                                child: SlideAnimation(
                                  verticalOffset: 70,
                                  child: FadeInAnimation(
                                    child: StoreModel(
                                      products: snapshot.data!.docs[index],
                                    ),
                                  ),
                                ),
                              );
                            },
                            staggeredTileBuilder: (context) =>
                                const StaggeredTile.fit(1),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Center(child: gallariesSpinkit);
      },
    );
  }

  void logInDialog(context) {
    showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(
          "please log in",
          style: TextStyle(
            fontFamily: 'Dosis',
            letterSpacing: 1.sp,
          ),
        ),
        content: Text(
          "you should be logged in to take an action",
          style: TextStyle(
            fontFamily: 'Dosis',
            letterSpacing: 1.sp,
          ),
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            child: Text(
              "Cancel",
              style: TextStyle(
                fontFamily: 'Dosis',
                letterSpacing: 1.sp,
              ),
            ),
            onPressed: () {
              Get.back();
            },
          ),
          CupertinoDialogAction(
            child: Text(
              "Log In",
              style: TextStyle(
                fontFamily: 'Dosis',
                letterSpacing: 1.sp,
              ),
            ),
            onPressed: () {
              Get.offNamed('/customer_login');
            },
          ),
        ],
      ),
    );
  }
}
