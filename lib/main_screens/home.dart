import 'dart:math';
import 'package:badges/badges.dart' as badges;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../customer_screens/wishlist.dart';
import '../galleries/HomeScreenHotDeals.dart';
import '../galleries/handmade_gallery.dart';
import '../minor_screens/hot_deals.dart';
import '../providers/constants2.dart';
import '../providers/id_provider.dart';
import '../providers/wish_provider.dart';
import '../widgets/buttons.dart';
import '../widgets/fake_search.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<HomeScreen> {
  late Future<String> documentId = context.read<IdProvider>().getDocumentId();
/*  CollectionReference customers =
      FirebaseFirestore.instance.collection('customers');
  late Future<DocumentSnapshot> future =
      customers.doc(context.read<IdProvider>().getData).get();*/
  List<int> discountList = [];
  int? maxDiscount;
  late BannerAd bannerAd;
  bool isAdLoaded = false;
  var testAdUnitId = "ca-app-pub-3940256099942544/6300978111";

  //----------------------------------------------------------

  var realAdUnitId = "ca-app-pub-2402994909547750/8749307302";

  initBannerAd() {
    bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: testAdUnitId,
      listener: BannerAdListener(onAdLoaded: (ad) {
        setState(() {
          isAdLoaded = true;
        });
      }, onAdFailedToLoad: (ad, error) {
        ad.dispose();
      }),
      request: const AdRequest(),
    );
    bannerAd.load();
  }

  @override
  void initState() {
    super.initState();
    getDiscount();
    initBannerAd();
    documentId = context.read<IdProvider>().getDocumentId();
    //future = customers.doc(context.read<IdProvider>().getData).get();
  }

  Future<void> onRefresh() async {}

  void getDiscount() {
    FirebaseFirestore.instance.collection('products').get().then(
      (QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          discountList.add(doc['discount']);
        }
      },
    ).whenComplete(() => setState(() {
          maxDiscount = discountList.reduce(max);
        }));
  }

  bool shouldKeepAlive = true;

  @override
  bool get wantKeepAlive => shouldKeepAlive;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    /* SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: scaffoldColor,
        statusBarColor: scaffoldColor,
      ),
    );*/
    /* TabController tabController = TabController(length: 1, vsync: this);
    Lequid refresh indecator
     showChildOpacityTransition: false,
    color: textColor,
    backgroundColor: scaffoldColor,
    onRefresh: () async {
    setState(() {});
    },*/
    return Scaffold(
      backgroundColor: scaffoldColor,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
/*
      appBar: AppBar(
        backgroundColor: scaffoldColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "Good Morning",
          style: TextStyle(
            fontFamily: 'Dosis',
            color: textColor,
            fontSize: 13,
            letterSpacing: 1,
          ),
        ),
        leading: const Padding(
          padding: EdgeInsets.only(right: 0, left: 10),
          child: CircleAvatar(
            backgroundImage: AssetImage(
              'images/logo.png',
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(const WishlistScreen(),
                  transition: Transition.rightToLeftWithFade);
            },
            icon: badges.Badge(
              showBadge:
                  context.read<Wish>().getWishItems.isEmpty ? false : true,
              badgeContent: Text(
                context.watch<Wish>().getWishItems.length.toString(),
                style: TextStyle(
                  fontFamily: 'Dosis',
                  color: textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              child: context.read<Wish>().getWishItems.isEmpty
                  ? Icon(
                      Icons.heart_broken_outlined,
                      color: textColor,
                    )
                  : Icon(
                      FontAwesomeIcons.solidHeart,
                      color: textColor,
                    ),
            ),
          ),
        ],
      ),
*/
      body: ListView(
        shrinkWrap: true,
        // physics: const BouncingScrollPhysics(),
        children: [
          Container(
            height: 132.h,
            width: double.infinity.w,
            padding: const EdgeInsets.symmetric(horizontal: 16).r,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/BackGround.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 1.w),
                    Text(
                      'Find the best \ngift for you.',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Get.to(
                          const WishlistScreen(),
                          transition: Transition.rightToLeftWithFade,
                        );
                      },
                      icon: badges.Badge(
                        showBadge: context.read<Wish>().getWishItems.isEmpty
                            ? false
                            : true,
                        badgeContent: Text(
                          context.watch<Wish>().getWishItems.length.toString(),
                          style: TextStyle(
                            fontFamily: 'Dosis',
                            color: textColor,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        child: context.read<Wish>().getWishItems.isEmpty
                            ? Icon(
                                Icons.heart_broken_outlined,
                                color: textColor,
                              )
                            : Icon(
                                FontAwesomeIcons.solidHeart,
                                color: textColor,
                              ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: const EdgeInsets.only(left: 75).r,
                  child: const FakeSearch2(),
                )
              ],
            ),
          ),
          SizedBox(height: 8.h),
          SizedBox(
            height: 47.h,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(7).r,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Our hot deals",
                    style: TextStyle(
                      fontFamily: 'Dosis',
                      fontSize: 18.sp,
                      color: textColor,
                      letterSpacing: 2.sp,
                    ),
                  ),
                  CommonButton(
                    title: 'Shop Now',
                    onPressed: () {
                      Get.to(
                        HotDealsScreen(
                          maxDiscount: maxDiscount.toString(),
                        ),
                        transition: Transition.cupertinoDialog,
                      );
                    },
                    borderRadius: 13,
                    width: 0.27.w,
                    height: 24.h,
                    borderColor: Colors.white54,
                    textColor: textColor,
                    fillColor: scaffoldColor,
                    letterSpacing: 1.sp,
                  ),
                ],
              ),
            ),
          ),
          /* const Padding(
            padding: EdgeInsets.only(
              right: 5,
              left: 5,
              bottom: 5,
            ),
            child: Center(child: FakeSearch()),
          ),*/
          Center(
            child: SizedBox(
              height: 145.h,
              width: 345.w,
              child: const HomeScreenHotDeals(),
            ),
          ),
          SizedBox(height: 8.h),
          Divider(
            color: textColor,
            endIndent: 40.sp,
            indent: 40.sp,
          ),
/*
                  TabBar(
                    controller: tabController,
                    isScrollable: true,
                    padding: const EdgeInsets.only(left: 5),
                    indicatorColor: textColor,
                    tabs: const [
                      RepeatedTab(label: 'Handmade'),
                    ],
                  ),

                  Expanded(
                    child: TabBarView(
                      physics: const BouncingScrollPhysics(
                        decelerationRate: ScrollDecelerationRate.fast,
                      ),
                      clipBehavior: Clip.antiAlias,
                      dragStartBehavior: DragStartBehavior.start,
                      controller: tabController,
                      children: const [
                        HandmadeGalleryScreen(),
                      ],
                    ),
                  ),*/
          const HandmadeGalleryScreen(),
        ],
      ),
    );
  }
}

class RepeatedTab extends StatelessWidget {
  final String label;

  const RepeatedTab({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Dosis',
          color: textColor,
          fontSize: 14,
          letterSpacing: 1,
        ),
      ),
    );
  }
}
