import 'package:customers_app_google_play/main_screens/customer_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:icons_plus/icons_plus.dart';

import '../widgets/auto_direction.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:customers_app_google_play/customer_screens/add_address.dart';
import 'package:customers_app_google_play/providers/constants2.dart';
import 'package:customers_app_google_play/providers/id_provider.dart';
import 'package:customers_app_google_play/widgets/appbar_widgets.dart';
import 'package:customers_app_google_play/widgets/buttons.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class AddressBook extends StatefulWidget {
  const AddressBook({Key? key}) : super(key: key);

  @override
  State<AddressBook> createState() => _AddressBookState();
}

class _AddressBookState extends State<AddressBook> {
  late String docId;

  @override
  void initState() {
    docId = context.read<IdProvider>().getData;
    super.initState();
  }

  Future dfAddressFalse(dynamic item) async {
    await FirebaseFirestore.instance.runTransaction(
      (transaction) async {
        DocumentReference documentReference = FirebaseFirestore.instance
            .collection('customers')
            .doc(docId)
            .collection('address')
            .doc(item.id);
        transaction.update(documentReference, {'default': false});
      },
    );
  }

  Future dfAddressTrue(dynamic customer) async {
    await FirebaseFirestore.instance.runTransaction(
      (transaction) async {
        DocumentReference documentReference = FirebaseFirestore.instance
            .collection('customers')
            .doc(docId)
            .collection('address')
            .doc(customer['addressid']);
        transaction.update(documentReference, {'default': true});
      },
    );
  }

  Future updateProfile(dynamic customer) async {
    await FirebaseFirestore.instance.runTransaction(
      (transaction) async {
        DocumentReference documentReference =
            FirebaseFirestore.instance.collection('customers').doc(docId);
        transaction.update(documentReference, {
          "address":
              "${customer['country']} - ${customer['state']} - ${customer['city']}",
          "phone": customer['phone'],
        });
      },
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

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> addressStream = FirebaseFirestore.instance
        .collection('customers')
        .doc(docId)
        .collection('address')
        .snapshots();
    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: scaffoldColor,
        leading: AppBarBackButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const CustomerHomeScreen(),
                ),
                (route) => false);
          },
        ),
        title: const AppBarTitle(
          title: 'Address Book',
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15).r,
                    ),
                    backgroundColor: Colors.grey.shade200,
                    child: SizedBox(
                      height: 250.h,
                      width: 300.w,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(height: 20.h),
                          Lottie.asset(
                            "assets/json/77365-location-lottie-animation.json",
                            filterQuality: FilterQuality.high,
                            repeat: true,
                            height: 60.h,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(14).r,
                            child: Text(
                              "Tap on the address you want to be your default address",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20.sp, fontFamily: 'Dosis'),
                            ),
                          ),
                          MaterialButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            color: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30).r,
                            ),
                            child: const Text(
                              "Close",
                              style: TextStyle(
                                  fontFamily: 'Dosis', color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            icon: Icon(
              PixelArtIcons.notification,
              size: 20.sp,
              color: Colors.white70,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: addressStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text(
                    'Something went wrong',
                    style: TextStyle(fontFamily: 'Dosis', color: textColor),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return gallariesSpinkit;
                }

                if (snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      "You haven't set \n\n an address yet",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Dosis',
                        fontSize: 26,
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  );
                }

                return AnimationLimiter(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 55,
                      left: 10,
                    ).r,
                    child: ListView.builder(
                      /*physics: const BouncingScrollPhysics(
                        decelerationRate: ScrollDecelerationRate.normal,
                        parent: AlwaysScrollableScrollPhysics(),
                      ),*/
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var customer = snapshot.data!.docs[index];
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 350),
                          child: SlideAnimation(
                            verticalOffset: 50,
                            child: FadeInAnimation(
                              child: Dismissible(
                                key: UniqueKey(),
                                direction: DismissDirection.startToEnd,
                                background: Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 20)
                                          .r,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFE6E6),
                                    borderRadius: BorderRadius.circular(17).r,
                                  ),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                          "assets/images/Trash.svg"),
                                      const Spacer(),
                                    ],
                                  ),
                                ),
                                movementDuration: const Duration(seconds: 2),
                                onDismissed: (direction) async {
                                  await FirebaseFirestore.instance
                                      .runTransaction((transaction) async {
                                    DocumentReference docReference =
                                        FirebaseFirestore.instance
                                            .collection('customers')
                                            .doc(docId)
                                            .collection('address')
                                            .doc(customer['addressid']);
                                    transaction.delete(docReference);
                                  });
                                  await FirebaseFirestore.instance
                                      .runTransaction(
                                    (transaction) async {
                                      DocumentReference documentReference =
                                          FirebaseFirestore.instance
                                              .collection('customers')
                                              .doc(FirebaseAuth
                                                  .instance.currentUser!.uid);
                                      transaction.update(
                                        documentReference,
                                        {
                                          'address': '',
                                          'phone': '',
                                        },
                                      );
                                    },
                                  );
                                },
                                child: GestureDetector(
                                  onTap: () async {
                                    showProgress();
                                    for (var item in snapshot.data!.docs) {
                                      await dfAddressFalse(item);
                                    }
                                    await dfAddressTrue(customer).whenComplete(
                                      () => updateProfile(customer),
                                    );
                                    Future.delayed(
                                      const Duration(microseconds: 100),
                                    ).whenComplete(
                                      () => Navigator.pop(context),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(4).r,
                                    child: Card(
                                      color: customer['default'] == true
                                          ? Colors.black
                                          : Colors.white,
                                      child: ListTile(
                                        trailing: customer['default'] == true
                                            ? const Icon(
                                                PixelArtIcons.home,
                                                color: Colors.white,
                                              )
                                            : const SizedBox(),
                                        title: SizedBox(
                                          height: 45.h,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${customer['firstname']} ${customer['lastname']}",
                                                style: TextStyle(
                                                  fontFamily: 'Dosis',
                                                  letterSpacing: 1.sp,
                                                  fontSize: 14.sp,
                                                  color: customer['default'] ==
                                                          true
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Text(
                                                "${customer['phone']}",
                                                style: TextStyle(
                                                  fontFamily: 'Dosis',
                                                  letterSpacing: 1.sp,
                                                  fontSize: 14.sp,
                                                  color: customer['default'] ==
                                                          true
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        subtitle: SizedBox(
                                          height: 80.h,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "city - state :  ${customer['city']} - ${customer['state']}",
                                                style: TextStyle(
                                                  fontFamily: 'Dosis',
                                                  fontSize: 15,
                                                  color: customer['default'] ==
                                                          true
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "full Ad : ",
                                                    style: TextStyle(
                                                      fontFamily: 'Dosis',
                                                      fontSize: 14.sp,
                                                      color:
                                                          customer['default'] ==
                                                                  true
                                                              ? Colors.white
                                                              : Colors.black,
                                                      fontWeight:
                                                          FontWeight.w600,
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
                                                        color: customer[
                                                                    'default'] ==
                                                                true
                                                            ? Colors.white
                                                            : Colors.black,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                "country : ${customer['country']}",
                                                style: TextStyle(
                                                  fontFamily: 'Dosis',
                                                  letterSpacing: 1.sp,
                                                  fontSize: 14.sp,
                                                  color: customer['default'] ==
                                                          true
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            color: scaffoldColor,
            padding: const EdgeInsets.only(
              top: 5,
            ).r,
            child: CommonButton(
              borderRadius: 9,
              title: 'Add New Address',
              onPressed: () {
                Get.to(
                  const AddAddress(),
                  transition: Transition.leftToRight,
                );
              },
              width: 0.7,
              height: 34,
              borderColor: textColor,
              textColor: textColor,
              fillColor: scaffoldColor,
              letterSpacing: 2,
            ),
          ),
          SizedBox(height: 14.h),
        ],
      ),
    );
  }
}
