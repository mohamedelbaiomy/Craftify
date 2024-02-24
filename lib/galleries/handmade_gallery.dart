import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

import '../models/product_model.dart';
import '../providers/constants2.dart';

class HandmadeGalleryScreen extends StatefulWidget {
  const HandmadeGalleryScreen({Key? key}) : super(key: key);

  @override
  State<HandmadeGalleryScreen> createState() => _HandmadeGalleryScreenState();
}

class _HandmadeGalleryScreenState extends State<HandmadeGalleryScreen>
    with AutomaticKeepAliveClientMixin<HandmadeGalleryScreen> {
  final Stream<QuerySnapshot> _prodcutsStream = FirebaseFirestore.instance
      .collection('products')
      .where('maincateg', isEqualTo: 'handmade')
      .where('discount', isEqualTo: 0)
/* .where(
        Filter.and(
          Filter('subcateg', isEqualTo: 'Wooden Antiques'),
          Filter('subcateg', isEqualTo: 'Croshe'),
          Filter('subcateg', isEqualTo: 'Treko'),
          Filter('subcateg', isEqualTo: 'other'),
        ),
      )

.where('subcateg', isEqualTo: "Wooden Antiques")
      .limit(1)
      .where('subcateg', isEqualTo: "Croshe")
      .limit(1)
      .where('subcateg', isEqualTo: "Treko")
      .limit(1)
      .where('subcateg', isEqualTo: "other")
      .limit(1)

   .where(
    'subcateg',
    arrayContainsAny: [
      'Wooden Antiques',
      'Croshe',
      'Treko',
      'other',
    ],
  ) */

      .snapshots();
  bool shouldKeepAlive = true;

  @override
  bool get wantKeepAlive => shouldKeepAlive;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder<QuerySnapshot>(
      stream: _prodcutsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            Container();
            break;

          default:
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Something went wrong',
                  style: TextStyle(
                    fontFamily: 'Dosis',
                    color: textColor,
                    letterSpacing: 1.sp,
                  ),
                ),
              );
            }

            if (snapshot.data!.docs.isEmpty) {
              return Padding(
                padding: const EdgeInsets.only(top: 130).r,
                child: Text(
                  'no items yet !',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Dosis',
                    fontSize: 21.sp,
                    color: Colors.white54,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5.sp,
                  ),
                ),
              );
            }

            return AnimationLimiter(
              child: StaggeredGridView.countBuilder(
                padding: EdgeInsets.zero,
                /* physics: const BouncingScrollPhysics(
                    decelerationRate: ScrollDecelerationRate.normal),*/
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(
                  decelerationRate: ScrollDecelerationRate.normal,
                ),
                crossAxisCount: 2,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return AnimationConfiguration.staggeredGrid(
                    position: index,
                    duration: const Duration(milliseconds: 550),
                    delay: const Duration(milliseconds: 150),
                    columnCount: snapshot.data!.docs.length,
                    child: SlideAnimation(
                      verticalOffset: 10,
                      horizontalOffset: 5,
                      child: FadeInAnimation(
                        child: ProductModel(
                          products: snapshot.data!.docs[index],
                        ),
                      ),
                    ),
                  );
                },
                staggeredTileBuilder: (context) => const StaggeredTile.fit(1),
              ),
            );
        }
        return Container();
      },
    );
  }
}
