import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:customers_app_google_play/minor_screens/place_order.dart';
import 'package:customers_app_google_play/models/cart_model.dart';
import 'package:customers_app_google_play/providers/cart_provider.dart';
import 'package:customers_app_google_play/providers/id_provider.dart';
import 'package:customers_app_google_play/widgets/alert_dialog.dart';
import 'package:customers_app_google_play/widgets/appbar_widgets.dart';
import 'package:customers_app_google_play/widgets/buttons.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';

import '../providers/constants2.dart';
import '../providers/product_class.dart';
import '../providers/wish_provider.dart';

class CartScreen extends StatefulWidget {
  final Widget? back;

  const CartScreen({Key? key, this.back}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen>
    with AutomaticKeepAliveClientMixin<CartScreen> {
  late String docId;

  @override
  void initState() {
    docId = context.read<IdProvider>().getData;
    super.initState();
  }

  bool shouldKeepAlive = true;

  @override
  bool get wantKeepAlive => shouldKeepAlive;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
      GlobalKey<LiquidPullToRefreshState>();

  Future<void> _handleRefresh() {
    final Completer<void> completer = Completer<void>();
    Timer(const Duration(seconds: 1), () {
      completer.complete();
    });
    setState(() {
      docId = context.read<IdProvider>().getData;
    });
    return completer.future.then<void>((_) {
      ScaffoldMessenger.of(_scaffoldKey.currentState!.context).showSnackBar(
        SnackBar(
          content: const Text('Refresh complete'),
          action: SnackBarAction(
            label: 'RETRY',
            backgroundColor: Colors.white,
            textColor: Colors.black,
            onPressed: () {
              _refreshIndicatorKey.currentState!.show();
            },
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double total = context.watch<Cart>().totalPrice;
    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        centerTitle: widget.back == null ? false : true,
        automaticallyImplyLeading: false,
        leading: widget.back,
        backgroundColor: scaffoldColor,
        elevation: 0,
        title: const AppBarTitle(title: 'Cart'),
        actions: [
          context.watch<Cart>().getItems.isEmpty
              ? const SizedBox()
              : Container(
                  height: 28.h,
                  width: 28.w,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: MaterialButton(
                    shape: const CircleBorder(),
                    splashColor: Colors.white70,
                    elevation: 5,
                    padding: const EdgeInsets.only(right: 0).r,
                    onPressed: () {
                      MyAlertDilaog.showMyDialog(
                        context: context,
                        title: 'Clear Cart',
                        content: 'Are you sure to clear cart ?',
                        tabNo: () {
                          Get.back();
                        },
                        tabYes: () {
                          context.read<Cart>().clearCart();
                          Get.back();
                        },
                      );
                    },
                    child: Icon(
                      PixelArtIcons.briefcase_delete,
                      color: textColor,
                    ),
                  ),
                ),
        ],
      ),
      body: context.watch<Cart>().getItems.isNotEmpty
          ? LiquidPullToRefresh(
              key: _refreshIndicatorKey,
              onRefresh: _handleRefresh,
              showChildOpacityTransition: false,
              backgroundColor: scaffoldColor,
              color: textColor,
              child: const CartItems(),
            )
          : const EmptyCart(),
      bottomSheet: Container(
        color: scaffoldColor,
        child: Padding(
          padding: const EdgeInsets.all(8).r,
          child: context.watch<Cart>().getItems.isNotEmpty
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Total : LE  ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17.sp,
                            fontFamily: 'Dosis',
                            letterSpacing: 1.sp,
                            color: textColor,
                          ),
                        ),
                        Text(
                          total.toStringAsFixed(2),
                          style: TextStyle(
                            fontSize: 17.sp,
                            color: textColor,
                            fontFamily: 'Dosis',
                            letterSpacing: 1.sp,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10).r,
                      child: CommonButton(
                        borderRadius: 8.sp,
                        title: 'Check Out',
                        onPressed: total == 0.0
                            ? () {
                                // shoppingDialog(context);
                              }
                            : docId == '' &&
                                    FirebaseAuth
                                        .instance.currentUser!.uid.isEmpty
                                ? () {
                                    logInDialog(context);
                                  }
                                : () {
                                    Get.to(
                                      const PlaceOrderScreen(),
                                      transition:
                                          Transition.rightToLeftWithFade,
                                    );
                                  },
                        width: 0.35,
                        height: 34,
                        borderColor: textColor,
                        textColor: textColor,
                        fillColor: scaffoldColor,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                )
              : const SizedBox(width: double.infinity),
        ),
      ),
    );
  }

  void logInDialog(context) {
    showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(
          "please log in",
          style: TextStyle(
            fontFamily: 'Dosis',
            letterSpacing: 1.sp,
          ),
        ),
        content: Text(
          "you should be logged in to take an action",
          style: TextStyle(
            fontFamily: 'Dosis',
            letterSpacing: 1.sp,
          ),
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            child: Text(
              "Cancel",
              style: TextStyle(
                fontFamily: 'Dosis',
                letterSpacing: 1.sp,
              ),
            ),
            onPressed: () {
              Get.back();
            },
          ),
          CupertinoDialogAction(
            child: Text(
              "Log In",
              style: TextStyle(
                fontFamily: 'Dosis',
                letterSpacing: 1.sp,
              ),
            ),
            onPressed: () {
              Get.offNamed('/customer_login');
            },
          ),
        ],
      ),
    );
  }

  void shoppingDialog(context) {
    showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(
          "Your cart is empty",
          style: TextStyle(
            fontFamily: 'Dosis',
            letterSpacing: 1.sp,
          ),
        ),
        content: Text(
          "you have to add items to check it out",
          style: TextStyle(
            fontFamily: 'Dosis',
            letterSpacing: 1.sp,
          ),
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            child: Text(
              "Go Shopping",
              style: TextStyle(
                fontFamily: 'Dosis',
                letterSpacing: 1.sp,
                color: scaffoldColor,
              ),
            ),
            onPressed: () {
              Get.offNamed('/customer_home');
            },
          ),
        ],
      ),
    );
  }
}

class EmptyCart extends StatelessWidget {
  const EmptyCart({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(
        Icons.shopping_cart_outlined,
        size: 185.sp,
        color: Colors.grey.shade600,
      ),
    );
  }
}

class CartItems extends StatelessWidget {
  const CartItems({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 55,
        left: 15,
        right: 10,
      ).r,
      child: Consumer<Cart>(
        builder: (context, cart, child) {
          return ListView.builder(
            itemCount: cart.count,
            shrinkWrap: true,
            //physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final product = cart.getItems[index];
              return Slidable(
                key: UniqueKey(),
                direction: Axis.horizontal,
                startActionPane: ActionPane(
                  // A motion is a widget used to control how the pane animates.
                  motion: const DrawerMotion(),
                  // A pane can dismiss the Slidable.
                  dismissible: DismissiblePane(
                    onDismissed: () {
                      context.read<Cart>().removeItem(product);
                    },
                  ),
                  // All actions are defined in the children parameter.
                  children: [
                    SlidableAction(
                      onPressed: (_) {
                        context.read<Cart>().removeItem(product);
                      },
                      backgroundColor: const Color(0xFFFE4A49),
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                      borderRadius: BorderRadius.circular(5).r,
                      autoClose: true,
                    ),
                    SlidableAction(
                      onPressed: (_) async {
                        context.read<Wish>().getWishItems.firstWhereOrNull(
                                    (element) =>
                                        element.documentId ==
                                        product.documentId) !=
                                null
                            ? Get.back()
                            : context.read<Wish>().addWishItem(
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
                        await Future.delayed(
                          const Duration(microseconds: 100),
                        ).whenComplete(
                          () {
                            //context.read<Cart>().removeItem(product);
                            Get.back();
                          },
                        );
                      },
                      backgroundColor: const Color(0xFF21B7CA),
                      foregroundColor: Colors.white,
                      icon: Icons.favorite,
                      padding: const EdgeInsets.all(2).r,
                      label: 'Favourite',
                      borderRadius: BorderRadius.circular(5).r,
                      autoClose: false,
                    ),
                  ],
                ),

                // The end action pane is the one at the right or the bottom side.
                /*endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      // An action can be bigger than the others.
                      flex: 2,
                      onPressed: (_) {},
                      backgroundColor: const Color(0xFF7BC043),
                      foregroundColor: Colors.white,
                      icon: Icons.archive,
                      label: 'Archive',
                    ),
                    SlidableAction(
                      onPressed: (_) {},
                      backgroundColor: const Color(0xFF0392CF),
                      foregroundColor: Colors.white,
                      icon: Icons.save,
                      label: 'Save',
                    ),
                  ],
                ),*/
                child: CartModel(
                  product: product,
                  cart: context.read<Cart>(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
