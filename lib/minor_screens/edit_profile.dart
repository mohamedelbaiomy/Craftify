import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:customers_app_google_play/widgets/buttons.dart';

import '../providers/constants2.dart';
import '../widgets/appbar_widgets.dart';
import '../widgets/snackbar.dart';

class EditProfile extends StatefulWidget {
  final dynamic data;
  const EditProfile({Key? key, required this.data}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  XFile? imageFileProfile;
  dynamic _pickedImageError;
  late String customerName;
  late String profileImage;
  bool processing = false;

  final ImagePicker _picker = ImagePicker();
  pickStoreLogo() async {
    try {
      final pickedStoreLogo = await _picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 300,
        maxWidth: 300,
        imageQuality: 100,
      );
      setState(() {
        imageFileProfile = pickedStoreLogo;
      });
    } catch (e) {
      setState(() {
        _pickedImageError = e;
      });
      if (kDebugMode) {
        print(_pickedImageError);
      }
    }
  }

  Future uploadProfileImage() async {
    if (imageFileProfile != null) {
      try {
        firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref('cust-images/${widget.data['email']}.jpg');

        await ref.putFile(File(imageFileProfile!.path));
        //_uid = FirebaseAuth.instance.currentUser!.uid;

        profileImage = await ref.getDownloadURL();
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    } else {
      profileImage = widget.data['profileimage'];
    }
  }

  editStoreData() async {
    await FirebaseFirestore.instance.runTransaction(
      (transaction) async {
        DocumentReference documentReference = FirebaseFirestore.instance
            .collection('customers')
            .doc(FirebaseAuth.instance.currentUser!.uid);
        transaction.update(
          documentReference,
          {
            'name': customerName,
            'profileimage': profileImage,
          },
        );
      },
    ).whenComplete(() => Navigator.pop(context));
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
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
          title: const AppBarTitle(
            title: 'Edit your profile',
          ),
        ),
        body: Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    radius: 55.sp,
                    backgroundImage: CachedNetworkImageProvider(
                      widget.data['profileimage'],
                    ),
                  ),
                  Column(
                    children: [
                      CommonButton(
                        borderRadius: 8.r,
                        title: "Change",
                        onPressed: () {
                          pickStoreLogo();
                        },
                        width: 0.25,
                        height: 30,
                        borderColor: textColor,
                        textColor: textColor,
                        fillColor: scaffoldColor,
                        letterSpacing: 1.sp,
                      ),
                      SizedBox(height: 15.h),
                      imageFileProfile == null
                          ? const SizedBox()
                          : CommonButton(
                              borderRadius: 8.r,
                              title: "Reset",
                              onPressed: () {
                                setState(() {
                                  imageFileProfile = null;
                                });
                              },
                              width: 0.25,
                              height: 30,
                              borderColor: textColor,
                              textColor: textColor,
                              fillColor: scaffoldColor,
                              letterSpacing: 1.sp,
                            ),
                    ],
                  ),
                  imageFileProfile == null
                      ? const SizedBox()
                      : CircleAvatar(
                          radius: 55.sp,
                          backgroundImage: FileImage(
                            File(imageFileProfile!.path),
                          ),
                        ),
                ],
              ),
              SizedBox(height: 50.h),
              Padding(
                padding: const EdgeInsets.all(8).r,
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'please enter username';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    customerName = value!;
                  },
                  initialValue: widget.data['name'],
                  style: const TextStyle(
                    fontFamily: 'Dosis',
                    color: Colors.white60,
                    letterSpacing: 1,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Username',
                    labelStyle: TextStyle(
                      fontFamily: 'Dosis',
                      color: textColor,
                      letterSpacing: 1.sp,
                    ),
                    hintText: 'enter username',
                    hintStyle: TextStyle(
                      fontFamily: 'Dosis',
                      color: textColor,
                      letterSpacing: 1.sp,
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.w,
                        color: buttonsColor,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: buttonsColor,
                        width: 2.w,
                      ),
                      borderRadius: BorderRadius.circular(20).r,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.w,
                        color: buttonsColor,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.w,
                        color: buttonsColor,
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(flex: 2),
              Container(
                color: scaffoldColor,
                child: Padding(
                  padding:
                      const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CommonButton(
                        borderRadius: 10,
                        title: "Cancel",
                        onPressed: () {
                          Get.back();
                        },
                        width: 0.27,
                        height: 30,
                        borderColor: textColor,
                        textColor: textColor,
                        fillColor: scaffoldColor,
                        letterSpacing: 1,
                      ),
                      StatefulBuilder(builder:
                          (BuildContext context, StateSetter setState) {
                        return CommonButton(
                          borderRadius: 10,
                          title: processing == true ? "please wait" : "Save",
                          onPressed: processing == true
                              ? () {
                                  null;
                                }
                              : () async {
                                  if (formKey.currentState!.validate()) {
                                    formKey.currentState!.save();
                                    setState(() {
                                      processing = true;
                                    });
                                    await uploadProfileImage().whenComplete(
                                      () => editStoreData(),
                                    );
                                  } else {
                                    MyMessageHandler.showSnackBar(_scaffoldKey,
                                        'please fill all fields first');
                                  }
                                },
                          width: processing == true ? 0.33 : 0.26,
                          height: 30,
                          borderColor: textColor,
                          textColor: textColor,
                          fillColor: scaffoldColor,
                          letterSpacing: processing == true ? 1 : 2,
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
/*
        bottomSheet: Container(
          color: scaffoldColor,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CommonButton(
                  borderRadius: 10,
                  title: "Cancel",
                  onPressed: () {
                    Get.back();
                  },
                  width: 0.27,
                  height: 30,
                  borderColor: textColor,
                  textColor: textColor,
                  fillColor: scaffoldColor,
                  letterSpacing: 1,
                ),
                StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  return CommonButton(
                    borderRadius: 10,
                    title: processing == true ? "please wait" : "Save",
                    onPressed: processing == true
                        ? () {
                            null;
                          }
                        : () async {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              setState(() {
                                processing = true;
                              });
                              await uploadProfileImage().whenComplete(
                                () => editStoreData(),
                              );
                            } else {
                              MyMessageHandler.showSnackBar(
                                  _scaffoldKey, 'please fill all fields first');
                            }
                          },
                    width: processing == true ? 0.33 : 0.26,
                    height: 30,
                    borderColor: textColor,
                    textColor: textColor,
                    fillColor: scaffoldColor,
                    letterSpacing: processing == true ? 1 : 2,
                  );
                }),
              ],
            ),
          ),
        ),
*/
      ),
    );
  }
}
