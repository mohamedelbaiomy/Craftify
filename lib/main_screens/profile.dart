import 'dart:async';
import 'package:customers_app_google_play/widgets/avatar_glow.dart';
import 'package:icons_plus/icons_plus.dart';
//import '../widgets/Delayed_Widget_Code.dart';
import '../widgets/auto_direction.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:customers_app_google_play/customer_screens/address_book.dart';
import 'package:customers_app_google_play/minor_screens/contact_us.dart';
import 'package:customers_app_google_play/providers/auth_repo.dart';
//import 'package:customers_app_google_play/widgets/buttons.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import '../auth/customer_login.dart';
import '../customer_screens/customer_asks.dart';
import '../customer_screens/customer_orders.dart';
import '../customer_screens/wishlist.dart';
import '../minor_screens/edit_profile.dart';
import '../minor_screens/update_password.dart';
import '../providers/constants2.dart';
import '../providers/id_provider.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/appbar_widgets.dart';
import 'cart.dart';

class ProfileScreen extends StatefulWidget {
  /*final String documentId;*/
  const ProfileScreen({super.key /*, required this.documentId*/
      });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin<ProfileScreen> {
  bool shouldKeepAlive = true;

  @override
  bool get wantKeepAlive => shouldKeepAlive;
  late Future<String> documentId = context.read<IdProvider>().getDocumentId();
  late String docId;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
      GlobalKey<LiquidPullToRefreshState>();

  Future<void> _handleRefresh() {
    final Completer<void> completer = Completer<void>();
    Timer(
      const Duration(seconds: 1),
      () {
        completer.complete();
      },
    );
    setState(() {
      documentId = context.read<IdProvider>().getDocumentId();
      docId = context.read<IdProvider>().getData;
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

  CollectionReference customers =
      FirebaseFirestore.instance.collection('customers');

  /*CollectionReference anonymous =
      FirebaseFirestore.instance.collection('anonymous');*/
  clearUserId() {
    context.read<IdProvider>().clearCustomerId();
  }

  @override
  void initState() {
    documentId = context.read<IdProvider>().getDocumentId();
    docId = context.read<IdProvider>().getData;
    super.initState();
  }

  String userAddress(dynamic data) {
    if (docId == '') {
      return 'example : apartment_number - state - governorate';
    } else if (docId != '' && data['address'] == '') {
      return 'Set Your Address';
    }
    return data['address'];
  }

  void logInDialog() {
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
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    String docId = context.read<IdProvider>().getData;
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: LiquidPullToRefresh(
        key: _refreshIndicatorKey,
        onRefresh: _handleRefresh,
        showChildOpacityTransition: false,
        backgroundColor: scaffoldColor,
        color: textColor,
        child: StreamBuilder<DocumentSnapshot>(
          stream: /*FirebaseFirestore.instance
              .collection('customers')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),*/
              customers
                  .doc(
                    docId.isNotEmpty
                        ? docId
                        : FirebaseAuth.instance.currentUser!.uid,
                  )
                  .snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
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
                        fontSize: 22.sp,
                      ),
                    ),
                    SizedBox(height: 15.h),
                    Text(
                      "You have to Log In",
                      style: TextStyle(
                        fontFamily: 'Dosis',
                        letterSpacing: 1.sp,
                        color: Colors.white60,
                        fontWeight: FontWeight.bold,
                        fontSize: 19.sp,
                      ),
                    ),
                    SizedBox(height: 15.h),
                    Container(
                      height: 32.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10).r,
                        border: Border.all(color: textColor),
                      ),
                      child: MaterialButton(
                        onPressed: () {
                          Get.offNamed('/customer_login');
                        },
                        child: Text(
                          'Log In',
                          style:
                              TextStyle(fontFamily: 'Dosis', color: textColor),
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
                      "User does not exist",
                      style: TextStyle(
                        fontFamily: 'Dosis',
                        color: textColor,
                        fontSize: 20.sp,
                        letterSpacing: 0.5.sp,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "talk to the founder",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Dosis',
                            color: textColor,
                            fontSize: 15.sp,
                            letterSpacing: 1.sp,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            var whatsapp = "+201009429689";
                            final Uri url = Uri.parse(
                                "whatsapp://send?phone=$whatsapp&text=Document Existence in the app and i need the solution");
                            Future<void> laaunchUrl() async {
                              if (!await launchUrl(
                                url,
                                mode: LaunchMode.externalApplication,
                              )) {
                                throw 'Could not launch $url';
                              }
                            }

                            laaunchUrl();
                          },
                          icon: const Icon(
                            FontAwesomeIcons.whatsapp,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          documentId =
                              context.read<IdProvider>().getDocumentId();
                          docId = context.read<IdProvider>().getData;
                        });
                      },
                      icon: const Icon(Icons.refresh),
                    ),
                  ],
                ),
              );
            }
            /* if (snapshot.connectionState == ConnectionState.waiting) {
              return CustomScrollView(
                */
            /*physics: const BouncingScrollPhysics(
                decelerationRate: ScrollDecelerationRate.normal,
              ),*/
            /*
                shrinkWrap: true,
                slivers: [
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    centerTitle: true,
                    elevation: 4,
                    pinned: true,
                    backgroundColor: scaffoldColor,
                    expandedHeight: 120.h,
                    flexibleSpace: LayoutBuilder(
                      builder: (context, constraints) {
                        return FlexibleSpaceBar(
                          title: AnimatedOpacity(
                            duration: const Duration(milliseconds: 50),
                            opacity: constraints.biggest.height <= 120 ? 1 : 0,
                            child: Text(
                              'Profile',
                              style: TextStyle(
                                fontFamily: 'Dosis',
                                letterSpacing: 1.sp,
                                color: textColor,
                              ),
                            ),
                          ),
                          centerTitle: true,
                          background: Container(
                            decoration: BoxDecoration(
                              image: const DecorationImage(
                                fit: BoxFit.cover,
                                filterQuality: FilterQuality.high,
                                image: AssetImage(
                                  'images/coverprofile.jpg',
                                ),
                              ),
                              borderRadius: BorderRadius.circular(20).r,
                            ),
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              children: [
                                SizedBox(width: 15.w),
                                Container(
                                  width: 100.w,
                                  margin: const EdgeInsets.only(
                                    top: 20,
                                    right: 10,
                                  ).r,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      filterQuality: FilterQuality.high,
                                      image: AssetImage(
                                        'images/inapp/guest.jpg',
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5.w),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AutoDirection(
                                      text: 'guest'.toUpperCase(),
                                      child: Text(
                                        'guest'.toUpperCase(),
                                        style: TextStyle(
                                          fontFamily: 'Dosis',
                                          letterSpacing: 1.sp,
                                          color: scaffoldColor,
                                          fontSize: 20.sp,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 15.h),
                                    Text(
                                      "reward points : 0",
                                      style: TextStyle(
                                        fontFamily: 'Dosis',
                                        color: scaffoldColor,
                                        letterSpacing: 2.sp,
                                        fontSize: 13.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        SizedBox(height: 10.h),
                        const ProfileHeaderLabel(headerLabel: '  Account Info  '),
                        ListTile(
                          leading: const Icon(
                            BoxIcons.bxl_gmail,
                            color: Colors.white60,
                          ),
                          subtitle: Text(
                            'example@email.com',
                            style: TextStyle(
                              fontFamily: 'Dosis',
                              color: Colors.white60,
                              fontSize: 12.sp,
                              letterSpacing: 1.sp,
                            ),
                          ),
                          title: Text(
                            'Email Address',
                            style: TextStyle(
                              fontFamily: 'Dosis',
                              color: textColor,
                              letterSpacing: 1.sp,
                            ),
                          ),
                        ),
                        const GreyDivider(),
                        RepeatedListTile(
                          onPressed: () {},
                          icon: BoxIcons.bx_book_bookmark,
                          subTitle: "see your pending orders",
                          title: 'Orders',
                        ),
                        const GreyDivider(),
                        RepeatedListTile(
                          onPressed: () {},
                          icon: BoxIcons.bx_question_mark,
                          subTitle: "see your pending asks",
                          title: 'Ask',
                        ),
                        const GreyDivider(),
                        RepeatedListTile(
                          onPressed: () {},
                          subTitle: "check out now",
                          icon: BoxIcons.bx_shopping_bag,
                          title: 'Cart',
                        ),
                        const GreyDivider(),
                        RepeatedListTile(
                          onPressed: () {},
                          icon: Iconsax.heart_tick,
                          subTitle: "browse your favourite products",
                          title: 'WishList',
                        ),
                        const GreyDivider(),
                        RepeatedListTile(
                          onPressed: () {},
                          icon: LineAwesome.location_arrow_solid,
                          subTitle: 'example : Qaliubia - Egypt',
                          title: 'Address',
                        ),
                        SizedBox(height: 20.h),
                        const ProfileHeaderLabel(
                            headerLabel: '  Account Settings  '),
                        SizedBox(height: 10.h),
                        SizedBox(
                          height: 400.h,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              RepeatedListTile(
                                title: 'Edit Profile',
                                subTitle: 'edit your information',
                                icon: LineAwesome.edit,
                                onPressed: () {},
                              ),
                              const GreyDivider(),
                              RepeatedListTile(
                                title: 'Change Password',
                                subTitle: 'edit your entry password',
                                icon: BoxIcons.bx_lock,
                                onPressed: () {},
                              ),
                              const GreyDivider(),
                              RepeatedListTile(
                                title: 'About',
                                subTitle: 'waiting for your message anytime',
                                icon: PixelArtIcons.paperclip,
                                onPressed: () {
                                  Get.to(
                                    const ContactMe(),
                                    transition: Transition.rightToLeftWithFade,
                                  );
                                },
                              ),
                              const GreyDivider(),
                              RepeatedListTile(
                                title: 'Log Out',
                                icon: BoxIcons.bx_log_out,
                                onPressed: () async {},
                              ),
                              SizedBox(height: 15.h),
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 30,
                                  left: 30,
                                  top: 15,
                                ).r,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        var whatsapp = "+201009429689";
                                        final Uri url = Uri.parse(
                                            "whatsapp://send?phone=$whatsapp&text=ازيك ي محمد");
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
                                      child: Icon(
                                        FontAwesomeIcons.whatsapp,
                                        color: Colors.green,
                                        size: 18.sp,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        final Uri url = Uri.parse(
                                            "https://www.facebook.com/Original262003");
                                        Future<void> _launchUrl() async {
                                          if (!await launchUrl(
                                            url,
                                            mode: LaunchMode
                                                .externalNonBrowserApplication,
                                          )) {
                                            throw 'Could not launch $url';
                                          }
                                        }

                                        _launchUrl();
                                      },
                                      child: Icon(
                                        FontAwesomeIcons.facebook,
                                        color: Colors.blue,
                                        size: 18.sp,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        final Uri url = Uri.parse(
                                            "https://www.instagram.com/mohamed_elbaiomy262003/?igshid=ZDdkNTZiNTM%3D");
                                        Future<void> _launchUrl() async {
                                          if (!await launchUrl(
                                            url,
                                            mode: LaunchMode
                                                .externalNonBrowserApplication,
                                          )) {
                                            throw 'Could not launch $url';
                                          }
                                        }

                                        _launchUrl();
                                      },
                                      child: Icon(
                                        FontAwesomeIcons.instagram,
                                        color: Colors.deepOrange,
                                        size: 18.sp,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        final Uri url = Uri.parse(
                                            "https://www.linkedin.com/in/mohamed-elbaiomy-7b12b6191");
                                        Future<void> _launchUrl() async {
                                          if (!await launchUrl(
                                            url,
                                            mode: LaunchMode
                                                .externalNonBrowserApplication,
                                          )) {
                                            throw 'Could not launch $url';
                                          }
                                        }

                                        _launchUrl();
                                      },
                                      child: Icon(
                                        FontAwesomeIcons.linkedinIn,
                                        color: Colors.blue[300]!,
                                        size: 18.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 28.h),
                              Text(
                                "Craftify",
                                style: TextStyle(
                                  fontFamily: 'CinzelDecorative',
                                  color: textColor,
                                  letterSpacing: 3.sp,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              );
            }*/
            if (snapshot.connectionState == ConnectionState.active) {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              return CustomScrollView(
                /*physics: const BouncingScrollPhysics(
                decelerationRate: ScrollDecelerationRate.normal,
              ),*/
                shrinkWrap: true,
                slivers: [
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    centerTitle: true,
                    elevation: 4,
                    pinned: true,
                    backgroundColor: scaffoldColor,
                    expandedHeight: 120.h,
                    flexibleSpace: LayoutBuilder(
                      builder: (context, constraints) {
                        return FlexibleSpaceBar(
                          title: AnimatedOpacity(
                            duration: const Duration(milliseconds: 50),
                            opacity: constraints.biggest.height <= 120 ? 1 : 0,
                            child: Text(
                              'Profile',
                              style: TextStyle(
                                fontFamily: 'Dosis',
                                letterSpacing: 1.sp,
                                color: textColor,
                              ),
                            ),
                          ),
                          centerTitle: true,
                          background: Container(
                            decoration: BoxDecoration(
                              image: const DecorationImage(
                                fit: BoxFit.cover,
                                filterQuality: FilterQuality.high,
                                image: AssetImage(
                                  'assets/images/coverprofile.jpg',
                                ),
                              ),
                              borderRadius: BorderRadius.circular(20).r,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 20,
                                left: 5,
                              ).r,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                children: [
                                  Stack(
                                    alignment: AlignmentDirectional.center,
                                    clipBehavior: Clip.none,
                                    children: [
                                      Positioned(
                                        right: 90.r,
                                        child: AvatarG(
                                          endRadius: 120,
                                          glowColor: Colors.amber[400]!,
                                          child: data['profileimage'] == ''
                                              ? CircleAvatar(
                                                  maxRadius: 50.r,
                                                  //radius: 50.r,
                                                  backgroundImage:
                                                      const AssetImage(
                                                    'assets/images/inapp/guest.jpg',
                                                  ),
                                                )
                                              : CircleAvatar(
                                                  maxRadius: 50.r,
                                                  //radius: 50.r,
                                                  backgroundImage:
                                                      CachedNetworkImageProvider(
                                                    data['profileimage'],
                                                  ),
                                                ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 110,
                                        ).r,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            AutoDirection(
                                              text: data['name'] == ''
                                                  ? 'guest'.toUpperCase()
                                                  : data['name'],
                                              child: Text(
                                                data['name'] == ''
                                                    ? 'guest'.toUpperCase()
                                                    : data['name'],
                                                style: TextStyle(
                                                  fontFamily: 'Dosis',
                                                  letterSpacing: 1.sp,
                                                  color: textColor,
                                                  fontSize: 17.sp,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 15.h),
                                            Text(
                                              "reward points : ${data['points']}",
                                              style: TextStyle(
                                                fontFamily: 'Dosis',
                                                color: textColor,
                                                letterSpacing: 2.sp,
                                                fontSize: 12.sp,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        //SizedBox(height: 5.h),
                        const ProfileHeaderLabel(
                            headerLabel: '  Account Info  '),
                        ListTile(
                          leading: const Icon(
                            BoxIcons.bxl_gmail,
                            color: Colors.white60,
                          ),
                          subtitle: data['email'] == ''
                              ? Text(
                                  'example@email.com',
                                  style: TextStyle(
                                    fontFamily: 'Dosis',
                                    color: Colors.white60,
                                    fontSize: 12.sp,
                                    letterSpacing: 1.sp,
                                  ),
                                )
                              : Text(
                                  data['email'],
                                  style: TextStyle(
                                    fontFamily: 'Dosis',
                                    color: Colors.white60,
                                    fontSize: 11.sp,
                                    letterSpacing: 1.5.sp,
                                  ),
                                ),
                          title: Text(
                            'Email Address',
                            style: TextStyle(
                              fontFamily: 'Dosis',
                              color: textColor,
                              letterSpacing: 1.sp,
                            ),
                          ),
                        ),
/*
                      ListTile(
                        leading: const Icon(
                          Icons.phone,
                          color: Colors.white60,
                        ),
                        subtitle: data['phone'] == ''
                            ? const Text(
                                'example: +20 1009429689',
                                style: TextStyle(
                                  fontFamily: 'Dosis',
                                  color: Colors.white60,
                                  fontSize: 13,
                                  letterSpacing: 1.5,
                                ),
                              )
                            : Text(
                                data['phone'],
                                style: const TextStyle(
                                  fontFamily: 'Dosis',
                                  color: Colors.white60,
                                  fontSize: 13,
                                  letterSpacing: 1.5,
                                ),
                              ),
                        title: Text(
                          'Phone No',
                          style: TextStyle(
                            fontFamily: 'Dosis',
                            color: textColor,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
*/
                        const GreyDivider(),
                        RepeatedListTile(
                          onPressed: () {
                            Get.to(
                              const CustomerOrders(),
                              transition: Transition.rightToLeftWithFade,
                            );
                          },
                          icon: BoxIcons.bx_book_bookmark,
                          subTitle: "see your pending orders",
                          title: 'Orders',
                        ),
                        const GreyDivider(),
                        RepeatedListTile(
                          onPressed: () {
                            Get.to(
                              const CustomerAsks(),
                              transition: Transition.rightToLeftWithFade,
                            );
                          },
                          icon: BoxIcons.bx_question_mark,
                          subTitle: "see your pending asks",
                          title: 'Ask',
                        ),
                        const GreyDivider(),
                        RepeatedListTile(
                          onPressed: () {
                            Get.to(
                              CartScreen(
                                back: AppBarBackButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                ),
                              ),
                              transition: Transition.leftToRightWithFade,
                            );
                          },
                          subTitle: "check out now",
                          icon: BoxIcons.bx_shopping_bag,
                          title: 'Cart',
                        ),
                        const GreyDivider(),
                        RepeatedListTile(
                          onPressed: () {
                            Get.to(
                              const WishlistScreen(),
                              transition: Transition.rightToLeftWithFade,
                            );
                          },
                          icon: FontAwesomeIcons.heart,
                          subTitle: "browse your favourite products",
                          title: 'WishList',
                        ),
                        const GreyDivider(),
                        RepeatedListTile(
                          onPressed: FirebaseAuth
                                  .instance.currentUser!.isAnonymous
                              ? null
                              : () {
                                  Get.to(
                                    const AddressBook(),
                                    transition: Transition.leftToRightWithFade,
                                  );
                                },
                          icon: LineAwesome.location_arrow_solid,
                          subTitle: userAddress(data),
                          /* data['address'] == ''
                                  ? 'example : Qaliubia - Egypt'
                                  : data['address'],*/
                          title: 'Address',
                        ),
                        SizedBox(height: 20.h),
                        const ProfileHeaderLabel(
                            headerLabel: '  Account Settings  '),
                        SizedBox(height: 10.h),
                        SizedBox(
                          height: 400.h,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              RepeatedListTile(
                                title: 'Edit Profile',
                                subTitle: 'edit your information',
                                icon: LineAwesome.edit,
                                onPressed: () {
                                  Get.to(
                                    EditProfile(
                                      data: data,
                                    ),
                                    transition: Transition.rightToLeftWithFade,
                                  );
                                },
                              ),
                              const GreyDivider(),
                              RepeatedListTile(
                                title: 'Change Password',
                                subTitle: 'edit your entry password',
                                icon: BoxIcons.bx_lock,
                                onPressed: () {
                                  Get.to(
                                    const UpdatePassword(),
                                    transition: Transition.leftToRightWithFade,
                                  );
                                },
                              ),
                              const GreyDivider(),
                              RepeatedListTile(
                                title: 'About',
                                subTitle: 'waiting for your message anytime',
                                icon: PixelArtIcons.paperclip,
                                onPressed: () {
                                  Get.to(
                                    const ContactMe(),
                                    transition: Transition.rightToLeftWithFade,
                                  );
                                },
                              ),
                              const GreyDivider(),
                              RepeatedListTile(
                                title: 'Log Out',
                                icon: BoxIcons.bx_log_out,
                                onPressed: () async {
                                  MyAlertDilaog.showMyDialog(
                                    context: context,
                                    title: 'Log Out',
                                    content: 'Are you sure to log out ?',
                                    tabNo: () {
                                      Get.back();
                                    },
                                    tabYes: () async {
                                      await AuthRepo.logOut();
                                      clearUserId();
                                      /*final SharedPreferences pref =
                                                  await _prefs;
                                              pref.setString(
                                                  'customerid', '');*/
                                      await Future.delayed(
                                        const Duration(
                                          microseconds: 100,
                                        ),
                                      ).whenComplete(
                                        () {
                                          Get.offAll(
                                            const CustomerLogin(),
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                              SizedBox(height: 15.h),
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 30,
                                  left: 30,
                                  top: 15,
                                ).r,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        var whatsapp = "+201009429689";
                                        final Uri url = Uri.parse(
                                          "whatsapp://send?phone=$whatsapp&text=ازيك ي محمد",
                                        );
                                        Future<void> _launchUrl() async {
                                          if (!await launchUrl(
                                            url,
                                            mode:
                                                LaunchMode.externalApplication,
                                          )) {
                                            throw 'Could not launch $url';
                                          }
                                        }

                                        _launchUrl();
                                      },
                                      child: Icon(
                                        FontAwesomeIcons.whatsapp,
                                        color: Colors.green,
                                        size: 18.sp,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        final Uri url = Uri.parse(
                                          "https://www.facebook.com/Original262003",
                                        );
                                        Future<void> _launchUrl() async {
                                          if (!await launchUrl(
                                            url,
                                            mode: LaunchMode
                                                .externalNonBrowserApplication,
                                          )) {
                                            throw 'Could not launch $url';
                                          }
                                        }

                                        _launchUrl();
                                      },
                                      child: Icon(
                                        FontAwesomeIcons.facebook,
                                        color: Colors.blue,
                                        size: 18.sp,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        final Uri url = Uri.parse(
                                          "https://www.instagram.com/mohamed_elbaiomy262003/?igshid=ZDdkNTZiNTM%3D",
                                        );
                                        Future<void> _launchUrl() async {
                                          if (!await launchUrl(
                                            url,
                                            mode: LaunchMode
                                                .externalNonBrowserApplication,
                                          )) {
                                            throw 'Could not launch $url';
                                          }
                                        }

                                        _launchUrl();
                                      },
                                      child: Icon(
                                        FontAwesomeIcons.instagram,
                                        color: Colors.deepOrange,
                                        size: 18.sp,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        final Uri url = Uri.parse(
                                          "https://www.linkedin.com/in/mohamed-elbaiomy-7b12b6191",
                                        );
                                        Future<void> _launchUrl() async {
                                          if (!await launchUrl(
                                            url,
                                            mode: LaunchMode
                                                .externalNonBrowserApplication,
                                          )) {
                                            throw 'Could not launch $url';
                                          }
                                        }

                                        _launchUrl();
                                      },
                                      child: Icon(
                                        FontAwesomeIcons.linkedinIn,
                                        color: Colors.blue[300]!,
                                        size: 18.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 28.h),
                              Text(
                                "Craftify",
                                style: TextStyle(
                                  fontFamily: 'CinzelDecorative',
                                  color: textColor,
                                  letterSpacing: 3.sp,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              );
            }
            return CustomScrollView(
              /*physics: const BouncingScrollPhysics(
                decelerationRate: ScrollDecelerationRate.normal,
              ),*/
              shrinkWrap: true,
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  centerTitle: true,
                  elevation: 4,
                  pinned: true,
                  backgroundColor: scaffoldColor,
                  expandedHeight: 120.h,
                  flexibleSpace: LayoutBuilder(
                    builder: (context, constraints) {
                      return FlexibleSpaceBar(
                        title: AnimatedOpacity(
                          duration: const Duration(milliseconds: 50),
                          opacity: constraints.biggest.height <= 120 ? 1 : 0,
                          child: Text(
                            'Profile',
                            style: TextStyle(
                              fontFamily: 'Dosis',
                              letterSpacing: 1.sp,
                              color: textColor,
                            ),
                          ),
                        ),
                        centerTitle: true,
                        background: Container(
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                              fit: BoxFit.cover,
                              filterQuality: FilterQuality.high,
                              image: AssetImage(
                                'assets/images/coverprofile.jpg',
                              ),
                            ),
                            borderRadius: BorderRadius.circular(20).r,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20).r,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              children: [
                                SizedBox(width: 10.w),
                                CircleAvatar(
                                  maxRadius: 50.r,
                                  backgroundImage: const AssetImage(
                                    'assets/images/inapp/guest.jpg',
                                  ),
                                ),
                                SizedBox(width: 5.w),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 10.h),
                                    AutoDirection(
                                      text: 'guest'.toUpperCase(),
                                      child: Text(
                                        'guest'.toUpperCase(),
                                        style: TextStyle(
                                          fontFamily: 'Dosis',
                                          letterSpacing: 1.sp,
                                          color: textColor,
                                          fontSize: 17.sp,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 15.h),
                                    Text(
                                      "reward points : 0",
                                      style: TextStyle(
                                        fontFamily: 'Dosis',
                                        color: textColor,
                                        letterSpacing: 2.sp,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      //SizedBox(height: 10.h),
                      const ProfileHeaderLabel(headerLabel: '  Account Info  '),
                      ListTile(
                        leading: const Icon(
                          BoxIcons.bxl_gmail,
                          color: Colors.white60,
                        ),
                        subtitle: Text(
                          'example@email.com',
                          style: TextStyle(
                            fontFamily: 'Dosis',
                            color: Colors.white60,
                            fontSize: 12.sp,
                            letterSpacing: 1.sp,
                          ),
                        ),
                        title: Text(
                          'Email Address',
                          style: TextStyle(
                            fontFamily: 'Dosis',
                            color: textColor,
                            letterSpacing: 1.sp,
                          ),
                        ),
                      ),
                      const GreyDivider(),
                      RepeatedListTile(
                        onPressed: () {},
                        icon: BoxIcons.bx_book_bookmark,
                        subTitle: "see your pending orders",
                        title: 'Orders',
                      ),
                      const GreyDivider(),
                      RepeatedListTile(
                        onPressed: () {},
                        icon: BoxIcons.bx_question_mark,
                        subTitle: "see your pending asks",
                        title: 'Ask',
                      ),
                      const GreyDivider(),
                      RepeatedListTile(
                        onPressed: () {},
                        subTitle: "check out now",
                        icon: BoxIcons.bx_shopping_bag,
                        title: 'Cart',
                      ),
                      const GreyDivider(),
                      RepeatedListTile(
                        onPressed: () {},
                        icon: FontAwesomeIcons.heart,
                        subTitle: "browse your favourite products",
                        title: 'WishList',
                      ),
                      const GreyDivider(),
                      RepeatedListTile(
                        onPressed: () {},
                        icon: LineAwesome.location_arrow_solid,
                        subTitle: 'Set Your Address',
                        title: 'Address',
                      ),
                      SizedBox(height: 20.h),
                      const ProfileHeaderLabel(
                          headerLabel: '  Account Settings  '),
                      SizedBox(height: 10.h),
                      SizedBox(
                        height: 400.h,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            RepeatedListTile(
                              title: 'Edit Profile',
                              subTitle: 'edit your information',
                              icon: LineAwesome.edit,
                              onPressed: () {},
                            ),
                            const GreyDivider(),
                            RepeatedListTile(
                              title: 'Change Password',
                              subTitle: 'edit your entry password',
                              icon: BoxIcons.bx_lock,
                              onPressed: () {},
                            ),
                            const GreyDivider(),
                            RepeatedListTile(
                              title: 'About',
                              subTitle: 'waiting for your message anytime',
                              icon: PixelArtIcons.paperclip,
                              onPressed: () {
                                Get.to(
                                  const ContactMe(),
                                  transition: Transition.rightToLeftWithFade,
                                );
                              },
                            ),
                            const GreyDivider(),
                            RepeatedListTile(
                              title: 'Log Out',
                              icon: BoxIcons.bx_log_out,
                              onPressed: () async {},
                            ),
                            SizedBox(height: 15.h),
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 30,
                                left: 30,
                                top: 15,
                              ).r,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      var whatsapp = "+201009429689";
                                      final Uri url = Uri.parse(
                                        "whatsapp://send?phone=$whatsapp&text=ازيك ي محمد",
                                      );
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
                                    child: Icon(
                                      FontAwesomeIcons.whatsapp,
                                      color: Colors.green,
                                      size: 18.sp,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      final Uri url = Uri.parse(
                                        "https://www.facebook.com/Original262003",
                                      );
                                      Future<void> _launchUrl() async {
                                        if (!await launchUrl(
                                          url,
                                          mode: LaunchMode
                                              .externalNonBrowserApplication,
                                        )) {
                                          throw 'Could not launch $url';
                                        }
                                      }

                                      _launchUrl();
                                    },
                                    child: Icon(
                                      FontAwesomeIcons.facebook,
                                      color: Colors.blue,
                                      size: 18.sp,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      final Uri url = Uri.parse(
                                        "https://www.instagram.com/mohamed_elbaiomy262003/?igshid=ZDdkNTZiNTM%3D",
                                      );
                                      Future<void> _launchUrl() async {
                                        if (!await launchUrl(
                                          url,
                                          mode: LaunchMode
                                              .externalNonBrowserApplication,
                                        )) {
                                          throw 'Could not launch $url';
                                        }
                                      }

                                      _launchUrl();
                                    },
                                    child: Icon(
                                      FontAwesomeIcons.instagram,
                                      color: Colors.deepOrange,
                                      size: 18.sp,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      final Uri url = Uri.parse(
                                        "https://www.linkedin.com/in/mohamed-elbaiomy-7b12b6191",
                                      );
                                      Future<void> _launchUrl() async {
                                        if (!await launchUrl(
                                          url,
                                          mode: LaunchMode
                                              .externalNonBrowserApplication,
                                        )) {
                                          throw 'Could not launch $url';
                                        }
                                      }

                                      _launchUrl();
                                    },
                                    child: Icon(
                                      FontAwesomeIcons.linkedinIn,
                                      color: Colors.blue[300]!,
                                      size: 18.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 28.h),
                            Text(
                              "Craftify",
                              style: TextStyle(
                                fontFamily: 'CinzelDecorative',
                                color: textColor,
                                letterSpacing: 3.sp,
                                fontSize: 16.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
      floatingActionButton: InkWell(
        child: const Icon(
          LineAwesome.google_play,
          size: 35,
          color: Colors.white70,
        ), //Logo(Logos.google_play, size: 30.sp),
        onTap: () {
          final Uri url = Uri.parse(
            "https://play.google.com/store/apps/details?id=customers_app_google_play.com.customers_app_google_play",
          );
          Future<void> _launchUrl() async {
            if (!await launchUrl(
              url,
              mode: LaunchMode.externalNonBrowserApplication,
            )) {
              throw 'Could not launch $url';
            }
          }

          _launchUrl();
        },
      ),
    );
  }

  /* Widget noUserScaffold() {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Stack(
        children: [
          Container(
            height: 230,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black87, Colors.grey],
              ),
            ),
          ),
          CustomScrollView(
            slivers: [
              SliverAppBar(
                centerTitle: true,
                pinned: true,
                elevation: 0,
                backgroundColor: Colors.white,
                expandedHeight: 140,
                flexibleSpace: LayoutBuilder(
                  builder: (context, constraints) {
                    return FlexibleSpaceBar(
                      title: AnimatedOpacity(
                        duration: const Duration(milliseconds: 400),
                        opacity: constraints.biggest.height <= 120 ? 1 : 0,
                        child: const Text(
                          "Account",
                          style: TextStyle(
                            fontFamily: 'Dosis',
                            color: Colors.black,
                          ),
                        ),
                      ),
                      background: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.black87, Colors.grey],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 25, left: 30),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                radius: 50,
                                backgroundImage:
                                    AssetImage("images/inapp/guest.jpg"),
                              ),
                              Row(
                                children: [
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 25),
                                    child: Text(
                                      "Guest",
                                      style: TextStyle(
                                        fontFamily: 'Dosis',
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  CommonButton(
                                    borderRadius: 9,
                                    title: 'Login',
                                    onPressed: () {
                                      Navigator.pushReplacementNamed(
                                          context, '/customer_login');
                                    },
                                    width: 0.25,
                                    height: 35,
                                    borderColor: textColor,
                                    textColor: scaffoldColor,
                                    fillColor: textColor,
                                    letterSpacing: 1,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Container(
                      height: 80,
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                bottomLeft: Radius.circular(30),
                              ),
                            ),
                            child: TextButton(
                              onPressed: () {
                                logInDialog();
                              },
                              child: SizedBox(
                                height: 40,
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: const Center(
                                  child: Text(
                                    "Cart",
                                    style: TextStyle(
                                      fontFamily: 'Dosis',
                                      letterSpacing: 1,
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            color: Colors.black,
                            child: TextButton(
                              onPressed: () {
                                logInDialog();
                              },
                              child: const Center(
                                child: Text(
                                  "Orders",
                                  style: TextStyle(
                                    fontFamily: 'Dosis',
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(30),
                                bottomRight: Radius.circular(30),
                              ),
                            ),
                            child: TextButton(
                              onPressed: () {
                                logInDialog();
                              },
                              child: SizedBox(
                                height: 40,
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: const Center(
                                  child: Text(
                                    "Wishlist",
                                    style: TextStyle(
                                      fontFamily: 'Dosis',
                                      letterSpacing: 1,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            color: scaffoldColor,
                            child: Column(
                              children: [
                                const SizedBox(height: 40),
                                const ProfileHeaderLabel(
                                  headerLabel: 'Account Info',
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    height: 260,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Column(
                                      children: [
                                        const RepeatedListTile(
                                            icon: Icons.email,
                                            subTitle: 'example@gmail.com',
                                            title: 'Email Address'),
                                        const GreyDivider(),
                                        const RepeatedListTile(
                                            icon: Icons.phone,
                                            subTitle:
                                                "example : +20-1234567891 ",
                                            title: 'Phone No.'),
                                        const GreyDivider(),
                                        RepeatedListTile(
                                            onPressed: FirebaseAuth.instance
                                                    .currentUser!.isAnonymous
                                                ? null
                                                : () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            const AddressBook(),
                                                      ),
                                                    );
                                                  },
                                            icon: Icons.location_pin,
                                            subTitle:
                                                "example : Toukh - Qaliubia",
                                            title: 'Address'),
                                      ],
                                    ),
                                  ),
                                ),
                                const ProfileHeaderLabel(
                                    headerLabel: '  Account Settings  '),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    height: 260,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    child: Column(
                                      children: [
                                        RepeatedListTile(
                                          title: 'Edit Profile',
                                          subTitle: 'edit your information',
                                          icon: Icons.edit,
                                          onPressed: () {},
                                        ),
                                        const GreyDivider(),
                                        RepeatedListTile(
                                          title: 'Change Password',
                                          subTitle: 'edit your entry password',
                                          icon: Icons.lock,
                                          onPressed: () {},
                                        ),
                                        const GreyDivider(),
                                        RepeatedListTile(
                                          title: 'Log Out',
                                          icon: Icons.logout,
                                          onPressed: () async {
                                            MyAlertDilaog.showMyDialog(
                                              context: context,
                                              title: 'Log Out',
                                              content:
                                                  'Are you sure to log out ?',
                                              tabNo: () {
                                                Navigator.pop(context);
                                              },
                                              tabYes: () async {
                                                await AuthRepo.logOut();
                                                await Future.delayed(
                                                  const Duration(
                                                    microseconds: 10,
                                                  ),
                                                ).whenComplete(
                                                  () {
                                                    Get.offNamed(
                                                        '/customer_login');
                                                  },
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }*/
}

class GreyDivider extends StatelessWidget {
  const GreyDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Colors.white24,
      thickness: 1.sp,
    );
  }
}

class RepeatedListTile extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData icon;
  final Function()? onPressed;

  const RepeatedListTile(
      {super.key,
      required this.icon,
      this.onPressed,
      this.subTitle = '',
      required this.title});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'Dosis',
            color: textColor,
            letterSpacing: 1.sp,
          ),
        ),
        subtitle: Text(
          subTitle,
          style: TextStyle(
            fontFamily: 'Dosis',
            color: Colors.white60,
            fontSize: 12.sp,
            letterSpacing: 1.4.sp,
          ),
        ),
        leading: Icon(icon, color: Colors.white60),
        trailing: Icon(
          Icons.arrow_right,
          size: 18.sp,
          color: textColor,
        ),
      ),
    );
  }
}

class ProfileHeaderLabel extends StatelessWidget {
  final String headerLabel;

  const ProfileHeaderLabel({super.key, required this.headerLabel});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 35.h,
            width: 85.w,
            child: Divider(
              color: Colors.grey,
              thickness: 1.sp,
            ),
          ),
          Text(
            headerLabel,
            style: TextStyle(
              fontFamily: 'Dosis',
              color: textColor,
              fontSize: 23.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: 35.h,
            width: 85.w,
            child: Divider(
              color: Colors.grey,
              thickness: 1.sp,
            ),
          ),
        ],
      ),
    );
  }
}
