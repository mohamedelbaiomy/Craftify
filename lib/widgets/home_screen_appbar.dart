/*
import 'package:badges/badges.dart' as badges;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../customer_screens/wishlist.dart';
import '../providers/constants2.dart';
import '../providers/id_provider.dart';
import '../providers/wish_provider.dart';

class CustomAppbar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;

  CustomAppbar({
    Key? key,
  })  : preferredSize = const Size.fromHeight(50.0),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    CollectionReference customers =
        FirebaseFirestore.instance.collection('customers');
    late Future<DocumentSnapshot> future =
        customers.doc(context.read<IdProvider>().getData).get();
    return AppBar(
      elevation: 0,
      backgroundColor: scaffoldColor,
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Good Morning",
            style: TextStyle(
              fontFamily: 'Dosis',
              color: textColor,
              fontSize: 13,
              letterSpacing: 1,
            ),
          ),
          FutureBuilder<DocumentSnapshot>(
              future: future,
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData && !snapshot.data!.exists ||
                    snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Hi There",
                      style: TextStyle(
                        fontFamily: 'Dosis',
                        color: textColor,
                        fontSize: 15,
                        letterSpacing: 1,
                      ),
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;
                  return Text(
                    "Hi ${data['name']}",
                    style: TextStyle(
                      fontFamily: 'Dosis',
                      color: textColor,
                      fontSize: 15,
                      letterSpacing: 1,
                    ),
                  );
                }
                return Text(
                  "Hi there",
                  style: TextStyle(
                    fontFamily: 'Dosis',
                    color: textColor,
                    fontSize: 15,
                    letterSpacing: 1,
                  ),
                );
              }),
        ],
      ),
      leading: FutureBuilder<DocumentSnapshot>(
          future: future,
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasData && !snapshot.data!.exists ||
                snapshot.hasError) {
              return const Padding(
                padding: EdgeInsets.only(top: 1, bottom: 4, right: 0, left: 10),
                child: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                    'images/inapp/guest.jpg',
                  ),
                ),
              );
            }

            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              return data['profileimage'] == ''
                  ? const Padding(
                      padding: EdgeInsets.only(
                          top: 1, bottom: 4, right: 0, left: 10),
                      child: CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                          'images/inapp/guest.jpg',
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(
                          top: 1, bottom: 4, right: 0, left: 10),
                      child: CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                          data['profileimage'],
                        ),
                      ),
                    );
            }
            return const Padding(
              padding: EdgeInsets.only(top: 1, bottom: 4, right: 0, left: 10),
              child: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(
                  'images/inapp/guest.jpg',
                ),
              ),
            );
          }),
      actions: [
        IconButton(
          onPressed: () {
            Get.to(const WishlistScreen(),
                transition: Transition.rightToLeftWithFade);
          },
          icon: badges.Badge(
            showBadge: context.read<Wish>().getWishItems.isEmpty ? false : true,
            badgeContent: Text(
              context.watch<Wish>().getWishItems.length.toString(),
              style: TextStyle(
                fontFamily: 'Dosis',
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            child: context.read<Wish>().getWishItems.isEmpty
                ? Icon(
                    Icons.heart_broken_outlined,
                    color: textColor,
                  )
                : Icon(
                    FontAwesomeIcons.solidHeart,
                    color: textColor,
                  ),
          ),
        ),
      ],
    );
  }
}
*/
