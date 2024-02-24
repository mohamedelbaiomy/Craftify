import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../models/wish_model.dart';
import '../providers/constants2.dart';
import '../providers/wish_provider.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/appbar_widgets.dart';
import 'package:flutter_svg/svg.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

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
        title: const AppBarTitle(title: 'Wishlist'),
        actions: [
          context.watch<Wish>().getWishItems.isEmpty
              ? const SizedBox()
              : IconButton(
                  onPressed: () {
                    MyAlertDilaog.showMyDialog(
                      context: context,
                      title: 'Clear Wishlist',
                      content: 'Are you sure to clear Wishlist ?',
                      tabNo: () {
                        Navigator.pop(context);
                      },
                      tabYes: () {
                        context.read<Wish>().clearWishlist();
                        Navigator.pop(context);
                      },
                    );
                  },
                  icon: Icon(
                    Icons.delete_forever,
                    color: textColor,
                  ),
                ),
        ],
      ),
      body: context.watch<Wish>().getWishItems.isNotEmpty
          ? const WishItems()
          : const EmptyWishlist(),
    );
  }
}

class EmptyWishlist extends StatelessWidget {
  const EmptyWishlist({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Your Wishlist Is Empty !',
            style: TextStyle(
              fontFamily: 'Dosis',
              fontSize: 24,
              color: textColor,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class WishItems extends StatelessWidget {
  const WishItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 55,
        left: 15,
        right: 10,
      ).r,
      child: Consumer<Wish>(
        builder: (context, wish, child) {
          return ListView.builder(
            itemCount: wish.count,
            /* physics: const BouncingScrollPhysics(
              decelerationRate: ScrollDecelerationRate.normal,
              parent: AlwaysScrollableScrollPhysics(),
            ),*/
            itemBuilder: (context, index) {
              final product = wish.getWishItems[index];
              return Dismissible(
                key: UniqueKey(),
                background: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20).r,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE6E6),
                    borderRadius: BorderRadius.circular(17).r,
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset("assets/images/Trash.svg"),
                      const Spacer(),
                    ],
                  ),
                ),
                direction: DismissDirection.startToEnd,
                movementDuration: const Duration(seconds: 1),
                onDismissed: (direction) {
                  context.read<Wish>().removeItem(product);
                },
                child: WishlistModel(
                  product: product,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
