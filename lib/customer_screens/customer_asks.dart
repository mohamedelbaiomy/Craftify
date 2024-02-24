import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

import '../models/ask_model.dart';
import '../providers/constants2.dart';
import '../widgets/appbar_widgets.dart';

class CustomerAsks extends StatefulWidget {
  const CustomerAsks({Key? key}) : super(key: key);

  @override
  State<CustomerAsks> createState() => _CustomerAsksState();
}

class _CustomerAsksState extends State<CustomerAsks> {
  final Stream<QuerySnapshot> askStream = FirebaseFirestore.instance
      .collection('asks')
      .where('cid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      //.orderBy('orderdate', descending: true)
      .orderBy('askdate', descending: true)
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
          title: 'Asks',
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: askStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Something went wrong',
                style: TextStyle(
                  fontFamily: 'Dosis',
                  color: textColor,
                  letterSpacing: 2,
                  fontSize: 18,
                ),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return SpinKitWanderingCubes(
              color: textColor,
              size: 60,
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "You don't Have Any Asks !",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Dosis",
                  fontSize: 24,
                  color: textColor,
                  letterSpacing: 1,
                ),
              ),
            );
          }
          return AnimationLimiter(
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              /* physics: const BouncingScrollPhysics(
                decelerationRate: ScrollDecelerationRate.normal,
                parent: AlwaysScrollableScrollPhysics(),
              ),*/
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 300),
                  delay: const Duration(milliseconds: 300),
                  child: SlideAnimation(
                    verticalOffset: 50,
                    child: FadeInAnimation(
                      child: AskModel(
                        ask: snapshot.data!.docs[index],
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
