import 'package:achievement_view/achievement_view.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:badges/badges.dart' as badges;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lottie/lottie.dart';
import 'package:customers_app_google_play/main_screens/cart.dart';
import 'package:customers_app_google_play/main_screens/visit_store.dart';
import 'package:customers_app_google_play/minor_screens/full_screen_view.dart';
import 'package:customers_app_google_play/providers/cart_provider.dart';
import 'package:customers_app_google_play/providers/constants2.dart';
import 'package:customers_app_google_play/providers/product_class.dart';
import 'package:customers_app_google_play/widgets/appbar_widgets.dart';
import 'package:customers_app_google_play/widgets/buttons.dart';
import 'package:customers_app_google_play/widgets/snackbar.dart';
import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import '../models/similar_items_model.dart';
import '../providers/wish_provider.dart';
import '../widgets/auto_direction.dart';

class ProductDetailsScreen extends StatefulWidget {
  final dynamic proList;

  const ProductDetailsScreen({Key? key, required this.proList})
      : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late final Stream<QuerySnapshot> _prodcutsStream = FirebaseFirestore.instance
      .collection('products')
      .where('maincateg', isEqualTo: widget.proList['maincateg'])
      .where('subcateg', isEqualTo: widget.proList['subcateg'])
      .snapshots();
  late final Stream<QuerySnapshot> reviewsStream = FirebaseFirestore.instance
      .collection('products')
      .doc(widget.proList['proid'])
      .collection('reviews')
      .snapshots();
  CollectionReference suppliers =
      FirebaseFirestore.instance.collection('suppliers');

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  late List<dynamic> imagesList = widget.proList['proimages'];

  SwiperController swiperController = SwiperController();

  @override
  Widget build(BuildContext context) {
    var onSale = widget.proList['discount'];
    var existingItemCart = context.read<Cart>().getItems.firstWhereOrNull(
        (element) => element.documentId == widget.proList['proid']);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: scaffoldColor,
        body: CustomScrollView(
          /* physics: const BouncingScrollPhysics(
            decelerationRate: ScrollDecelerationRate.normal,
            parent: AlwaysScrollableScrollPhysics(),
          ),*/
          slivers: <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              leading: Padding(
                padding: const EdgeInsets.all(6).r,
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      //borderRadius: BorderRadius.circular(65).r,
                      color: scaffoldColor,
                    ),
                    child: Icon(
                      PixelArtIcons.arrow_left,
                      color: textColor,
                      size: 17.sp,
                    ),
                  ),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(7).r,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      //borderRadius: BorderRadius.circular(65).r,
                      color: scaffoldColor,
                    ),
                    child: IconButton(
                      onPressed: () {
                        var existingItemWishlist = context
                            .read<Wish>()
                            .getWishItems
                            .firstWhereOrNull((product) =>
                                product.documentId == widget.proList['proid']);
                        existingItemWishlist != null
                            ? context
                                .read<Wish>()
                                .removeThis(widget.proList['proid'])
                            : context.read<Wish>().addWishItem(
                                  Product(
                                    documentId: widget.proList['proid'],
                                    name: widget.proList['proname'],
                                    price: onSale != 0
                                        ? ((1 -
                                                (widget.proList['discount'] /
                                                    100)) *
                                            widget.proList['price'])
                                        : widget.proList['price'],
                                    qty: 1,
                                    qntty: widget.proList['instock'],
                                    imagesUrl: imagesList.first,
                                    suppId: widget.proList['sid'],
                                  ),
                                );
                      },
                      icon: context.watch<Wish>().getWishItems.firstWhereOrNull(
                                  (product) =>
                                      product.documentId ==
                                      widget.proList['proid']) !=
                              null
                          ? Icon(
                              Icons.favorite,
                              color: Colors.red,
                              size: 22.sp,
                            )
                          : Icon(
                              Icons.favorite_outline,
                              color: Colors.red,
                              size: 22.sp,
                            ),
                    ),
                  ),
                ),
              ],
              toolbarHeight: 45.h,
              backgroundColor: Colors.transparent,
              expandedHeight: 330.w,
              flexibleSpace: FlexibleSpaceBar(
                background: Swiper(
                  itemHeight: double.infinity,
                  controller: swiperController,
                  itemCount: imagesList.length,
                  pagination: SwiperCustomPagination(
                    builder: (BuildContext context, SwiperPluginConfig config) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 10, bottom: 10).r,
                        child: Align(
                          alignment: AlignmentDirectional.bottomStart,
                          child: Container(
                            width: 45.w,
                            padding: const EdgeInsets.all(6).r,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9).r,
                              color: scaffoldColor,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  ('${config.activeIndex + 1}'),
                                  style: TextStyle(
                                    color: textColor,
                                    fontFamily: 'Dosis',
                                    fontSize: 13.5.sp,
                                  ),
                                ),
                                Text(
                                  "  /",
                                  style: TextStyle(
                                    color: textColor,
                                    fontFamily: 'Dosis',
                                  ),
                                ),
                                Text(
                                  ' ${config.itemCount}',
                                  style: TextStyle(
                                    fontFamily: 'Dosis',
                                    color: textColor,
                                    fontSize: 9.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  scale: 0.72.sp,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        Get.to(
                          FullScreenView(
                            imagesList: imagesList,
                          ),
                          transition: Transition.fadeIn,
                        );
                      },
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                        imageUrl: imagesList[index],
                        placeholder: (context, url) => SpinKitThreeBounce(
                          color: Colors.white60,
                          size: 30.sp,
                        ),
                        errorWidget: (context, url, error) => Lottie.asset(
                          "assets/json/imageError.json",
                          filterQuality: FilterQuality.high,
                          height: 45.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 10.h)),
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 40).r,
                  child: AnimationLimiter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: AnimationConfiguration.toStaggeredList(
                        duration: const Duration(milliseconds: 300),
                        delay: const Duration(milliseconds: 100),
                        childAnimationBuilder: (widget) => SlideAnimation(
                          horizontalOffset: 5,
                          child: FadeInAnimation(
                            child: widget,
                          ),
                        ),
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AutoDirection(
                                text: widget.proList['proname'],
                                child: Text(
                                  widget.proList['proname'],
                                  style: TextStyle(
                                    fontFamily: 'Dosis',
                                    color: textColor,
                                    fontSize: 20.sp,
                                    letterSpacing: 1.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    'EGP   ',
                                    style: TextStyle(
                                      fontFamily: 'Dosis',
                                      color: textColor,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  onSale != 0
                                      ? Text(
                                          ((1 -
                                                      (widget.proList[
                                                              'discount'] /
                                                          100)) *
                                                  widget.proList['price'])
                                              .toStringAsFixed(2),
                                          style: TextStyle(
                                            fontFamily: 'Dosis',
                                            color: textColor,
                                            fontSize: 14.sp,
                                            letterSpacing: 1.2.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        )
                                      : const Text(''),
                                  SizedBox(width: 5.w),
                                  Text(
                                    widget.proList['price'].toStringAsFixed(2),
                                    style: onSale != 0
                                        ? TextStyle(
                                            fontFamily: 'Dosis',
                                            color: Colors.grey,
                                            fontSize: 12.sp,
                                            letterSpacing: 1.sp,
                                            decoration:
                                                TextDecoration.lineThrough,
                                            fontWeight: FontWeight.w500,
                                          )
                                        : TextStyle(
                                            fontFamily: 'Dosis',
                                            color: textColor,
                                            fontSize: 16.sp,
                                            letterSpacing: 1.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              StreamBuilder<QuerySnapshot>(
                                stream: reviewsStream,
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot2) {
                                  QuerySnapshot<Object?>? snapshot =
                                      snapshot2.data;
                                  if (snapshot2.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: SpinKitRipple(
                                        color: textColor,
                                        size: 9.sp,
                                      ),
                                    );
                                  }
                                  double totReviews = 0.0;
                                  for (var item in snapshot!.docs) {
                                    totReviews += item['rate'];
                                  }
                                  double avgReviews =
                                      totReviews / snapshot.docs.length;
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      snapshot2.data!.docs.isNotEmpty
                                          ? Row(
                                              children: [
                                                Text(
                                                  "$totReviews ",
                                                  style: TextStyle(
                                                    fontFamily: 'Dosis',
                                                    letterSpacing: 1.sp,
                                                    color: textColor,
                                                    fontSize: 10.sp,
                                                  ),
                                                ),
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
                                                  itemSize: 14.sp,
                                                  initialRating: avgReviews,
                                                  minRating: 0,
                                                  allowHalfRating: true,
                                                ),
                                                Text(
                                                  "  (  ${snapshot2.data!.docs.length}  )",
                                                  style: TextStyle(
                                                    fontFamily: 'Dosis',
                                                    color: textColor,
                                                    fontSize: 11.sp,
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
                                                  unratedColor: Colors.white70,
                                                  onRatingUpdate: (value) {},
                                                  ignoreGestures: true,
                                                  itemSize: 14.sp,
                                                  initialRating: 0,
                                                  minRating: 0,
                                                  allowHalfRating: true,
                                                ),
                                                Text(
                                                  "  (  ${snapshot2.data!.docs.length}  )",
                                                  style: TextStyle(
                                                    fontFamily: "Dosis",
                                                    color: textColor,
                                                    letterSpacing: 1.sp,
                                                    fontSize: 10.5.sp,
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ],
                                  );
                                },
                              ),
                              FutureBuilder<DocumentSnapshot>(
                                future:
                                    suppliers.doc(widget.proList['sid']).get(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                                  if (snapshot.hasError) {
                                    return Text(
                                      "Something went wrong",
                                      style: TextStyle(
                                        fontFamily: 'Dosis',
                                        color: textColor,
                                      ),
                                    );
                                  }
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Row(
                                      children: [
                                        Text(
                                          "Sup : ",
                                          style: TextStyle(
                                            fontFamily: 'Dosis',
                                            fontSize: 11.5.sp,
                                            letterSpacing: 1.sp,
                                            color: textColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          ".... Loading",
                                          style: TextStyle(
                                            fontFamily: 'Dosis',
                                            fontSize: 11.sp,
                                            letterSpacing: 1.sp,
                                            color: Colors.white60,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                  Map<String, dynamic> data = snapshot.data!
                                      .data() as Map<String, dynamic>;
                                  return Text(
                                    "Sup : ${data['storename'].toUpperCase()}",
                                    style: TextStyle(
                                      fontFamily: 'Dosis',
                                      fontSize: 12.sp,
                                      letterSpacing: 1.sp,
                                      color: textColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 14.h),
                          widget.proList['instock'] == 0
                              ? Text(
                                  'this item is out of stock',
                                  style: TextStyle(
                                    fontFamily: 'Dosis',
                                    fontSize: 14.sp,
                                    letterSpacing: 1.sp,
                                    color: Colors.white60,
                                  ),
                                )
                              : Text(
                                  (widget.proList['instock'].toString()) +
                                      ('  pieces available in stock'),
                                  style: TextStyle(
                                    fontFamily: 'Dosis',
                                    letterSpacing: 1.5.sp,
                                    fontSize: 14.sp,
                                    color: Colors.white60,
                                  ),
                                ),
                          //  const ProDetailsHeader(label: '   Description   '),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 25, bottom: 7).r,
                            child: SizedBox(
                              child: AutoDirection(
                                text: widget.proList['prodesc'],
                                child: Text(
                                  widget.proList['prodesc'],
                                  textScaleFactor: 1.1,
                                  style: TextStyle(
                                    fontFamily: 'Dosis',
                                    letterSpacing: 0.7.sp,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: textColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 15.h),
                          ExpandableTheme(
                            data: const ExpandableThemeData(
                              hasIcon: false,
                            ),
                            child: reviews(reviewsStream),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 95.w,
                                child: Divider(
                                  color: Colors.grey,
                                  thickness: 1.sp,
                                ),
                              ),
                              Text(
                                '   Related Products  ',
                                style: TextStyle(
                                  fontFamily: 'Dosis',
                                  letterSpacing: 0.5.sp,
                                  color: textColor,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                width: 95.w,
                                child: Divider(
                                  color: Colors.grey,
                                  thickness: 1.sp,
                                ),
                              ),
                            ],
                          ),
                          StreamBuilder<QuerySnapshot>(
                            stream: _prodcutsStream,
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return Text(
                                  'Something went wrong',
                                  style: TextStyle(
                                    fontFamily: 'Dosis',
                                    color: textColor,
                                  ),
                                );
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return gallariesSpinkit;
                              }

                              if (snapshot.data!.docs.isEmpty) {
                                return Center(
                                  child: Text(
                                    'no similar items yet !',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'Dosis',
                                      fontSize: 15.sp,
                                      color: textColor,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.3.sp,
                                    ),
                                  ),
                                );
                              }

                              return StaggeredGridView.countBuilder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                padding: const EdgeInsets.only(top: 15).r,
                                itemCount: snapshot.data!.docs.length,
                                crossAxisCount: 2,
                                itemBuilder: (context, index) {
                                  return SimilarItemsModel(
                                    products: snapshot.data!.docs[index],
                                  );
                                },
                                staggeredTileBuilder: (context) =>
                                    const StaggeredTile.fit(1),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomSheet: Container(
          color: scaffoldColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10).r,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.to(
                          VisitStore(
                            suppId: widget.proList['sid'],
                          ),
                          transition: Transition.fadeIn,
                        );
                      },
                      icon: Icon(
                        Icons.store,
                        color: textColor,
                        size: 22.sp,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Get.to(
                          CartScreen(
                            back: AppBarBackButton(
                              onPressed: () {
                                Get.back();
                              },
                            ),
                          ),
                          transition: Transition.fadeIn,
                        );
                      },
                      icon: badges.Badge(
                        showBadge: context.read<Cart>().getItems.isEmpty
                            ? false
                            : true,
                        badgeContent: Text(
                          softWrap: true,
                          context.watch<Cart>().getItems.length.toString(),
                          style: TextStyle(
                            fontFamily: 'Dosis',
                            color: textColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        child: Icon(
                          Icons.shopping_cart,
                          color: textColor,
                          size: 22.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                widget.proList['instock'] == 0
                    ? Container(
                        margin: const EdgeInsets.only(right: 50).r,
                        height: 30.h,
                        width: 150.w,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(5).r,
                          border: Border.all(color: textColor),
                        ),
                        child: Center(
                          child: Text(
                            "Out Of Stock",
                            style: TextStyle(
                              fontFamily: 'Dosis',
                              color: textColor,
                              letterSpacing: 2.sp,
                            ),
                          ),
                        ),
                      )
                    : Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 11,
                              left: 0,
                              top: 0,
                              bottom: 0,
                            ).r,
                            child: CommonButton(
                              borderRadius: 7.sp,
                              title: "Buy Now",
                              onPressed: () {
                                if (existingItemCart != null) {
                                  Get.to(
                                    CartScreen(
                                      back: AppBarBackButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                      ),
                                    ),
                                    transition: Transition.fadeIn,
                                  );
                                } else {
                                  context.read<Cart>().addCartItem(
                                        Product(
                                          documentId: widget.proList['proid'],
                                          name: widget.proList['proname'],
                                          price: onSale != 0
                                              ? ((1 -
                                                      (widget.proList[
                                                              'discount'] /
                                                          100)) *
                                                  widget.proList['price'])
                                              : widget.proList['price'],
                                          qty: 1,
                                          qntty: widget.proList['instock'],
                                          imagesUrl: imagesList.first,
                                          suppId: widget.proList['sid'],
                                        ),
                                      );
                                  Get.to(
                                    CartScreen(
                                      back: AppBarBackButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                      ),
                                    ),
                                    transition: Transition.fadeIn,
                                  );
                                }
                              },
                              width: 0.24.w,
                              height: 30.h,
                              borderColor: textColor,
                              textColor: textColor,
                              fillColor: scaffoldColor,
                              letterSpacing: 1.sp,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 11,
                              left: 0,
                              top: 0,
                              bottom: 0,
                            ).r,
                            child: CommonButton(
                              borderRadius: 7.sp,
                              title: existingItemCart != null
                                  ? 'Added To Cart'
                                  : 'ADD TO CART',
                              onPressed: () {
                                if (existingItemCart != null) {
                                  MyMessageHandler.showSnackBar(
                                    _scaffoldKey,
                                    'this item already in cart',
                                  );
                                } else {
                                  showPickedProduct(
                                      context, widget.proList['proname']);
                                  AudioPlayer().play(
                                    AssetSource(
                                      'sounds/add_to_cart.wav',
                                    ),
                                  );
                                  context.read<Cart>().addCartItem(
                                        Product(
                                          documentId: widget.proList['proid'],
                                          name: widget.proList['proname'],
                                          price: onSale != 0
                                              ? ((1 -
                                                      (widget.proList[
                                                              'discount'] /
                                                          100)) *
                                                  widget.proList['price'])
                                              : widget.proList['price'],
                                          qty: 1,
                                          qntty: widget.proList['instock'],
                                          imagesUrl: imagesList.first,
                                          suppId: widget.proList['sid'],
                                        ),
                                      );
                                }
                              },
                              width: 0.24.w,
                              height: 30.h,
                              borderColor: textColor,
                              textColor: existingItemCart != null
                                  ? Colors.redAccent
                                  : scaffoldColor,
                              fillColor: textColor,
                              letterSpacing: 0.sp,
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showPickedProduct(context, String proname) {
    AchievementView(
      title: widget.proList['proname'],
      subTitle: "added to cart",
      color: textColor,
      duration: const Duration(seconds: 1),
      elevation: 2,
      icon: Icon(
        Icons.tag_faces,
        color: scaffoldColor,
      ),
      textStyleTitle: TextStyle(fontFamily: 'Dosis', color: scaffoldColor),
      textStyleSubTitle: TextStyle(fontFamily: 'Dosis', color: scaffoldColor),
      borderRadius: BorderRadius.circular(20).r,
    ).show(context);
  }

  Widget reviews(var reviewsStream) {
    return ExpandablePanel(
      header: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 15.h,
            width: 130.w,
            child: Divider(
              color: Colors.grey,
              thickness: 1.1.sp,
            ),
          ),
          Text(
            '   Reviews   ',
            style: TextStyle(
              fontFamily: 'Dosis',
              letterSpacing: 1.sp,
              color: textColor,
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: 15.h,
            width: 130.w,
            child: Divider(
              color: Colors.grey,
              thickness: 1.1.sp,
            ),
          ),
        ],
      ),
      collapsed: SizedBox(
        height: 130.h,
        child: reviewsAll(reviewsStream),
      ),
      expanded: reviewsAll(reviewsStream),
    );
  }
}

Widget reviewsAll(var reviewsStream) {
  return StreamBuilder<QuerySnapshot>(
    stream: reviewsStream,
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
      if (snapshot2.connectionState == ConnectionState.waiting) {
        return gallariesSpinkit;
      }

      if (snapshot2.data!.docs.isEmpty) {
        return Center(
          child: Text(
            'no Reviews yet !',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Dosis',
              fontSize: 16.sp,
              color: Colors.white54,
              letterSpacing: 1.1.sp,
            ),
          ),
        );
      }

      return AnimationLimiter(
        child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: snapshot2.data!.docs.length,
          itemBuilder: (context, index) {
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 300),
              child: SlideAnimation(
                verticalOffset: 50,
                child: FadeInAnimation(
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(25).r,
                      child: CachedNetworkImage(
                        fadeInCurve: Curves.easeInOutQuint,
                        fadeOutCurve: Curves.bounceOut,
                        imageUrl: snapshot2.data!.docs[index]['profileimage'],
                        height: 40.h,
                        width: 40.h,
                        filterQuality: FilterQuality.high,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => SpinKitThreeBounce(
                          color: Colors.black87,
                          size: 20.sp,
                        ),
                        errorWidget: (context, url, error) => Lottie.asset(
                          "assets/json/imageError.json",
                          filterQuality: FilterQuality.high,
                          height: 30.h,
                          width: 100.w,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AutoDirection(
                          text: snapshot2.data!.docs[index]['name'],
                          child: Text(
                            snapshot2.data!.docs[index]['name'],
                            style: TextStyle(
                              fontFamily: 'Dosis',
                              letterSpacing: 1.sp,
                              color: textColor,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "${snapshot2.data!.docs[index]['rate'].toString()}  ",
                              style: TextStyle(
                                fontFamily: 'Dosis',
                                fontSize: 12.sp,
                                letterSpacing: 1.sp,
                                color: textColor,
                              ),
                            ),
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
                              itemSize: 15.sp,
                              initialRating: snapshot2.data!.docs[index]
                                  ['rate'],
                              minRating: 0,
                              allowHalfRating: true,
                            ),
                          ],
                        ),
                      ],
                    ),
                    subtitle: AutoDirection(
                      text: snapshot2.data!.docs[index]['comment'],
                      child: Text(
                        snapshot2.data!.docs[index]['comment'],
                        style: TextStyle(
                          fontFamily: 'Dosis',
                          letterSpacing: 0.4.sp,
                          color: textColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    },
  );
}

class ProDetailsHeader extends StatelessWidget {
  final String label;

  const ProDetailsHeader({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 30.h,
            width: 20.w,
            child: Divider(
              color: Colors.grey,
              thickness: 1.2.sp,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Dosis',
              letterSpacing: 1.sp,
              color: textColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: 30.h,
            width: 20.w,
            child: Divider(
              color: Colors.grey,
              thickness: 1.2.sp,
            ),
          ),
        ],
      ),
    );
  }
}
