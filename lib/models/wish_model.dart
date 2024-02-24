import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../providers/constants2.dart';
import '../providers/product_class.dart';
import '../providers/wish_provider.dart';
import '../widgets/auto_direction.dart';

class WishlistModel extends StatelessWidget {
  const WishlistModel({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Card(
      /*   borderOnForeground: true,
      semanticContainer: true,*/
      color: Colors.transparent,
      elevation: 5,
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
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: AutoDirection(
                        text: product.name,
                        child: Text(
                          product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Dosis',
                            letterSpacing: 1.5.sp,
                            fontSize: 15.sp,
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
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                context.read<Wish>().removeItem(product);
                              },
                              icon: Icon(
                                Icons.delete_forever,
                                color: textColor,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            context.watch<Cart>().getItems.firstWhereOrNull(
                                            (element) =>
                                                element.documentId ==
                                                product.documentId) !=
                                        null ||
                                    product.qntty == 0
                                ? const SizedBox()
                                : IconButton(
                                    onPressed: () {
                                      context.read<Cart>().addCartItem(
                                            Product(
                                              documentId: product.documentId,
                                              name: product.name,
                                              price: product.price,
                                              qty: 1,
                                              qntty: product.qntty,
                                              imagesUrl: product.imagesUrl,
                                              suppId: product.suppId,
                                            ),
                                          );
                                    },
                                    icon: Icon(
                                      Icons.add_shopping_cart,
                                      color: textColor,
                                    ),
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
