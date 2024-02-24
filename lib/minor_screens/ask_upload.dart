import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import '../providers/constants2.dart';
import '../providers/id_provider.dart';
import '../widgets/appbar_widgets.dart';
import '../widgets/buttons.dart';
import '../widgets/snackbar.dart';

class AskScreen extends StatefulWidget {
  final String suppId;
  const AskScreen({Key? key, required this.suppId}) : super(key: key);

  @override
  State<AskScreen> createState() => _AskScreenState();
}

class _AskScreenState extends State<AskScreen> {
  CollectionReference customers =
      FirebaseFirestore.instance.collection('customers');
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool processing = false;
  late String customerName;
  late String phone;
  late String notes;
  late String askId;
  List<XFile>? _imageFile = [];
  final List<String> _imageUrl = [];
  final ImagePicker _picker = ImagePicker();

  void showProgress() {
    ProgressDialog progress = ProgressDialog(context: context);
    progress.show(
      max: 100,
      msg: 'please wait ..',
      progressBgColor: Colors.black,
      borderRadius: 5,
    );
  }

  @override
  Widget build(BuildContext context) {
    String docId = context.read<IdProvider>().getData;

    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Form(
        key: _formKey,
        child: Scaffold(
          backgroundColor: scaffoldColor,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: scaffoldColor,
            leading: AppBarBackButton(
              onPressed: () {
                Get.back();
              },
            ),
            title: const AppBarTitle(title: 'Ask'),
            actions: [
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10).r,
                        ),
                        backgroundColor: Colors.grey.shade200,
                        child: SizedBox(
                          height: 340.h,
                          width: 280.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 15.h),
                              Lottie.asset(
                                "assets/json/59489-activity.json",
                                filterQuality: FilterQuality.high,
                                height: 100.h,
                                repeat: false,
                                fit: BoxFit.cover,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10).r,
                                child: Column(
                                  children:
                                      AnimationConfiguration.toStaggeredList(
                                    duration: const Duration(milliseconds: 700),
                                    childAnimationBuilder: (widget) =>
                                        SlideAnimation(
                                      horizontalOffset: 50,
                                      child: FadeInAnimation(
                                        child: widget,
                                      ),
                                    ),
                                    children: [
                                      Text(
                                        "if you want to make a custom product",
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          letterSpacing: 1.sp,
                                          fontFamily: 'Dosis',
                                        ),
                                      ),
                                      Text(
                                        "related to this supplier kindly upload",
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          letterSpacing: 1.sp,
                                          fontFamily: 'Dosis',
                                        ),
                                      ),
                                      Text(
                                        "photos to your product that you want",
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          letterSpacing: 1.sp,
                                          fontFamily: 'Dosis',
                                        ),
                                      ),
                                      Text(
                                        "to make and some information about",
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          letterSpacing: 1.sp,
                                          fontFamily: 'Dosis',
                                        ),
                                      ),
                                      Text(
                                        "you and follow ask page constantly",
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          letterSpacing: 1.sp,
                                          fontFamily: 'Dosis',
                                        ),
                                      ),
/*
                                      Padding(
                                        padding: const EdgeInsets.all(10).r,
                                        child: Text(
                                          "if you want to make a custom product"
                                          " related to this supplier kindly upload"
                                          " photos to your product that you want"
                                          " to make and some information about you"
                                          " and follow ask page constantly",
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                            fontSize: 17.sp,
                                            letterSpacing: 1.sp,
                                            fontFamily: 'Dosis',
                                          ),
                                        ),
                                      ),
*/
                                    ],
                                  ),
                                ),
                              ),
                              MaterialButton(
                                onPressed: () {
                                  Get.back();
                                },
                                color: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20).r,
                                ),
                                child: Text(
                                  "Close",
                                  style: TextStyle(
                                    fontFamily: 'Dosis',
                                    color: Colors.white,
                                    letterSpacing: 1.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                icon: Icon(
                  PixelArtIcons.notification,
                  size: 20.sp,
                  color: Colors.white60,
                ),
              ),
            ],
          ),
          body: StreamBuilder(
            stream: customers
                .doc(
                  docId.isNotEmpty
                      ? docId
                      : FirebaseAuth.instance.currentUser!.uid,
                )
                .get()
                .asStream(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Something went wrong",
                        style: TextStyle(
                          fontFamily: 'Dosis',
                          letterSpacing: 1.sp,
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 22.sp,
                        ),
                      ),
                      SizedBox(height: 15.h),
                      Text(
                        "You have to Log In",
                        style: TextStyle(
                          fontFamily: 'Dosis',
                          letterSpacing: 1.sp,
                          color: Colors.white60,
                          fontWeight: FontWeight.bold,
                          fontSize: 19.sp,
                        ),
                      ),
                      SizedBox(height: 15.h),
                      Container(
                        height: 32.h,
                        width: 100.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10).r,
                          border: Border.all(color: textColor),
                        ),
                        child: MaterialButton(
                          onPressed: () {
                            Get.offNamed('/customer_login');
                          },
                          child: Text(
                            'Log In',
                            style: TextStyle(
                                fontFamily: 'Dosis', color: textColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (snapshot.hasData && !snapshot.data!.exists) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "User does not exist",
                        style: TextStyle(
                          fontFamily: 'Dosis',
                          color: textColor,
                          fontSize: 20.sp,
                          letterSpacing: 0.5.sp,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "talk to the founder",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Dosis',
                              color: textColor,
                              fontSize: 15.sp,
                              letterSpacing: 1.sp,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              var whatsapp = "+201009429689";
                              final Uri url = Uri.parse(
                                "whatsapp://send?phone=$whatsapp&text=Document Existence in the app and i need the solution",
                              );
                              Future<void> laaunchUrl() async {
                                if (!await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                )) {
                                  throw 'Could not launch $url';
                                }
                              }

                              laaunchUrl();
                            },
                            icon: const Icon(
                              FontAwesomeIcons.whatsapp,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: SpinKitFadingCircle(
                    color: textColor,
                    size: 60,
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;
                return AnimationLimiter(
                  child: ListView(
                    children: AnimationConfiguration.toStaggeredList(
                      duration: const Duration(milliseconds: 700),
                      childAnimationBuilder: (widget) => SlideAnimation(
                        horizontalOffset: 50,
                        curve: Curves.slowMiddle,
                        child: FadeInAnimation(
                          child: widget,
                        ),
                      ),
                      children: [
                        StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter setState) {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 30,
                                    right: 30,
                                    top: 10,
                                    bottom: 10,
                                  ).r,
                                  child: DottedBorder(
                                    color: textColor,
                                    borderType: BorderType.RRect,
                                    radius: const Radius.circular(5).r,
                                    dashPattern: const [8, 8, 8, 8],
                                    child: Container(
                                      color: Colors.transparent,
                                      width: MediaQuery.of(context).size.width,
                                      height: 190,
                                      child: _imageFile!.isEmpty
                                          ? Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    void _pickImage() async {
                                                      try {
                                                        final pickedImage =
                                                            await _picker
                                                                .pickMultiImage(
                                                          imageQuality: 100,
                                                        );
                                                        setState(() {
                                                          _imageFile =
                                                              pickedImage;
                                                        });
                                                      } catch (e) {
                                                        setState(() {});
                                                      }
                                                    }

                                                    _pickImage();
                                                  },
                                                  icon: Icon(
                                                    FontAwesomeIcons.upload,
                                                    color: textColor,
                                                    size: 30,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  "Upload your Photo",
                                                  style: TextStyle(
                                                    fontFamily: 'Dosis',
                                                    fontSize: 15,
                                                    letterSpacing: 1,
                                                    color: textColor,
                                                  ),
                                                ),
                                              ],
                                            )
                                          : ListView.builder(
                                              itemCount: _imageFile!.length,
                                              itemBuilder: (context, index) {
                                                return Image.file(
                                                  File(_imageFile![index].path),
                                                  filterQuality:
                                                      FilterQuality.high,
                                                );
                                              },
                                            ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 15,
                                  ).r,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: buttonsColor,
                                          borderRadius: BorderRadius.only(
                                            bottomRight:
                                                const Radius.circular(10).r,
                                            topRight:
                                                const Radius.circular(10).r,
                                            topLeft:
                                                const Radius.circular(10).r,
                                            bottomLeft:
                                                const Radius.circular(10).r,
                                          ),
                                        ),
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.photo,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            void _pickImage() async {
                                              try {
                                                final pickedImage =
                                                    await _picker
                                                        .pickMultiImage(
                                                  imageQuality: 100,
                                                );
                                                setState(() {
                                                  _imageFile = pickedImage;
                                                });
                                              } catch (e) {
                                                setState(() {});
                                              }
                                            }

                                            _pickImage();
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 4.w),
                                      _imageFile!.isNotEmpty
                                          ? Container(
                                              decoration: BoxDecoration(
                                                color: buttonsColor,
                                                borderRadius: BorderRadius.only(
                                                  bottomRight:
                                                      const Radius.circular(10)
                                                          .r,
                                                  topRight:
                                                      const Radius.circular(10)
                                                          .r,
                                                  topLeft:
                                                      const Radius.circular(10)
                                                          .r,
                                                  bottomLeft:
                                                      const Radius.circular(10)
                                                          .r,
                                                ),
                                              ),
                                              child: IconButton(
                                                icon: const Icon(
                                                  Icons.clear,
                                                  color: Colors.redAccent,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    _imageFile = [];
                                                  });
                                                },
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 25,
                            right: 25,
                            bottom: 50,
                          ).r,
                          child: TextFormField(
                            keyboardType: TextInputType.name,
                            style: TextStyle(
                              fontFamily: 'Dosis',
                              color: textColor,
                              letterSpacing: 1.sp,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'enter your name';
                              } else {
                                return null;
                              }
                            },
                            onChanged: (value) {
                              customerName = value;
                            },
                            //  controller: _emailController,
                            cursorColor: textColor,
                            decoration: InputDecoration(
                              labelText: 'Username',
                              hintText: 'enter your name',
                              hintStyle: TextStyle(
                                fontFamily: 'Dosis',
                                color: buttonsColor,
                                letterSpacing: 1.sp,
                              ),
                              labelStyle: TextStyle(
                                fontFamily: 'Dosis',
                                color: textColor,
                                letterSpacing: 1.sp,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10).r,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: buttonsColor,
                                  width: 0.5.w,
                                ),
                                borderRadius: BorderRadius.circular(10).r,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: buttonsColor,
                                  width: 1.w,
                                ),
                                borderRadius: BorderRadius.circular(10).r,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 25,
                            left: 25,
                            bottom: 50,
                          ).r,
                          child: TextFormField(
                            cursorColor: textColor,
                            style: TextStyle(
                              fontFamily: 'Dosis',
                              color: textColor,
                              letterSpacing: 2.sp,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'please enter your phone number';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              phone = value!.trim();
                            },
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              labelStyle: TextStyle(
                                fontFamily: 'Dosis',
                                color: textColor,
                                letterSpacing: 1.sp,
                              ),
                              hintText: 'example : 01009429689',
                              hintStyle: TextStyle(
                                fontFamily: 'Dosis',
                                color: buttonsColor,
                                letterSpacing: 1.sp,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10).r,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: buttonsColor,
                                  width: 0.5.w,
                                ),
                                borderRadius: BorderRadius.circular(10).r,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: buttonsColor,
                                  width: 1.w,
                                ),
                                borderRadius: BorderRadius.circular(10).r,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 25,
                            right: 25,
                            bottom: 50,
                          ).r,
                          child: TextFormField(
                            maxLines: 3,
                            style: TextStyle(
                              fontFamily: 'Dosis',
                              color: textColor,
                              letterSpacing: 1,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'please enter some notes to help us find you quickly';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              notes = value!;
                            },
                            cursorColor: textColor,
                            decoration: InputDecoration(
                              labelText: 'Notes',
                              labelStyle: TextStyle(
                                fontFamily: 'Dosis',
                                color: textColor,
                                letterSpacing: 1.sp,
                              ),
                              hintText: 'any additional information',
                              hintStyle: TextStyle(
                                fontFamily: 'Dosis',
                                color: buttonsColor,
                                letterSpacing: 1.sp,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10).r,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: buttonsColor,
                                  width: 0.5.w,
                                ),
                                borderRadius: BorderRadius.circular(10).r,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: buttonsColor,
                                  width: 1.w,
                                ),
                                borderRadius: BorderRadius.circular(10).r,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional.bottomCenter,
                          child: Container(
                            color: scaffoldColor,
                            child: StatefulBuilder(
                              builder:
                                  (BuildContext context, StateSetter setState) {
                                return CommonButton(
                                  borderRadius: 8.sp,
                                  title: processing == false
                                      ? 'Confirm'
                                      : 'Loading .....',
                                  onPressed: processing == true
                                      ? () {}
                                      : () {
                                          Future<void> uploadImages() async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              _formKey.currentState!.save();
                                              if (_imageFile!.isNotEmpty) {
                                                setState(() {
                                                  processing = true;
                                                });
                                                try {
                                                  for (var image
                                                      in _imageFile!) {
                                                    firebase_storage.Reference
                                                        ref = firebase_storage
                                                            .FirebaseStorage
                                                            .instance
                                                            .ref(
                                                      'ask-images/${path.basename(image.path)}',
                                                    );
                                                    await ref
                                                        .putFile(
                                                      File(image.path),
                                                    )
                                                        .whenComplete(() async {
                                                      await ref
                                                          .getDownloadURL()
                                                          .then((value) {
                                                        _imageUrl.add(value);
                                                      });
                                                    });
                                                  }
                                                } catch (e) {
                                                  if (kDebugMode) {
                                                    print(e);
                                                  }
                                                }
                                              } else {
                                                MyMessageHandler.showSnackBar(
                                                  _scaffoldKey,
                                                  'please pick images first',
                                                );
                                              }
                                            } else {
                                              MyMessageHandler.showSnackBar(
                                                _scaffoldKey,
                                                'please fill all fields',
                                              );
                                            }
                                          }

                                          void uploadData() async {
                                            if (_imageUrl.isNotEmpty) {
                                              CollectionReference askRef =
                                                  FirebaseFirestore.instance
                                                      .collection('asks');
                                              askId = const Uuid().v4();
                                              await askRef.doc(askId).set({
                                                'cid': data['cid'],
                                                'askPhoto': _imageUrl,
                                                'customerName': customerName,
                                                'phone': phone,
                                                'notes': notes,
                                                'sid': widget.suppId,
                                                'askid': askId,
                                                'askprice': '',
                                                'askdate': DateTime.now(),
                                                'supplierconfirm': false,
                                                'customerconfirm': false,
                                              }).whenComplete(() {
                                                setState(() {
                                                  processing = false;
                                                  _imageFile = [];
                                                });
                                                //_formKey.currentState!.reset();
                                              });
                                            }
                                          }

                                          void uploadAsk() async {
                                            await uploadImages()
                                                .whenComplete(
                                                  () => uploadData(),
                                                )
                                                .whenComplete(
                                                  () => _formKey.currentState!
                                                              .validate() ==
                                                          true
                                                      ? Get.back()
                                                      : null,
                                                );
                                          }

                                          uploadAsk();
                                        },
                                  width: 0.4,
                                  height: 34,
                                  borderColor: textColor,
                                  textColor: scaffoldColor,
                                  fillColor: textColor,
                                  letterSpacing: 3.5,
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
