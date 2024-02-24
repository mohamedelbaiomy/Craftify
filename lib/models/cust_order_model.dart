import 'package:customers_app_google_play/main_screens/customer_home.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../widgets/auto_direction.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:customers_app_google_play/minor_screens/order_details.dart';
import '../providers/constants2.dart';
import '../widgets/buttons.dart';
import '../widgets/snackbar.dart';

class CustomerOrderModel extends StatefulWidget {
  final dynamic order;
  const CustomerOrderModel({super.key, required this.order});

  @override
  State<CustomerOrderModel> createState() => _CustomerOrderModelState();
}

class _CustomerOrderModelState extends State<CustomerOrderModel> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  late double rate;
  String comment = "";
  int currentStep = 0;
  @override
  Widget build(BuildContext context) {
    List<Step> steps = [
      widget.order['deliverystatus'] == 'preparing'
          ? Step(
              title: const Text(
                'Preparing',
                style: TextStyle(
                  fontFamily: 'Dosis',
                  fontSize: 11.5,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              state: widget.order['deliverystatus'] == 'shipping'
                  ? StepState.disabled
                  : StepState.complete,
              isActive: true,
              content: const Text(
                "The order is on Preparing right now",
                style: TextStyle(
                    fontFamily: 'Dosis', letterSpacing: 1, color: Colors.black),
              ),
            )
          : const Step(
              title: Text(
                'Preparing',
                style: TextStyle(
                  fontFamily: 'Dosis',
                  fontSize: 11.5,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              state: StepState.complete,
              content: Text(
                "The order has been prepared successfully",
                style: TextStyle(
                  fontFamily: 'Dosis',
                  letterSpacing: 0.5,
                  color: Colors.black,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ),
      widget.order['deliverystatus'] == 'shipping'
          ? Step(
              title: const Text(
                'Shipping',
                style: TextStyle(
                  fontFamily: 'Dosis',
                  fontSize: 11.5,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              isActive: true,
              content: widget.order['deliverystatus'] == 'shipping'
                  ? Text(
                      ('Estimated Delivery Date: ') +
                          (
                            DateFormat('yyyy-MM-dd').format(
                              widget.order['deliverydate'].toDate(),
                            ),
                          ).toString(),
                      style: const TextStyle(
                        fontFamily: 'Dosis',
                        letterSpacing: 1,
                        color: Colors.black,
                      ),
                    )
                  : Stack(
                      children: [
                        Container(),
                      ],
                    ),
            )
          : Step(
              title: const Text(
                'Shipping',
                style: TextStyle(
                  fontFamily: 'Dosis',
                  fontSize: 11.5,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              state: widget.order['deliverystatus'] == 'delivered'
                  ? StepState.complete
                  : StepState.indexed,
              content: widget.order['deliverystatus'] == 'shipping' ||
                      widget.order['deliverystatus'] == 'delivered'
                  ? Text(
                      ('Delivered Date: ') +
                          (DateFormat('yyyy-MM-dd').format(
                                  widget.order['deliverydate'].toDate()))
                              .toString(),
                      style: const TextStyle(
                        fontFamily: 'Dosis',
                        letterSpacing: 1,
                        color: Colors.black,
                        decoration: TextDecoration.lineThrough,
                      ),
                    )
                  : const Text(
                      "The order hasn't been shipped  yet",
                      style: TextStyle(
                        fontFamily: 'Dosis',
                        letterSpacing: 1,
                        color: Colors.black,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
            ),
      widget.order['deliverystatus'] == 'delivered'
          ? const Step(
              title: Text(
                'Delivered',
                style: TextStyle(
                    fontFamily: 'Dosis',
                    fontSize: 11.5,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              isActive: true,
              state: StepState.complete,
              content: Text(
                "The order has been delivered successfully",
                style: TextStyle(
                  fontFamily: 'Dosis',
                  color: Colors.black,
                  letterSpacing: 0.5,
                ),
              ),
            )
          : const Step(
              title: Text(
                'Delivered',
                style: TextStyle(
                  fontFamily: 'Dosis',
                  fontSize: 11.5,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              content: Text(
                "The order hasn't been delivered yet",
                style: TextStyle(
                  fontFamily: 'Dosis',
                  letterSpacing: 0.5,
                  color: Colors.black,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ),
    ];
    return InkWell(
      onTap: () {
        Get.to(
          OrderDetails(order: widget.order),
          transition: Transition.rightToLeft,
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(3).r,
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(right: 20, left: 20, top: 12).r,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            /*   border: widget.order['deliverystatus'] == 'preparing'
                ? Border.all(color: Colors.green, width: 3.r)
                : (widget.order['deliverystatus'] == 'shipping'
                    ? Border.all(color: Colors.amber, width: 3.r)
                    : (widget.order['deliverystatus'] == 'delivered'
                        ? Border.all(color: Colors.blue, width: 3.r)
                        : Border.all())),*/
            borderRadius: BorderRadius.circular(14).r,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, top: 20).r,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Order ID:\n${widget.order['orderid']}",
                        style: TextStyle(
                          color: scaffoldColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13.sp,
                          letterSpacing: 1.sp,
                          fontFamily: 'Dosis',
                        ),
                      ),
                      Text(
                        DateFormat.yMMMd()
                            .add_jm()
                            .format(widget.order['orderdate'].toDate())
                            .toString(),
                        style: TextStyle(
                          color: scaffoldColor,
                          fontSize: 12.sp,
                          letterSpacing: 1.sp,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Dosis',
                        ),
                      ),
                      Divider(thickness: 1.5.sp),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 70.h),
                        child: ListTile(
                          trailing: Text(
                            ('x  ') + (widget.order['orderqty'].toString()),
                            style: TextStyle(
                              fontFamily: 'Dosis',
                              letterSpacing: 1.sp,
                              color: Colors.black,
                            ),
                          ),
                          leading: Container(
                            constraints:
                                BoxConstraints(maxHeight: 70.h, maxWidth: 50.w),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5).r,
                              child: CachedNetworkImage(
                                imageUrl: widget.order['orderimage'],
                                filterQuality: FilterQuality.high,
                                fit: BoxFit.fill,
                                matchTextDirection: true,
                                placeholder: (context, url) =>
                                    SpinKitThreeBounce(
                                  color: Colors.black87,
                                  size: 20.sp,
                                ),
                                errorWidget: (context, url, error) =>
                                    Lottie.asset(
                                  "assets/json/imageError.json",
                                  filterQuality: FilterQuality.high,
                                  height: 40.h,
                                  width: 100.w,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          title: AutoDirection(
                            text: widget.order['ordername'],
                            child: Text(
                              "${widget.order['ordername']}",
                              style: TextStyle(
                                fontFamily: 'Dosis',
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Divider(thickness: 2.sp),
                      SizedBox(height: 10.h),
                      Text(
                        'EGP  '
                        "${widget.order['orderprice'].toStringAsFixed(2)}",
                        style: TextStyle(
                          fontFamily: 'Dosis',
                          letterSpacing: 2.sp,
                          fontSize: 13.5.sp,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                widget.order['deliverystatus'] == 'delivered' &&
                        widget.order['orderreview'] == false
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 10).r,
                        child: Center(
                          child: CommonButton(
                            borderRadius: 8.r,
                            title: 'Write Review',
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => ScaffoldMessenger(
                                  key: _scaffoldKey,
                                  child: Scaffold(
                                    backgroundColor: scaffoldColor,
                                    body: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 140,
                                      ).r,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Thanks for using Craftify',
                                                style: TextStyle(
                                                  fontFamily: 'Dosis',
                                                  fontSize: 18.sp,
                                                  letterSpacing: 2.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: textColor,
                                                ),
                                              ),
                                              SizedBox(width: 10.w),
                                              Icon(
                                                FontAwesomeIcons.faceLaughWink,
                                                color: textColor,
                                                size: 17.sp,
                                              ),
                                            ],
                                          ),
                                          RatingBar.builder(
                                            itemBuilder: (context, _) {
                                              return const Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              );
                                            },
                                            unratedColor: textColor,
                                            onRatingUpdate: (value) {
                                              rate = value;
                                            },
                                            initialRating: 1,
                                            minRating: 1,
                                            updateOnDrag: true,
                                            allowHalfRating: true,
                                          ),
                                          TextFormField(
                                            decoration: InputDecoration(
                                              hintText: 'enter your review',
                                              hintStyle: TextStyle(
                                                fontFamily: 'Dosis',
                                                letterSpacing: 1.2.sp,
                                                color: Colors.white70,
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10).r,
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: buttonsColor,
                                                  width: 0.5.w,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10).r,
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: buttonsColor,
                                                  width: 1.3.w,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10).r,
                                              ),
                                            ),
                                            style: TextStyle(
                                              fontFamily: 'Dosis',
                                              letterSpacing: 0.5.sp,
                                              color: textColor,
                                            ),
                                            onChanged: (value) {
                                              comment = value.trim();
                                            },
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              CommonButton(
                                                borderRadius: 7.sp,
                                                title: 'Cancel',
                                                onPressed: () {
                                                  Get.back();
                                                },
                                                width: 0.2.w,
                                                height: 30.h,
                                                borderColor: textColor,
                                                textColor: scaffoldColor,
                                                fillColor: textColor,
                                                letterSpacing: 1.sp,
                                              ),
                                              SizedBox(width: 20.w),
                                              CommonButton(
                                                borderRadius: 7.sp,
                                                title: 'Ok',
                                                onPressed: () async {
                                                  if (comment != "") {
                                                    showProgress();
                                                    CollectionReference collRef =
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'products')
                                                            .doc(widget
                                                                .order['proid'])
                                                            .collection(
                                                                'reviews');
                                                    await collRef
                                                        .doc(FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid)
                                                        .set(
                                                      {
                                                        'name': widget
                                                            .order['custname'],
                                                        'email': widget
                                                            .order['email'],
                                                        'rate': rate,
                                                        'cid':
                                                            widget.order['cid'],
                                                        'comment': comment,
                                                        'profileimage':
                                                            widget.order[
                                                                'profileimage'],
                                                      },
                                                    ).whenComplete(
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
                                                                        'orders')
                                                                    .doc(
                                                                      widget.order[
                                                                          'orderid'],
                                                                    );
                                                            transaction.update(
                                                              documentReference,
                                                              {
                                                                'orderreview':
                                                                    true
                                                              },
                                                            );
                                                          },
                                                        );
                                                      },
                                                    );
                                                    await Future.delayed(
                                                      const Duration(
                                                        microseconds: 50,
                                                      ),
                                                    ).whenComplete(
                                                      () {
                                                        Navigator
                                                            .pushAndRemoveUntil(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          const CustomerHomeScreen(),
                                                                ),
                                                                (route) =>
                                                                    false);
                                                      },
                                                    );
                                                  } else {
                                                    MyMessageHandler
                                                        .showSnackBar(
                                                      _scaffoldKey,
                                                      'please fill all fields',
                                                    );
                                                  }
                                                },
                                                width: 0.2.w,
                                                height: 30.h,
                                                borderColor: textColor,
                                                textColor: scaffoldColor,
                                                fillColor: textColor,
                                                letterSpacing: 1.sp,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            width: 0.31.w,
                            height: 27.h,
                            borderColor: textColor,
                            textColor: scaffoldColor,
                            fillColor: Colors.black12,
                            letterSpacing: 1.sp,
                          ),
                        ),
                      )
                    : (widget.order['orderreview'] == true
                        ? const Text("")
                        : Padding(
                            padding: const EdgeInsets.all(8).r,
                            child: SizedBox(
                              height: 80.h,
                              width: 280.w,
                              child: Stepper(
                                elevation: 2,
                                controlsBuilder: (context, controller) {
                                  return const SizedBox.shrink();
                                },
                                steps: steps,
                                type: StepperType.horizontal,
                                physics: const NeverScrollableScrollPhysics(),
                                currentStep: currentStep,
                                onStepTapped: (step) {
                                  setState(() {
                                    currentStep = step;
                                  });
                                },
                              ),
                            ),
                          )),
              ],
            ),
          ),
        ),
      ),
    );
  }

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
}
