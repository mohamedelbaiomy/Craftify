import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';*/
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:customers_app_google_play/providers/constants2.dart';

import '../widgets/alert_dialog.dart';
/*
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ms_customers_app/widgets/buttons.dart';

import '../providers/constants2.dart';
*/

class AskModel extends StatefulWidget {
  final dynamic ask;
  const AskModel({Key? key, required this.ask}) : super(key: key);

  @override
  State<AskModel> createState() => _AskModelState();
}

class _AskModelState extends State<AskModel> {
  late double rate;
  late String comment;
  bool agreeOnPrice = false;
  int currentStep = 0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: Container(
        width: double.infinity,
        height: 170,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 5, left: 5, top: 10),
              child: SizedBox(
                width: 130,
                height: 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: CachedNetworkImage(
                    imageUrl: widget.ask['askPhoto'][0],
                    filterQuality: FilterQuality.high,
                    fit: BoxFit.fill,
                    matchTextDirection: true,
                    placeholder: (context, url) => const SpinKitThreeBounce(
                      color: Colors.black87,
                      size: 20,
                    ),
                    errorWidget: (context, url, error) => Lottie.asset(
                      "assets/json/imageError.json",
                      filterQuality: FilterQuality.high,
                      height: 40,
                      width: 250,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "ask date : ${DateFormat('yyyy-MM-dd').format(widget.ask['askdate'].toDate()).toString()}",
                  style: TextStyle(
                    fontFamily: 'Dosis',
                    letterSpacing: 1,
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                widget.ask['askprice'] == ''
                    ? Text(
                        "price : not determined yet",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontFamily: 'Dosis',
                          letterSpacing: 1,
                          fontSize: 15,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w300,
                        ),
                      )
                    : Text(
                        "price : ${widget.ask['askprice']}",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontFamily: 'Dosis',
                          letterSpacing: 1,
                          fontSize: 15,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                widget.ask['askprice'] == ''
                    ? Container()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "if you agree about that\nprice press done",
                            style: TextStyle(
                                fontFamily: 'Dosis', color: scaffoldColor),
                          ),
                          StatefulBuilder(
                            builder:
                                (BuildContext context, StateSetter setState) {
                              return TextButton(
                                onPressed: () async {
                                  setState(() {
                                    agreeOnPrice = true;
                                  });
                                  await FirebaseFirestore.instance
                                      .runTransaction(
                                    (transaction) async {
                                      DocumentReference documentReference =
                                          FirebaseFirestore.instance
                                              .collection('asks')
                                              .doc(widget.ask['askid']);
                                      transaction.update(
                                        documentReference,
                                        {
                                          'customerconfirm': true,
                                        },
                                      );
                                    },
                                  );
                                },
                                child: Text(
                                  "Done",
                                  style: TextStyle(
                                    fontFamily: 'Dosis',
                                    decoration:
                                        widget.ask['customerconfirm'] == true
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                    color: widget.ask['customerconfirm'] == true
                                        ? scaffoldColor
                                        : Colors.redAccent,
                                    letterSpacing: 1,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
              ],
            ),
            widget.ask['customerconfirm'] == true
                ? Container()
                : IconButton(
                    onPressed: () async {
                      MyAlertDilaog.showMyDialog(
                        context: context,
                        title: 'Confirm',
                        content: 'Are you sure to delete this ask ?',
                        tabNo: () {
                          Get.back();
                        },
                        tabYes: () async {
                          for (var doc in widget.ask['askPhoto']) {
                            firebase_storage.Reference imagesRef =
                                firebase_storage.FirebaseStorage.instance
                                    .ref()
                                    .storage
                                    .refFromURL(doc.toString());

                            await imagesRef.delete();
                          }
                          await FirebaseFirestore.instance.runTransaction(
                            (transaction) async {
                              DocumentReference documentReference =
                                  FirebaseFirestore.instance
                                      .collection('asks')
                                      .doc(widget.ask['askid']);
                              transaction.delete(documentReference);
                            },
                          ).whenComplete(
                            () => Get.back(),
                          );
                        },
                      );
                    },
                    icon: const Icon(
                      Icons.delete_forever_outlined,
                      color: Colors.redAccent,
                      size: 30,
                    ),
                  ),
          ],
        ),
        /* child: ExpansionTile(
          controlAffinity: ListTileControlAffinity.leading,
          initiallyExpanded: false,
          maintainState: true,
          iconColor: Colors.grey,
          collapsedIconColor: scaffoldColor,
          title: Container(
            constraints: const BoxConstraints(maxHeight: 60),
            width: double.infinity,
            child:
          ),
          children: [
            Container(
              height: widget.ask['deliverystatus'] == 'delivered' ? 210 : 200,
              width: double.infinity,
              decoration: BoxDecoration(
                */
        /*  color: widget.order['deliverystatus'] == 'delivered'
                    ? Colors.brown.withOpacity(0.2)
                    : Colors.black.withOpacity(0.356),*/
        /*
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 8, left: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ('Name : ') + (widget.ask['custname']),
                      style: const TextStyle(
                        fontFamily: 'Dosis',
                        letterSpacing: 2,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      ('Phone No. : ') + (widget.ask['phone']),
                      style: const TextStyle(
                        fontFamily: 'Dosis',
                        letterSpacing: 2,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      ('Email Address : ') + (widget.ask['email']),
                      style: const TextStyle(
                        fontFamily: 'Dosis',
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      ('Address : ') + (widget.ask['address']),
                      style: const TextStyle(
                        fontFamily: 'Dosis',
                        letterSpacing: 0.5,
                        fontSize: 15,
                      ),
                    ),
                    Row(
                      children: [
                        const Text(
                          ('Payment Status : '),
                          style: TextStyle(
                            fontFamily: 'Dosis',
                            fontSize: 15,
                            letterSpacing: 2,
                          ),
                        ),
                        Text(
                          (widget.ask['paymentstatus']),
                          style: const TextStyle(
                            fontFamily: 'Dosis',
                            letterSpacing: 2,
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          ('Store Id : '),
                          style: TextStyle(
                            fontFamily: 'Dosis',
                            fontSize: 15,
                            letterSpacing: 2,
                          ),
                        ),
                        Text(
                          (widget.ask['sid']),
                          style: const TextStyle(
                            fontFamily: 'Dosis',
                            letterSpacing: 2,
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
*/
/*
                    Row(
                      children: [
                        Text(
                          ('Delivery status : '),
                          style: GoogleFonts.macondo(fontSize: 15),
                        ),
                        Text(
                          (widget.order['deliverystatus']),
                          style: GoogleFonts.macondo(
                              fontSize: 15, color: Colors.black),
                        ),
                      ],
                    ),
*/
        /*
                    widget.ask['deliverystatus'] == 'delivered' &&
                            widget.ask['orderreview'] == false
                        ? TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => Material(
                                  color: scaffoldColor,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 150),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Text(
                                              'Thanks for shopping with Craftify',
                                              style: TextStyle(
                                                fontFamily: 'Dosis',
                                                fontSize: 20,
                                                letterSpacing: 1,
                                                fontWeight: FontWeight.w400,
                                                color: textColor,
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Icon(
                                              FontAwesomeIcons.faceSmile,
                                              color: textColor,
                                              size: 18,
                                            ),
                                          ],
                                        ),
                                        RatingBar.builder(
                                          itemBuilder: (context, _) {
                                            return const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            );
                                          },
                                          unratedColor: textColor,
                                          onRatingUpdate: (value) {
                                            rate = value;
                                          },
                                          initialRating: 1,
                                          minRating: 1,
                                          updateOnDrag: true,
                                          allowHalfRating: true,
                                        ),
                                        TextFormField(
                                          decoration: InputDecoration(
                                            hintText: 'enter your review',
                                            hintStyle: const TextStyle(
                                              fontFamily: 'Dosis',
                                              letterSpacing: 2,
                                              color: Colors.white70,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(13),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: buttonsColor,
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: buttonsColor,
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                          ),
                                          style: const TextStyle(
                                            fontFamily: 'Dosis',
                                            letterSpacing: 0.5,
                                            color: textColor,
                                          ),
                                          onChanged: (value) {
                                            comment = value.trim();
                                          },
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CommonButton(
                                              title: 'Cancel',
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              width: 0.3,
                                              height: 34,
                                              borderColor: textColor,
                                              textColor: scaffoldColor,
                                              fillColor: textColor,
                                              letterSpacing: 1,
                                            ),
                                            const SizedBox(width: 20),
                                            CommonButton(
                                              title: 'Ok',
                                              onPressed: () async {
                                                CollectionReference collRef =
                                                    FirebaseFirestore.instance
                                                        .collection(
                                                            'products')
                                                        .doc(widget
                                                            .ask['proid'])
                                                        .collection(
                                                            'reviews');
                                                await collRef
                                                    .doc(FirebaseAuth.instance
                                                        .currentUser!.uid)
                                                    .set(
                                                  {
                                                    'name': widget
                                                        .ask['custname'],
                                                    'email':
                                                        widget.ask['email'],
                                                    'rate': rate,
                                                    'cid': widget.ask['cid'],
                                                    'comment': comment,
                                                    'profileimage': widget
                                                        .ask['profileimage'],
                                                  },
                                                ).whenComplete(
                                                  () async {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .runTransaction(
                                                      (transaction) async {
                                                        DocumentReference
                                                            documentReference =
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'orders')
                                                                .doc(
                                                                  widget.ask[
                                                                      'orderid'],
                                                                );
                                                        transaction.update(
                                                          documentReference,
                                                          {
                                                            'orderreview':
                                                                true
                                                          },
                                                        );
                                                      },
                                                    );
                                                  },
                                                );
                                                await Future.delayed(
                                                  const Duration(
                                                    microseconds: 50,
                                                  ),
                                                ).whenComplete(
                                                  () {
                                                    Navigator.pop(context);
                                                  },
                                                );
                                              },
                                              width: 0.3,
                                              height: 34,
                                              borderColor: textColor,
                                              textColor: scaffoldColor,
                                              fillColor: textColor,
                                              letterSpacing: 1,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              'Write Review',
                              style: TextStyle(
                                fontFamily: 'Dosis',
                                letterSpacing: 2,
                                color: Colors.blueAccent,
                              ),
                            ),
                          )
                        : const Text(''),
                    widget.ask['deliverystatus'] == 'delivered' &&
                            widget.ask['orderreview'] == true
                        ? Padding(
                            padding:
                                const EdgeInsets.only(bottom: 15, left: 5),
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.check,
                                  color: Colors.blueAccent,
                                ),
                                Text(
                                  'Review Added',
                                  style: TextStyle(
                                    fontFamily: 'Dosis',
                                    letterSpacing: 2,
                                    color: Colors.blueAccent,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const Text(''),
                  ],
                ),
              ),
            ),
          ],
        ),*/
      ),
    );
  }
}
