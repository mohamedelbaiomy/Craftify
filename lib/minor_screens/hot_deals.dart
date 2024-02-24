import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:customers_app_google_play/providers/constants2.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

import '../main_screens/customer_home.dart';
import '../models/product_model.dart';

class HotDealsScreen extends StatefulWidget {
  final bool fromOnBoarding;
  final String maxDiscount;

  const HotDealsScreen(
      {Key? key, this.fromOnBoarding = false, required this.maxDiscount})
      : super(key: key);

  @override
  State<HotDealsScreen> createState() => _HotDealsScreenState();
}

class _HotDealsScreenState extends State<HotDealsScreen> {
  final Stream<QuerySnapshot> prodcutsStream = FirebaseFirestore.instance
      .collection('products')
      .where('discount', isNotEqualTo: 0)
      .snapshots()
      .take(1);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: textColor,
        //widget.fromOnBoarding == true
        leading: IconButton(
          onPressed: () {
            Get.off(
              const CustomerHomeScreen(),
            );
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: scaffoldColor,
            size: 15,
          ),
        ),
        //: const BlackBackButton(),
        title: SizedBox(
          height: 170,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 65,
                right: 15,
                child: Center(
                  child: DefaultTextStyle(
                    style: TextStyle(
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..color = scaffoldColor
                        ..strokeWidth = 1
                        ..strokeCap = StrokeCap.butt
                        ..strokeJoin = StrokeJoin.bevel,
                      fontSize: 40,
                      letterSpacing: 4,
                    ),
                    child: AnimatedTextKit(
                      totalRepeatCount: 5,
                      animatedTexts: [
                        TypewriterAnimatedText(
                          'Hot Deals ',
                          speed: const Duration(milliseconds: 60),
                        ),
                        TypewriterAnimatedText(
                          'up to ${widget.maxDiscount} % off ',
                          speed: const Duration(
                            milliseconds: 60,
                          ),
                          textStyle: const TextStyle(
                            fontFamily: 'Dosis',
                            fontSize: 34,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: 50,
            color: textColor,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 0.5, right: 0.5),
            child: Container(
              decoration: BoxDecoration(
                color: scaffoldColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: prodcutsStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text(
                      'Something went wrong',
                      style: TextStyle(
                        fontFamily: 'Dosis',
                        color: textColor,
                        letterSpacing: 1,
                      ),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return gallariesSpinkit;
                  }

                  if (snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        'This category \n\n has no items yet !',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Dosis',
                          fontSize: 26,
                          color: Colors.white54,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.only(top: 10, left: 5, right: 5),
                    child: AnimationLimiter(
                      child: StaggeredGridView.countBuilder(
                        /* physics: const BouncingScrollPhysics(
                          decelerationRate: ScrollDecelerationRate.normal,
                        ),*/
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        crossAxisCount: 2,
                        itemBuilder: (context, index) {
                          return AnimationConfiguration.staggeredGrid(
                            position: index,
                            duration: const Duration(milliseconds: 400),
                            delay: const Duration(milliseconds: 150),
                            columnCount: snapshot.data!.docs.length,
                            child: SlideAnimation(
                              verticalOffset: 40,
                              horizontalOffset: 20,
                              child: FadeInAnimation(
                                child: ProductModel(
                                  products: snapshot.data!.docs[index],
                                ),
                              ),
                            ),
                          );
                        },
                        staggeredTileBuilder: (context) =>
                            const StaggeredTile.fit(1),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
