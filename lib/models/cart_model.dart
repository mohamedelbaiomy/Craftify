import 'package:icons_plus/icons_plus.dart';

import '../widgets/auto_direction.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:customers_app_google_play/providers/constants2.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../providers/product_class.dart';
import '../providers/wish_provider.dart';

class CartModel extends StatelessWidget {
  const CartModel({Key? key, required this.product, required this.cart})
      : super(key: key);

  final Product product;
  final Cart cart;

  @override
  Widget build(BuildContext context) {
    return Card(
      /*  borderOnForeground: true,
      semanticContainer: true,*/
      elevation: 5,
      color: Colors.transparent,
      child: SizedBox(
        height: 80.h,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(5).r,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(8).r,
                  topRight: const Radius.circular(8).r,
                  bottomLeft: const Radius.circular(8).r,
                  bottomRight: const Radius.circular(8).r,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1.5.w, color: Colors.black),
                    borderRadius: BorderRadius.circular(5).r,
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      filterQuality: FilterQuality.high,
                      image: CachedNetworkImageProvider(
                        product.imagesUrl,
                      ),
                    ),
                  ),
                  height: 90.h,
                  width: 98.w,
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(6).r,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: AutoDirection(
                        text: product.name,
                        child: Text(
                          product.name,
                          maxLines: 2,
                          style: TextStyle(
                            fontFamily: 'Dosis',
                            letterSpacing: 1.5.sp,
                            fontSize: 14.5.sp,
                            fontWeight: FontWeight.w500,
                            color: textColor,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "price : ${product.price.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontFamily: 'Dosis',
                            letterSpacing: 0.8.sp,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: textColor,
                          ),
                        ),
                        product.qty == 1
                            ? Container(
                                height: 25.h,
                                width: 25.w,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade600,
                                  shape: BoxShape.circle,
                                ),
                                child: MaterialButton(
                                  shape: const CircleBorder(),
                                  splashColor: Colors.white70,
                                  elevation: 5,
                                  autofocus: true,
                                  padding: const EdgeInsets.only(right: 0).r,
                                  onPressed: () {
                                    showCupertinoModalPopup<void>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          CupertinoActionSheet(
                                        title: Text(
                                          'Remove Item',
                                          style: TextStyle(
                                            fontFamily: 'Dosis',
                                            color: Colors.black,
                                            letterSpacing: 1.sp,
                                          ),
                                        ),
                                        message: Text(
                                          'Are you sure to remove this item ?',
                                          style: TextStyle(
                                            fontFamily: 'Dosis',
                                            color: Colors.black,
                                            letterSpacing: 1.sp,
                                          ),
                                        ),
                                        actions: <CupertinoActionSheetAction>[
                                          CupertinoActionSheetAction(
                                            child: Text(
                                              'Move To Wishlist',
                                              style: TextStyle(
                                                fontFamily: 'Dosis',
                                                color: Colors.green,
                                                letterSpacing: 1.sp,
                                              ),
                                            ),
                                            onPressed: () async {
                                              context
                                                          .read<Wish>()
                                                          .getWishItems
                                                          .firstWhereOrNull((element) =>
                                                              element
                                                                  .documentId ==
                                                              product
                                                                  .documentId) !=
                                                      null
                                                  ? context
                                                      .read<Cart>()
                                                      .removeItem(product)
                                                  : context
                                                      .read<Wish>()
                                                      .addWishItem(
                                                        Product(
                                                          documentId: product
                                                              .documentId,
                                                          name: product.name,
                                                          price: product.price,
                                                          qty: 1,
                                                          qntty: product.qntty,
                                                          imagesUrl:
                                                              product.imagesUrl,
                                                          suppId:
                                                              product.suppId,
                                                        ),
                                                      );
                                              await Future.delayed(
                                                const Duration(
                                                  microseconds: 100,
                                                ),
                                              ).whenComplete(
                                                () {
                                                  context
                                                      .read<Cart>()
                                                      .removeItem(product);
                                                  Get.back();
                                                },
                                              );
                                            },
                                          ),
                                          CupertinoActionSheetAction(
                                            child: Text(
                                              'Delete Item',
                                              style: TextStyle(
                                                fontFamily: 'Dosis',
                                                letterSpacing: 1.sp,
                                                color: Colors.redAccent,
                                              ),
                                            ),
                                            onPressed: () {
                                              context
                                                  .read<Cart>()
                                                  .removeItem(product);
                                              Get.back();
                                            },
                                          ),
                                        ],
                                        cancelButton: TextButton(
                                          onPressed: () {
                                            Get.back();
                                          },
                                          child: Text(
                                            'Cancel',
                                            style: TextStyle(
                                              fontFamily: 'Dosis',
                                              fontSize: 19.sp,
                                              letterSpacing: 1.sp,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Icon(
                                    Icons.delete_forever,
                                    color: scaffoldColor,
                                    size: 14.5.sp,
                                  ),
                                ),
                              )
                            : Container(
                                height: 25.h,
                                width: 25.w,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade600,
                                  shape: BoxShape.circle,
                                ),
                                child: MaterialButton(
                                  shape: const CircleBorder(),
                                  splashColor: Colors.white70,
                                  elevation: 5,
                                  autofocus: true,
                                  padding: const EdgeInsets.only(right: 0).r,
                                  onPressed: () {
                                    cart.reduceByOne(product);
                                  },
                                  child: Icon(
                                    PixelArtIcons.minus,
                                    size: 14.5.sp,
                                  ),
                                ),
                              ),
                        Text(
                          product.qty.toString(),
                          style: product.qty == product.qntty
                              ? TextStyle(
                                  fontFamily: 'Dosis',
                                  fontSize: 15.5.sp,
                                  color: Colors.red,
                                )
                              : TextStyle(
                                  fontFamily: 'Dosis',
                                  fontSize: 15.5.sp,
                                  color: textColor,
                                ),
                        ),
                        Container(
                          height: 25.h,
                          width: 25.w,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade600,
                            shape: BoxShape.circle,
                          ),
                          child: MaterialButton(
                            shape: const CircleBorder(),
                            splashColor: Colors.white70,
                            elevation: 5,
                            autofocus: true,
                            padding: const EdgeInsets.only(right: 0).r,
                            onPressed: product.qty == product.qntty
                                ? null
                                : () {
                                    cart.increment(product);
                                  },
                            child: Icon(
                              PixelArtIcons.plus,
                              size: 14.5.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
