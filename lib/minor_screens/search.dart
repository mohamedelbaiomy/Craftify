import 'package:customers_app_google_play/widgets/appbar_widgets.dart';

import '../widgets/auto_direction.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:customers_app_google_play/minor_screens/product_details.dart';
import 'package:customers_app_google_play/providers/constants2.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final Stream<QuerySnapshot> _searchStream =
      FirebaseFirestore.instance.collection('products').snapshots().take(1);
  String searchInput = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: scaffoldColor,
        leading: AppBarBackButton(
          onPressed: () {
            Get.back();
          },
        ),
        title: AutoDirection(
          text: searchInput,
          child: CupertinoSearchTextField(
            style: const TextStyle(
              fontFamily: 'Dosis',
              letterSpacing: 1,
            ),
            autofocus: true,
            backgroundColor: Colors.white,
            onChanged: (value) {
              setState(() {
                searchInput = value;
              });
            },
          ),
        ),
      ),
      body: searchInput == ''
          ? Container() /*Center(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(25)),
                height: 30,
                width: MediaQuery.of(context).size.width * 0.7,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Icon(Icons.search, color: Colors.grey),
                      ),
                      Text(
                        'Search for any thing ..',
                        style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Dosis',
                        ),
                      )
                    ]),
              ),
            )*/
          : StreamBuilder<QuerySnapshot>(
              stream: _searchStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final result = snapshot.data!.docs.where(
                  (e) => e['proname']
                      .contains(searchInput.capitalizeFirst.toString()),
                );

                return ListView(
                  physics: const BouncingScrollPhysics(
                    decelerationRate: ScrollDecelerationRate.normal,
                  ),
                  children: result.map((e) => SearchModel(e: e)).toList(),
                );
              },
            ),
    );
  }
}

class SearchModel extends StatelessWidget {
  final dynamic e;
  const SearchModel({Key? key, required this.e}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(
          ProductDetailsScreen(proList: e),
          transition: Transition.rightToLeftWithFade,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(7),
          ),
          height: 100,
          width: double.infinity,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: CachedNetworkImage(
                      fit: BoxFit.fill,
                      width: 100,
                      height: 100,
                      filterQuality: FilterQuality.high,
                      imageUrl: e['proimages'][0],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoDirection(
                      text: e['proname'],
                      child: Text(
                        e['proname'],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                          fontFamily: 'Dosis',
                          letterSpacing: 1,
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    AutoDirection(
                      text: e['prodesc'],
                      child: Text(
                        e['prodesc'],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                          fontFamily: 'Dosis',
                          letterSpacing: 1,
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
