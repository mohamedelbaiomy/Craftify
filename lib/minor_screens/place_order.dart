import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../widgets/Delayed_Widget_Code.dart';
import '../widgets/auto_direction.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:customers_app_google_play/customer_screens/add_address.dart';
import 'package:customers_app_google_play/customer_screens/address_book.dart';
import 'package:customers_app_google_play/minor_screens/checkout_screen.dart';
import 'package:customers_app_google_play/providers/cart_provider.dart';
import 'package:customers_app_google_play/widgets/appbar_widgets.dart';
import 'package:customers_app_google_play/widgets/buttons.dart';
import 'package:provider/provider.dart';

import '../providers/constants2.dart';
import '../providers/id_provider.dart';

class PlaceOrderScreen extends StatefulWidget {
  const PlaceOrderScreen({Key? key}) : super(key: key);

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  late String docId;
  CollectionReference customers =
      FirebaseFirestore.instance.collection('customers');
  late String name;
  late String phone;
  late String address;

  @override
  void initState() {
    docId = context.read<IdProvider>().getData;
    super.initState();
  }

  late final Stream<QuerySnapshot> addressStream = FirebaseFirestore.instance
      .collection('customers')
      .doc(/*FirebaseAuth.instance.currentUser!.uid*/ docId)
      .collection('address')
      .where('default', isEqualTo: true)
      .limit(1)
      .snapshots();
  @override
  Widget build(BuildContext context) {
    double totalPrice = context.watch<Cart>().totalPrice;
    return SafeArea(
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
            title: 'Place Order',
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 8).r,
          child: StreamBuilder<QuerySnapshot>(
            stream: addressStream,
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                            style: TextStyle(
                                fontFamily: 'Dosis', color: textColor),
                          ),
                        ),
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
              return Column(
                children: [
                  snapshot.data!.docs.isEmpty
                      ? GestureDetector(
                          onTap: () {
                            Get.to(
                              const AddAddress(),
                              transition: Transition.fade,
                            );
                          },
                          child: Container(
                            height: 135.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white60,
                              borderRadius: BorderRadius.circular(10).r,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 16,
                              ).r,
                              child: Center(
                                child: Text(
                                  'tap to set your address',
                                  style: TextStyle(
                                    fontFamily: 'Dosis',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20.sp,
                                    letterSpacing: 1.sp,
                                    color: textColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            Get.to(
                              const AddressBook(),
                              transition: Transition.fade,
                            );
                          },
                          child: Row(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  /*  physics: const BouncingScrollPhysics(
                                    decelerationRate:
                                        ScrollDecelerationRate.normal,
                                    parent: AlwaysScrollableScrollPhysics(),
                                  ),*/
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    var customer = snapshot.data!.docs[index];
                                    name = "${customer['firstname']} "
                                        "${customer['lastname']}";
                                    phone = customer['phone'];
                                    address = customer['country'] +
                                        ' - ' +
                                        customer['state'] +
                                        ' - ' +
                                        customer['city'];
                                    return SingleChildScrollView(
                                      /* physics: const BouncingScrollPhysics(
                                        decelerationRate:
                                            ScrollDecelerationRate.fast,
                                        parent: AlwaysScrollableScrollPhysics(),
                                      ),*/
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Text(
                                            name,
                                            style: TextStyle(
                                              letterSpacing: 2.sp,
                                              fontSize: 14.sp,
                                              fontFamily: 'Dosis',
                                              color: textColor,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            phone,
                                            style: TextStyle(
                                              letterSpacing: 2.sp,
                                              fontFamily: 'Dosis',
                                              fontSize: 14.sp,
                                              color: textColor,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            "city - state : ${customer['city']} - ${customer['state']}",
                                            style: TextStyle(
                                              letterSpacing: 1.sp,
                                              fontSize: 14.sp,
                                              fontFamily: 'Dosis',
                                              color: textColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            "country : ${customer['country']}",
                                            style: TextStyle(
                                              letterSpacing: 1.sp,
                                              fontFamily: 'Dosis',
                                              fontSize: 14.sp,
                                              color: textColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(height: 4.h),
                                          Row(
                                            children: [
                                              Text(
                                                "full Ad : ",
                                                style: TextStyle(
                                                  fontFamily: 'Dosis',
                                                  fontSize: 14.sp,
                                                  letterSpacing: 1.sp,
                                                  color: textColor,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              AutoDirection(
                                                text:
                                                    "${customer['fulladdress']}",
                                                child: Text(
                                                  "${customer['fulladdress']}",
                                                  style: TextStyle(
                                                    fontFamily: 'Dosis',
                                                    fontSize: 14.sp,
                                                    letterSpacing: 1.sp,
                                                    color: textColor,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 4.h),
                                          Row(
                                            children: [
                                              Text(
                                                "Notes : ",
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontFamily: 'Dosis',
                                                  letterSpacing: 1.sp,
                                                  color: textColor,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Flexible(
                                                child: AutoDirection(
                                                  text: "${customer['notes']}",
                                                  child: Text(
                                                    "${customer['notes']}",
                                                    style: TextStyle(
                                                      fontFamily: 'Dosis',
                                                      fontSize: 14.sp,
                                                      letterSpacing: 1.sp,
                                                      color: textColor,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                  SizedBox(height: 30.h),
                  Expanded(
                    child: Consumer<Cart>(
                      builder: (context, cart, child) {
                        return ListView.builder(
                          itemCount: cart.count,
                          /* physics: const BouncingScrollPhysics(
                            decelerationRate: ScrollDecelerationRate.normal,
                            parent: AlwaysScrollableScrollPhysics(),
                          ),*/
                          itemBuilder: (context, index) {
                            final order = cart.getItems[index];
                            return Row(
                              children: [
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting)
                                  Center(
                                    child: gallariesSpinkit,
                                  )
                                else
                                  Padding(
                                    padding: const EdgeInsets.all(3).r,
                                    child: Container(
                                      height: 80.h,
                                      width: 95.w,
                                      decoration: BoxDecoration(
                                        /*  border: Border.all(
                                          width: 1.w,
                                          color: Colors.white,
                                        ),*/
                                        borderRadius:
                                            BorderRadius.circular(7).r,
                                        image: DecorationImage(
                                          fit: BoxFit.fill,
                                          filterQuality: FilterQuality.high,
                                          image: CachedNetworkImageProvider(
                                            order.imagesUrl,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                SizedBox(width: 10.w),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AutoDirection(
                                        text: order.name,
                                        child: Text(
                                          order.name,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontFamily: 'Dosis',
                                            fontSize: 14.sp,
                                            letterSpacing: 0.8.sp,
                                            fontWeight: FontWeight.w600,
                                            color: textColor,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 25.h),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "price : ${order.price.toStringAsFixed(2)}",
                                            style: TextStyle(
                                              fontFamily: 'Dosis',
                                              fontSize: 14.sp,
                                              letterSpacing: 0.8.sp,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white60,
                                            ),
                                          ),
                                          Text(
                                            'x ${order.qty.toString()}',
                                            style: TextStyle(
                                              fontFamily: 'Dosis',
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white60,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 50.h),
                  CommonButton(
                    borderRadius: 8.sp,
                    title: 'Confirm ${totalPrice.toStringAsFixed(2)} EGP',
                    onPressed: snapshot.data!.docs.isEmpty
                        ? () {
                            Get.to(
                              const AddressBook(),
                              transition: Transition.fadeIn,
                            );
                          }
                        : () {
                            Get.to(
                              CheckOutScreen(
                                name: name,
                                address: address,
                                phone: phone,
                              ),
                              transition: Transition.rightToLeftWithFade,
                            );
                          },
                    width: 0.7,
                    height: 34,
                    borderColor: textColor,
                    textColor: scaffoldColor,
                    fillColor: textColor,
                    letterSpacing: 2,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
