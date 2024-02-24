import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../minor_screens/product_details.dart';
import '../providers/constants2.dart';
import '../providers/product_class.dart';
import '../providers/wish_provider.dart';
import '../widgets/auto_direction.dart';

class StoreModel extends StatefulWidget {
  final dynamic products;
  const StoreModel({Key? key, required this.products}) : super(key: key);

  @override
  State<StoreModel> createState() => _StoreModelState();
}

class _StoreModelState extends State<StoreModel> {
  late final Stream<QuerySnapshot> reviewsStream = FirebaseFirestore.instance
      .collection('products')
      .doc(widget.products['proid'])
      .collection('reviews')
      .snapshots();
  @override
  Widget build(BuildContext context) {
    var onSale = widget.products['discount'];
    return InkWell(
      onTap: () {
        Get.to(
          ProductDetailsScreen(
            proList: widget.products,
          ),
          transition: Transition.leftToRightWithFade,
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(5).r,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: scaffoldColor,
                borderRadius: BorderRadius.circular(9).r,
                border: Border.all(
                  color: Colors.white38,
                  width: 0.5.w,
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5).r,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(8).r,
                        topRight: const Radius.circular(8).r,
                      ),
                      child: Container(
                        constraints: const BoxConstraints(
                          minHeight: 150,
                          maxHeight: 200,
                        ),
                        child: CachedNetworkImage(
                          imageUrl: widget.products['proimages'][0],
                          filterQuality: FilterQuality.high,
                          fit: BoxFit.fill,
                          height: 190.h,
                          placeholder: (context, url) => SpinKitThreeBounce(
                            color: Colors.white60,
                            size: 19.sp,
                          ),
                          errorWidget: (context, url, error) => Lottie.asset(
                            "assets/json/imageError.json",
                            filterQuality: FilterQuality.high,
                            height: 50,
                            width: 250,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(7).r,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoDirection(
                          text: widget.products['proname'],
                          child: Text(
                            "${widget.products['proname']}",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Dosis',
                              color: textColor,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(height: 9.h),
                        StreamBuilder<QuerySnapshot>(
                          stream: reviewsStream,
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot2) {
                            if (snapshot2.connectionState ==
                                ConnectionState.waiting) {
                              return Row(
                                children: [
                                  RatingBar.builder(
                                    itemBuilder: (context, _) {
                                      return const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      );
                                    },
                                    unratedColor: textColor,
                                    onRatingUpdate: (value) {},
                                    ignoreGestures: true,
                                    itemSize: 16.sp,
                                    initialRating: 0,
                                    minRating: 0,
                                    allowHalfRating: true,
                                  ),
                                  Text(
                                    "  ( 0 )",
                                    style: TextStyle(
                                      fontFamily: 'Dosis',
                                      color: textColor,
                                      letterSpacing: 0.7.sp,
                                      fontSize: 10.sp,
                                    ),
                                  ),
                                ],
                              );
                            }
                            double totReviews = 0.0;
                            for (var item in snapshot2.data!.docs) {
                              totReviews += item['rate'];
                            }
                            double avgReviews =
                                totReviews / snapshot2.data!.docs.length;
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                snapshot2.data!.docs.isNotEmpty
                                    ? Row(
                                        children: [
                                          RatingBar.builder(
                                            itemBuilder: (context, _) {
                                              return const Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              );
                                            },
                                            unratedColor: textColor,
                                            onRatingUpdate: (value) {},
                                            ignoreGestures: true,
                                            itemSize: 16.sp,
                                            initialRating: avgReviews,
                                            minRating: 0,
                                            allowHalfRating: true,
                                          ),
                                          Text(
                                            "  ( ${snapshot2.data!.docs.length} )",
                                            style: TextStyle(
                                              fontFamily: 'Dosis',
                                              letterSpacing: 0.7.sp,
                                              color: textColor,
                                              fontSize: 10.sp,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        children: [
                                          RatingBar.builder(
                                            itemBuilder: (context, _) {
                                              return const Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              );
                                            },
                                            unratedColor: textColor,
                                            onRatingUpdate: (value) {},
                                            ignoreGestures: true,
                                            itemSize: 16.sp,
                                            initialRating: 0,
                                            minRating: 0,
                                            allowHalfRating: true,
                                          ),
                                          Text(
                                            "  ( 0 )",
                                            style: TextStyle(
                                              fontFamily: 'Dosis',
                                              letterSpacing: 1.sp,
                                              color: textColor,
                                              fontSize: 10.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                              ],
                            );
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'EGP  ',
                              style: TextStyle(
                                fontFamily: 'Dosis',
                                color: textColor,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              widget.products['price'].toStringAsFixed(2),
                              style: onSale != 0
                                  ? TextStyle(
                                      fontFamily: 'Dosis',
                                      letterSpacing: 1,
                                      color: Colors.grey,
                                      fontSize: 11.sp,
                                      decoration: TextDecoration.lineThrough,
                                      fontWeight: FontWeight.w500,
                                    )
                                  : TextStyle(
                                      fontFamily: 'Dosis',
                                      letterSpacing: 1,
                                      color: textColor,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                            ),
                            const SizedBox(width: 6),
                            onSale != 0
                                ? Text(
                                    ((1 - (widget.products['discount'] / 100)) *
                                            widget.products['price'])
                                        .toStringAsFixed(2),
                                    style: TextStyle(
                                      fontFamily: 'Dosis',
                                      letterSpacing: 1.sp,
                                      color: textColor,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                : const Text(''),
                            GestureDetector(
                              onTap: () {
                                var existingItemWishlist = context
                                    .read<Wish>()
                                    .getWishItems
                                    .firstWhereOrNull((product) =>
                                        product.documentId ==
                                        widget.products['proid']);
                                existingItemWishlist != null
                                    ? context
                                        .read<Wish>()
                                        .removeThis(widget.products['proid'])
                                    : context.read<Wish>().addWishItem(
                                          Product(
                                            documentId:
                                                widget.products['proid'],
                                            name: widget.products['proname'],
                                            price: onSale != 0
                                                ? ((1 -
                                                        (widget.products[
                                                                'discount'] /
                                                            100)) *
                                                    widget.products['price'])
                                                : widget.products['price'],
                                            qty: 1,
                                            qntty: widget.products['instock'],
                                            imagesUrl: widget
                                                .products.imagesList.first,
                                            suppId: widget.products['sid'],
                                          ),
                                        );
                              },
                              child: context
                                          .watch<Wish>()
                                          .getWishItems
                                          .firstWhereOrNull((product) =>
                                              product.documentId ==
                                              widget.products['proid']) !=
                                      null
                                  ? const Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                      size: 25,
                                    )
                                  : const Icon(
                                      Icons.favorite_outline,
                                      color: Colors.red,
                                      size: 25,
                                    ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            onSale != 0
                ? Positioned(
                    top: 28.sp,
                    left: 0.sp,
                    child: Container(
                      height: 24.h,
                      width: 78.w,
                      decoration: BoxDecoration(
                        color: scaffoldColor,
                        borderRadius: BorderRadius.only(
                          topRight: const Radius.circular(10).r,
                          bottomRight: const Radius.circular(10).r,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Save ${onSale.toString()} %',
                          style: TextStyle(
                            fontFamily: 'Dosis',
                            color: textColor,
                            letterSpacing: 1.sp,
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(
                    color: Colors.transparent,
                  ),
          ],
        ),
      ),
    );
  }
}
