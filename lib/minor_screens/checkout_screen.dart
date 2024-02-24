//import 'dart:convert';
//import 'package:customers_app_google_play/providers/stripe_id.dart';
//import 'package:flutter_stripe/flutter_stripe.dart';
//import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:achievement_view/achievement_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:customers_app_google_play/widgets/date_picker.dart' as date;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:customers_app_google_play/minor_screens/thanks_screen.dart';
import 'package:customers_app_google_play/providers/constants2.dart';
import 'package:customers_app_google_play/providers/id_provider.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import '../providers/cart_provider.dart';
import '../providers/stripe_id.dart';
import '../widgets/Delayed_Widget_Code.dart';
import '../widgets/appbar_widgets.dart';
import '../widgets/buttons.dart';
import '../widgets/snackbar.dart';

class CheckOutScreen extends StatefulWidget {
  final String name;
  final String phone;
  final String address;

  const CheckOutScreen(
      {Key? key,
      required this.name,
      required this.phone,
      required this.address})
      : super(key: key);

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  int selectedValue = 1;
  late String docId;
  late String orderId;
  bool freeShipping = false;
  bool pickedDate = false;
  CollectionReference customers =
      FirebaseFirestore.instance.collection('customers');
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  DateTime customerDate = DateTime.now();

  void showProgress() {
    ProgressDialog progress = ProgressDialog(context: context);
    progress.show(
      max: 100,
      backgroundColor: Colors.white,
      msg: 'please wait',
      progressType: ProgressType.valuable,
      progressBgColor: Colors.black,
      borderRadius: 30.r,
    );
  }

  @override
  void initState() {
    super.initState();
    docId = context.read<IdProvider>().getData;
  }

  @override
  Widget build(BuildContext context) {
    String docId = context.read<IdProvider>().getData;
    double totalPrice = context.watch<Cart>().totalPrice;
    double totalPaid = context.watch<Cart>().totalPrice;
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        backgroundColor: scaffoldColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: scaffoldColor,
          leading: AppBarBackButton(
            onPressed: () {
              Get.back();
            },
          ),
          title: const AppBarTitle(
            title: 'Checkout',
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10).r,
          child: StreamBuilder<DocumentSnapshot>(
            stream: customers
                .doc(
                  docId.isNotEmpty
                      ? docId
                      : FirebaseAuth.instance.currentUser!.uid,
                )
                .get()
                .asStream(),
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
                          fontSize: 25.sp,
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
                          fontSize: 20.sp,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Container(
                        height: 34,
                        width: MediaQuery.of(context).size.width * 0.35,
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
                            style: TextStyle(
                                fontFamily: 'Dosis', color: textColor),
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
                    ],
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
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
                );
              }

              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;
                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: AnimationConfiguration.toStaggeredList(
                      duration: const Duration(milliseconds: 300),
                      childAnimationBuilder: (widget) => SlideAnimation(
                        horizontalOffset: 10,
                        child: FadeInAnimation(
                          child: widget,
                        ),
                      ),
                      children: [
                        Align(
                          alignment: AlignmentDirectional.topStart,
                          child: Text(
                            "Shipping",
                            style: TextStyle(
                              color: textColor,
                              fontSize: 20.sp,
                              letterSpacing: 1.sp,
                              fontFamily: 'Dosis',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Padding(
                          padding: const EdgeInsets.only(left: 20).r,
                          child: Align(
                            alignment: AlignmentDirectional.topStart,
                            child: Text(
                              "The Supplier will contact with you to determine shipping coast which is probably between "
                              "10 : 50 EGP and he will tell you of the final total price for your package.",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13.sp,
                                letterSpacing: 1.5.sp,
                                fontFamily: 'Dosis',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        /* SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Align(
                              alignment: AlignmentDirectional.topStart,
                              child: Text(
                                "=> shipping to BFCAI is free",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 15,
                                  letterSpacing: 1.5,
                                  fontFamily: 'Dosis',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Align(
                              alignment: AlignmentDirectional.topStart,
                              child: Text(
                                "=> shipping to Toukh city free also",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 15,
                                  letterSpacing: 1.5,
                                  fontFamily: 'Dosis',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Align(
                              alignment: AlignmentDirectional.topStart,
                              child: Text(
                                "Terms and conditions apply",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  letterSpacing: 1.5,
                                  fontFamily: 'Dosis',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),*/
                        SizedBox(height: 10.h),
                        Padding(
                          padding: const EdgeInsets.only(left: 20).r,
                          child: Align(
                            alignment: AlignmentDirectional.topStart,
                            child: Text(
                              "Choose your delivery date :",
                              style: TextStyle(
                                color: textColor,
                                letterSpacing: 1.5.sp,
                                fontSize: 14.sp,
                                fontFamily: 'Dosis',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        /*      SizedBox(
                                width: MediaQuery.of(context).size.width * 0.04,
                              ),
                              StatefulBuilder(
                                builder:
                                    (BuildContext context, StateSetter setState) {
                                  return TextButton(
                                    style: const ButtonStyle(),
                                    onPressed: () {
                                      DatePicker.showDatePicker(context,
                                          showTitleActions: true,
                                          minTime: DateTime.now(),
                                          maxTime: DateTime.now().add(
                                            const Duration(days: 365),
                                          ), onConfirm: (date) {
                                        setState(() {
                                          customerDate = date;
                                          pickedDate = true;
                                        });
                                        showAddress(context);
                                      });
                                    },
                                    child: Text(
                                      pickedDate == true
                                          ? 'Picked'
                                          : 'pick up date',
                                      style: TextStyle(
                                        color: pickedDate == true
                                            ? textColor
                                            : Colors.amber,
                                        letterSpacing:
                                            pickedDate == true ? 3.5 : 1.2,
                                        fontSize: 14,
                                        fontFamily: 'Dosis',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                },
                              ),*/
                        StatefulBuilder(builder:
                            (BuildContext context, StateSetter setState) {
                          return Container(
                            margin: const EdgeInsets.only(
                              top: 5,
                            ).r,
                            child: date.DatePicker(
                              DateTime.now(),
                              height: 85.h,
                              width: 65.w,
                              selectionColor: Colors.white,
                              selectedTextColor: Colors.black,
                              dateTextStyle: TextStyle(
                                fontFamily: 'CinzelDecorative',
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                              ),
                              dayTextStyle: TextStyle(
                                fontFamily: 'Dosis',
                                letterSpacing: 2.sp,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                              ),
                              monthTextStyle: TextStyle(
                                fontFamily: 'Dosis',
                                letterSpacing: 2.sp,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                              ),
                              onDateChange: (date) {
                                setState(() {
                                  customerDate = date;
                                  pickedDate = true;
                                });
                                showAddress(context, date);
                              },
                            ),
                          );
                        }),
                        SizedBox(height: 10.h),
                        Align(
                          alignment: AlignmentDirectional.topStart,
                          child: Text(
                            "Payment Method",
                            style: TextStyle(
                              color: textColor,
                              letterSpacing: 1.sp,
                              fontSize: 20.sp,
                              fontFamily: 'Dosis',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter setState) {
                            return Column(
                              children: [
                                GFRadioListTile(
                                  value: 1,
                                  size: 18.sp,
                                  type: GFRadioType.basic,
                                  position: GFPosition.start,
                                  inactiveBgColor: Colors.white60,
                                  color: scaffoldColor,
                                  activeBgColor: Colors.white70,
                                  radioColor: scaffoldColor,
                                  groupValue: selectedValue,
                                  onChanged: (value) {
                                    setState(
                                      () {
                                        selectedValue = value!;
                                      },
                                    );
                                  },
                                  title: Text(
                                    'Cash On Delivery',
                                    style: TextStyle(
                                      color: textColor,
                                      letterSpacing: 1.sp,
                                      fontSize: 14.sp,
                                      fontFamily: 'Dosis',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  subTitle: Text(
                                    'Pay Cash At Home',
                                    style: TextStyle(
                                      color: Colors.white54,
                                      letterSpacing: 1.sp,
                                      fontSize: 12.sp,
                                      fontFamily: 'Dosis',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 170.w,
                                      height: 67.h,
                                      child: GFRadioListTile(
                                        type: GFRadioType.basic,
                                        value: 2,
                                        size: 18.sp,
                                        position: GFPosition.start,
                                        inactiveBgColor: Colors.white60,
                                        color: scaffoldColor,
                                        activeBgColor: Colors.white70,
                                        radioColor: scaffoldColor,
                                        groupValue: selectedValue,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedValue = value!;
                                          });
                                        },
                                        title: Text(
                                          'Stripe',
                                          style: TextStyle(
                                            color: textColor,
                                            letterSpacing: 1.sp,
                                            fontSize: 14.sp,
                                            fontFamily: 'Dosis',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        subTitle: Row(
                                          children: [
                                            const Icon(
                                              FontAwesomeIcons.ccMastercard,
                                              color: Colors.white54,
                                            ),
                                            SizedBox(width: 10.w),
                                            const Icon(
                                              FontAwesomeIcons.ccVisa,
                                              color: Colors.white54,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 170.w,
                                      height: 67.h,
                                      child: GFRadioListTile(
                                        type: GFRadioType.basic,
                                        value: 3,
                                        size: 18.sp,
                                        position: GFPosition.start,
                                        inactiveBgColor: Colors.white60,
                                        color: scaffoldColor,
                                        activeBgColor: Colors.white70,
                                        radioColor: scaffoldColor,
                                        groupValue: selectedValue,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedValue = value!;
                                          });
                                        },
                                        title: Text(
                                          'Paymob',
                                          style: TextStyle(
                                            color: textColor,
                                            letterSpacing: 1.sp,
                                            fontSize: 13.sp,
                                            fontFamily: 'Dosis',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        subTitle: Row(
                                          children: [
                                            const Icon(
                                              FontAwesomeIcons.ccMastercard,
                                              color: Colors.white54,
                                            ),
                                            SizedBox(width: 10.w),
                                            const Icon(
                                              FontAwesomeIcons.ccVisa,
                                              color: Colors.white54,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                        SizedBox(height: 5.h),
                        Align(
                          alignment: AlignmentDirectional.topStart,
                          child: Text(
                            "free shipping using points ",
                            style: TextStyle(
                              color: textColor,
                              fontSize: 15.sp,
                              fontFamily: 'Dosis',
                              letterSpacing: 1.5.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(height: 7.h),
                        Padding(
                          padding: const EdgeInsets.only(left: 20).r,
                          child: Align(
                            alignment: AlignmentDirectional.topStart,
                            child: Text(
                              "You must have 10 points before you can get free shipping using rewarded points.",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13.sp,
                                letterSpacing: 1.3.sp,
                                fontFamily: 'Dosis',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        StatefulBuilder(
                          builder: (context, StateSetter setState) {
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 20).r,
                                      child: Text(
                                        "if you got 10 points or greater click here :",
                                        style: TextStyle(
                                          color: textColor,
                                          letterSpacing: 1.sp,
                                          fontSize: 12.sp,
                                          fontFamily: 'Dosis',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    TextButton(
                                      style: const ButtonStyle(),
                                      onPressed: () {
                                        DocumentReference docRef =
                                            FirebaseFirestore.instance
                                                .collection('customers')
                                                .doc(
                                                  FirebaseAuth.instance
                                                      .currentUser!.uid,
                                                );
                                        docRef.get().then(
                                          (snapshot) {
                                            if (snapshot.exists) {
                                              if (snapshot['points'] >= 10) {
                                                setState(() {
                                                  freeShipping = true;
                                                });
                                                showPoints(context);
                                              } else {
                                                MyMessageHandler.showSnackBar(
                                                  _scaffoldKey,
                                                  "no enough points",
                                                );
                                              }
                                            } else {
                                              MyMessageHandler.showSnackBar(
                                                _scaffoldKey,
                                                "We don't have any points recorded to your account",
                                              );
                                            }
                                          },
                                        );
                                      },
                                      child: AnimatedCrossFade(
                                        firstChild: Text(
                                          freeShipping == true
                                              ? "Applied"
                                              : "Apply",
                                          style: TextStyle(
                                            color: freeShipping == true
                                                ? textColor
                                                : Colors.amber,
                                            letterSpacing: 1.sp,
                                            fontSize: 13.sp,
                                            fontFamily: 'Dosis',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        firstCurve: Curves.bounceOut,
                                        secondCurve: Curves.easeOutSine,
                                        secondChild: Text(
                                          freeShipping == true
                                              ? "Applied"
                                              : "Apply",
                                          style: TextStyle(
                                            color: freeShipping == true
                                                ? textColor
                                                : Colors.amber,
                                            letterSpacing: 1.sp,
                                            fontSize: 13.sp,
                                            fontFamily: 'Dosis',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        sizeCurve: Curves.linear,
                                        crossFadeState: freeShipping == true
                                            ? CrossFadeState.showFirst
                                            : CrossFadeState.showSecond,
                                        duration: const Duration(seconds: 1),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total order',
                                      style: TextStyle(
                                        fontSize: 13.5.sp,
                                        letterSpacing: 1.sp,
                                        fontFamily: 'Dosis',
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      '${totalPrice.toStringAsFixed(2)} EGP',
                                      style: TextStyle(
                                        fontFamily: 'Dosis',
                                        fontSize: 14.sp,
                                        letterSpacing: 1.4.sp,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Shipping Coast',
                                      style: TextStyle(
                                        fontFamily: 'Dosis',
                                        fontSize: 14.sp,
                                        decoration: freeShipping == true
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                        letterSpacing: 1.sp,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      '10.0 : 50.0  EGP',
                                      style: TextStyle(
                                        fontFamily: 'Dosis',
                                        fontSize: 15.sp,
                                        decoration: freeShipping == true
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                        letterSpacing: 1.4.sp,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                        Divider(
                          color: Colors.grey,
                          thickness: 1.4.sp,
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total',
                              style: TextStyle(
                                fontFamily: 'Dosis',
                                fontSize: 16.sp,
                                letterSpacing: 1.sp,
                                color: textColor,
                              ),
                            ),
                            Text(
                              '${totalPaid.toStringAsFixed(2)} EGP',
                              style: TextStyle(
                                fontFamily: 'Dosis',
                                letterSpacing: 2.sp,
                                fontSize: 16.sp,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        CommonButton(
                          borderRadius: 10,
                          title:
                              'Confirm ${totalPaid.toStringAsFixed(2)} EGP + shipping',
                          onPressed: () async {
                            if (pickedDate == false) {
                              MyMessageHandler.showSnackBar(
                                _scaffoldKey,
                                'Choose delivery date first',
                              );
                            } else {
                              if (selectedValue == 1) {
                                showModalBottomSheet(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: const Radius.circular(15).r,
                                      topRight: const Radius.circular(15).r,
                                    ),
                                  ),
                                  backgroundColor: Colors.grey.shade300,
                                  elevation: 3,
                                  context: context,
                                  builder: (context) => SizedBox(
                                    height: 200.h,
                                    width: double.infinity.w,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 90).r,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            'Pay At Home ${totalPaid.toStringAsFixed(2)} \$',
                                            style: TextStyle(
                                              fontSize: 22.sp,
                                              letterSpacing: 1.sp,
                                              fontFamily: 'Dosis',
                                            ),
                                          ),
                                          SizedBox(
                                            height: 40.h,
                                            width: 280.w,
                                            child: Text(
                                              "remember the Supplier will call you to final Confirmation order after agreeing on the final price",
                                              style: TextStyle(
                                                color: Colors.redAccent,
                                                fontSize: 13.sp,
                                                letterSpacing: 0.5.sp,
                                                fontFamily: 'Dosis',
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          CommonButton(
                                            borderRadius: 10,
                                            title:
                                                'Confirm ${totalPaid.toStringAsFixed(2)} EGP',
                                            onPressed: () async {
                                              showProgress();
                                              for (var item in context
                                                  .read<Cart>()
                                                  .getItems) {
                                                CollectionReference orderRef =
                                                    FirebaseFirestore.instance
                                                        .collection('orders');
                                                orderId = const Uuid().v4();
                                                await orderRef
                                                    .doc(orderId)
                                                    .set({
                                                  'cid': data['cid'],
                                                  'custname': widget.name,
                                                  'email': data['email'],
                                                  'address': widget.address,
                                                  'phone': widget.phone,
                                                  'profileimage':
                                                      data['profileimage'],
                                                  'sid': item.suppId,
                                                  'proid': item.documentId,
                                                  'orderid': orderId,
                                                  'ordername': item.name,
                                                  'orderimage': item.imagesUrl,
                                                  'orderqty': item.qty,
                                                  'orderprice':
                                                      item.qty * item.price,
                                                  'deliverystatus': 'preparing',
                                                  'deliverydate': customerDate,
                                                  'freeShipping':
                                                      freeShipping == true
                                                          ? true
                                                          : false,
                                                  'orderdate': DateTime.now(),
                                                  'paymentstatus':
                                                      'cash on delivery',
                                                  'orderreview': false,
                                                }).whenComplete(
                                                  () async {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .runTransaction(
                                                      (transaction) async {
                                                        DocumentReference
                                                            documentReference =
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'products')
                                                                .doc(item
                                                                    .documentId);
                                                        DocumentSnapshot
                                                            snapshot2 =
                                                            await transaction.get(
                                                                documentReference);
                                                        transaction.update(
                                                          documentReference,
                                                          {
                                                            'instock': snapshot2[
                                                                    'instock'] -
                                                                item.qty
                                                          },
                                                        );
                                                      },
                                                    );
                                                    switch (freeShipping) {
                                                      case true:
                                                        DocumentReference docRef =
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'customers')
                                                                .doc(FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid);
                                                        docRef.get().then(
                                                            (snapshot) async {
                                                          if (snapshot[
                                                                  'points'] ==
                                                              10) {
                                                            await FirebaseFirestore
                                                                .instance
                                                                .runTransaction(
                                                                    (transaction) async {
                                                              DocumentReference
                                                                  documentReference =
                                                                  FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'customers')
                                                                      .doc(FirebaseAuth
                                                                          .instance
                                                                          .currentUser!
                                                                          .uid);
                                                              transaction
                                                                  .update(
                                                                documentReference,
                                                                {
                                                                  'points': 0,
                                                                },
                                                              );
                                                            });
                                                          } else if (snapshot[
                                                                  'points'] >
                                                              10) {
                                                            await FirebaseFirestore
                                                                .instance
                                                                .runTransaction(
                                                                    (transaction) async {
                                                              DocumentReference
                                                                  documentReference =
                                                                  FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'customers')
                                                                      .doc(FirebaseAuth
                                                                          .instance
                                                                          .currentUser!
                                                                          .uid);
                                                              DocumentSnapshot
                                                                  snapshot2 =
                                                                  await transaction
                                                                      .get(
                                                                          documentReference);
                                                              transaction
                                                                  .update(
                                                                documentReference,
                                                                {
                                                                  'points':
                                                                      snapshot2[
                                                                              'points'] -
                                                                          10,
                                                                },
                                                              );
                                                            });
                                                          } else if (snapshot[
                                                                  'points'] <
                                                              10) {
                                                          } else {}
                                                        });
                                                        break;
                                                      case false:
                                                        await FirebaseFirestore
                                                            .instance
                                                            .runTransaction(
                                                                (transaction) async {
                                                          DocumentReference
                                                              documentReference =
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'customers')
                                                                  .doc(FirebaseAuth
                                                                      .instance
                                                                      .currentUser!
                                                                      .uid);
                                                          DocumentSnapshot
                                                              snapshot2 =
                                                              await transaction.get(
                                                                  documentReference);
                                                          transaction.update(
                                                            documentReference,
                                                            {
                                                              'points': snapshot2[
                                                                      'points'] +
                                                                  item.qty
                                                            },
                                                          );
                                                        });
                                                        break;
                                                    }
                                                  },
                                                );
                                              }
                                              await Future.delayed(
                                                const Duration(
                                                  microseconds: 800,
                                                ),
                                              ).whenComplete(
                                                () {
                                                  context
                                                      .read<Cart>()
                                                      .clearCart();

                                                  Navigator.pushAndRemoveUntil(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            const ThanksScreen(),
                                                      ),
                                                      (route) => false);
                                                },
                                              );
                                            },
                                            width: 0.7,
                                            height: 35,
                                            borderColor: scaffoldColor,
                                            textColor: textColor,
                                            fillColor: scaffoldColor,
                                            letterSpacing: 3.5,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              } else if (selectedValue == 2) {
                                /* int payment = totalPaid.round();
                                int pay = payment * 100;
                                await makePayment(data, pay.toString());*/
                                MyMessageHandler.showSnackBar(
                                  _scaffoldKey,
                                  "Stripe gateway is Under Development",
                                );
                              } else if (selectedValue == 3) {
                                MyMessageHandler.showSnackBar(
                                  _scaffoldKey,
                                  "Paymob gateway is Under Development",
                                );
                              }
                            }
                          },
                          width: 0.82.w,
                          height: 30.h,
                          borderColor: textColor,
                          textColor: scaffoldColor,
                          fillColor: textColor,
                          letterSpacing: 1.sp,
                        ),
                      ],
                    ),
                  ),
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }

  Map<String, dynamic>? paymentIntentData;
  Future<void> makePayment(dynamic data, String total) async {
    try {
      paymentIntentData = await createPaymentIntent(total, 'EGP');
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentData!['client_secret'],
          merchantDisplayName: 'MOHAMED',
          style: ThemeMode.dark,
        ),
      );
      await displayPaymentSheet(data);
    } catch (e) {
      if (kDebugMode) {
        print('exception:$e');
      }
    }
  }

  displayPaymentSheet(dynamic data) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) async {
        paymentIntentData = null;
        showProgress();
        for (var item in context.read<Cart>().getItems) {
          CollectionReference orderRef =
              FirebaseFirestore.instance.collection('orders');
          orderId = const Uuid().v4();
          await orderRef.doc(orderId).set({
            'cid': data['cid'],
            'custname': widget.name,
            'email': data['email'],
            'address': widget.address,
            'phone': widget.phone,
            'profileimage': data['profileimage'],
            'sid': item.suppId,
            'proid': item.documentId,
            'orderid': orderId,
            'ordername': item.name,
            'orderimage': item.imagesUrl,
            'orderqty': item.qty,
            'orderprice': item.qty * item.price,
            'deliverystatus': 'preparing',
            'deliverydate': customerDate,
            'freeShipping': freeShipping == true ? true : false,
            'orderdate': DateTime.now(),
            'paymentstatus': 'Pay Online (Stripe)',
            'orderreview': false,
          }).whenComplete(
            () async {
              await FirebaseFirestore.instance.runTransaction(
                (transaction) async {
                  DocumentReference documentReference = FirebaseFirestore
                      .instance
                      .collection('products')
                      .doc(item.documentId);
                  DocumentSnapshot snapshot2 =
                      await transaction.get(documentReference);
                  transaction.update(
                    documentReference,
                    {'instock': snapshot2['instock'] - item.qty},
                  );
                },
              );
              switch (freeShipping) {
                case true:
                  DocumentReference docRef = FirebaseFirestore.instance
                      .collection('customers')
                      .doc(FirebaseAuth.instance.currentUser!.uid);
                  docRef.get().then((snapshot) async {
                    if (snapshot['points'] == 10) {
                      await FirebaseFirestore.instance
                          .runTransaction((transaction) async {
                        DocumentReference documentReference = FirebaseFirestore
                            .instance
                            .collection('customers')
                            .doc(FirebaseAuth.instance.currentUser!.uid);
                        transaction.update(
                          documentReference,
                          {
                            'points': 0,
                          },
                        );
                      });
                    } else if (snapshot['points'] > 10) {
                      await FirebaseFirestore.instance
                          .runTransaction((transaction) async {
                        DocumentReference documentReference = FirebaseFirestore
                            .instance
                            .collection('customers')
                            .doc(FirebaseAuth.instance.currentUser!.uid);
                        DocumentSnapshot snapshot2 =
                            await transaction.get(documentReference);
                        transaction.update(
                          documentReference,
                          {
                            'points': snapshot2['points'] - 10,
                          },
                        );
                      });
                    } else if (snapshot['points'] < 10) {
                    } else {}
                  });
                  break;
                case false:
                  await FirebaseFirestore.instance
                      .runTransaction((transaction) async {
                    DocumentReference documentReference = FirebaseFirestore
                        .instance
                        .collection('customers')
                        .doc(FirebaseAuth.instance.currentUser!.uid);
                    DocumentSnapshot snapshot2 =
                        await transaction.get(documentReference);
                    transaction.update(
                      documentReference,
                      {'points': snapshot2['points'] + item.qty},
                    );
                  });
                  break;
              }
            },
          );
        }
        await Future.delayed(
          const Duration(
            microseconds: 800,
          ),
        ).whenComplete(
          () {
            context.read<Cart>().clearCart();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const ThanksScreen(),
                ),
                (route) => false);
          },
        );
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  createPaymentIntent(String total, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': total,
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization': 'Bearer $stripeSecretKey',
            'Content-Type': 'application/x-www-form-urlencoded'
          });

      return jsonDecode(response.body);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  void showPoints(context) {
    AchievementView(
      title: "Congratulations you have got free shipping",
      subTitle: "Applied successfully 🥳",
      color: Colors.amberAccent,
      duration: const Duration(seconds: 2),
      elevation: 2,
      icon: Icon(
        FontAwesomeIcons.faceLaughBeam,
        color: scaffoldColor,
      ),
      textStyleTitle: TextStyle(fontFamily: 'Dosis', color: scaffoldColor),
      textStyleSubTitle: TextStyle(fontFamily: 'Dosis', color: scaffoldColor),
      borderRadius: BorderRadius.circular(17).r,
    ).show(context);
  }

  void showAddress(context, DateTime date) {
    AchievementView(
      title: "Yeaaah! 🤩",
      subTitle:
          "${DateFormat('yyyy-MM-dd').format(date).toString()}  Picked successfully",
      color: textColor,
      duration: const Duration(milliseconds: 1000),
      elevation: 2,
      icon: Icon(
        Icons.tag_faces,
        color: scaffoldColor,
      ),
      textStyleTitle: TextStyle(fontFamily: 'Dosis', color: scaffoldColor),
      textStyleSubTitle: TextStyle(fontFamily: 'Dosis', color: scaffoldColor),
      borderRadius: BorderRadius.circular(17).r,
    ).show(context);
  }
}
