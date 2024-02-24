import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import '../models/cust_order_model.dart';
import '../providers/constants2.dart';
import '../widgets/appbar_widgets.dart';

class CustomerOrders extends StatefulWidget {
  const CustomerOrders({Key? key}) : super(key: key);

  @override
  State<CustomerOrders> createState() => _CustomerOrdersState();
}

class _CustomerOrdersState extends State<CustomerOrders> {
  final Stream<QuerySnapshot> _ordersStream = FirebaseFirestore.instance
      .collection('orders')
      .where('cid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .orderBy('orderdate', descending: true)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: scaffoldColor,
        centerTitle: true,
        leading: AppBarBackButton(
          onPressed: () {
            Get.back();
          },
        ),
        title: const AppBarTitle(
          title: 'Orders',
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _ordersStream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Something went wrong',
                style: TextStyle(
                  fontFamily: 'Dosis',
                  color: textColor,
                  letterSpacing: 1.sp,
                  fontSize: 15.sp,
                ),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return SpinKitWanderingCubes(
              color: textColor,
              size: 40.sp,
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "You don't Have Any Orders !",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Dosis",
                  fontSize: 20.sp,
                  color: textColor,
                  letterSpacing: 1.sp,
                ),
              ),
            );
          }
          return AnimationLimiter(
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              addAutomaticKeepAlives: true,
              addSemanticIndexes: true,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 300),
                  delay: const Duration(milliseconds: 300),
                  child: SlideAnimation(
                    verticalOffset: 60,
                    horizontalOffset: 5,
                    child: FadeInAnimation(
                      child: CustomerOrderModel(
                        order: snapshot.data!.docs[index],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
