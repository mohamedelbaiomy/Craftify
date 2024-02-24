import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:customers_app_google_play/providers/auth_repo.dart';
import 'package:customers_app_google_play/widgets/appbar_widgets.dart';
import 'package:customers_app_google_play/widgets/buttons.dart';
import 'package:customers_app_google_play/widgets/snackbar.dart';

import '../providers/constants2.dart';

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({Key? key}) : super(key: key);

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  final TextEditingController oldPasswordController = TextEditingController();

  final TextEditingController newPasswordController = TextEditingController();
  bool checkOldPasswordValidation = true;
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldKey,
      child: Scaffold(
        backgroundColor: scaffoldColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: scaffoldColor,
          centerTitle: true,
          title: const AppBarTitle(title: 'Change Password'),
          leading: AppBarBackButton(
            onPressed: () {
              Get.back();
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: AnimationLimiter(
              child: Column(
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 200),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    horizontalOffset: 50,
                    child: FadeInAnimation(
                      child: widget,
                    ),
                  ),
                  children: [
                    SizedBox(height: 30.h),
                    Text(
                      'to change password please fill in the\nform below and click save changes',
                      style: TextStyle(
                        fontFamily: 'Dosis',
                        fontSize: 18.sp,
                        letterSpacing: 1.sp,
                        color: textColor,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 25.h),
                    Padding(
                      padding: const EdgeInsets.all(8).r,
                      child: TextFormField(
                        style: TextStyle(
                          color: textColor,
                          fontFamily: 'Dosis',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'enter your old password';
                          }
                          return null;
                        },
                        controller: oldPasswordController,
                        decoration: InputDecoration(
                          labelText: 'Old Password',
                          errorText: checkOldPasswordValidation != true
                              ? 'not valid old password'
                              : null,
                          labelStyle: TextStyle(
                            fontFamily: 'Dosis',
                            color: textColor,
                            letterSpacing: 2,
                          ),
                          hintText: 'enter your current password',
                          hintStyle: TextStyle(
                            fontFamily: 'Dosis',
                            color: textColor,
                            letterSpacing: 2,
                          ),
                          disabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: buttonsColor,
                            ),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: buttonsColor,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: buttonsColor, width: 2),
                            borderRadius: BorderRadius.circular(21),
                          ),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: buttonsColor,
                              style: BorderStyle.solid,
                            ),
                          ),
                          suffixIcon: Icon(
                            Icons.password_outlined,
                            color: textColor,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8).r,
                      child: TextFormField(
                        style: TextStyle(
                          fontFamily: 'Dosis',
                          color: textColor,
                          letterSpacing: 1,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'enter new password';
                          }
                          return null;
                        },
                        controller: newPasswordController,
                        decoration: InputDecoration(
                          labelText: 'New Password',
                          labelStyle: TextStyle(
                            fontFamily: 'Dosis',
                            color: textColor,
                            letterSpacing: 2,
                          ),
                          hintText: 'enter your new password',
                          hintStyle: TextStyle(
                            fontFamily: 'Dosis',
                            color: textColor,
                            letterSpacing: 2,
                          ),
                          disabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: buttonsColor,
                            ),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: buttonsColor,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: buttonsColor, width: 2),
                            borderRadius: BorderRadius.circular(21),
                          ),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: buttonsColor,
                              style: BorderStyle.solid,
                            ),
                          ),
                          suffixIcon: Icon(
                            Icons.password_outlined,
                            color: textColor,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8).r,
                      child: TextFormField(
                        style: TextStyle(
                          fontFamily: 'Dosis',
                          color: textColor,
                          letterSpacing: 1,
                        ),
                        validator: (value) {
                          if (value != newPasswordController.text) {
                            return 'Password not matching';
                          } else if (value!.isEmpty) {
                            return 're-enter your new password';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Repeat password',
                          labelStyle: TextStyle(
                            fontFamily: 'Dosis',
                            color: textColor,
                            letterSpacing: 2,
                          ),
                          hintText: 're-enter your new password',
                          hintStyle: TextStyle(
                            fontFamily: 'Dosis',
                            color: textColor,
                            letterSpacing: 2,
                          ),
                          disabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: buttonsColor,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: buttonsColor, width: 2),
                              borderRadius: BorderRadius.circular(21)),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: buttonsColor,
                            ),
                          ),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: buttonsColor,
                              style: BorderStyle.solid,
                            ),
                          ),
                          suffixIcon: Icon(
                            Icons.password_outlined,
                            color: textColor,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Padding(
                      padding: const EdgeInsets.all(10).r,
                      child: FlutterPwValidator(
                        controller: newPasswordController,
                        minLength: 8,
                        uppercaseCharCount: 1,
                        numericCharCount: 2,
                        specialCharCount: 1,
                        width: 350.w,
                        height: 140.h,
                        onSuccess: () {},
                        onFail: () {},
                      ),
                    ),
                    SizedBox(height: 60.h),
                    Align(
                      alignment: AlignmentDirectional.bottomCenter,
                      child: CommonButton(
                        borderRadius: 9.r,
                        title: 'Save Changes',
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            checkOldPasswordValidation =
                                await AuthRepo.checkOldPassword(
                              FirebaseAuth.instance.currentUser!.email,
                              oldPasswordController.text,
                            );
                            setState(() {});
                            checkOldPasswordValidation == true
                                ? await AuthRepo.updateUserPassword(
                                    newPasswordController.text.trim(),
                                  ).whenComplete(() async {
                                    await FirebaseFirestore.instance
                                        .runTransaction(
                                      (transaction) async {
                                        DocumentReference documentReference =
                                            FirebaseFirestore.instance
                                                .collection('customers')
                                                .doc(
                                                  FirebaseAuth.instance
                                                      .currentUser!.uid,
                                                );
                                        transaction.update(
                                          documentReference,
                                          {
                                            'password': newPasswordController
                                                .text
                                                .trim(),
                                          },
                                        );
                                      },
                                    );
                                    formKey.currentState!.reset();
                                    newPasswordController.clear();
                                    oldPasswordController.clear();
                                    MyMessageHandler.showSnackBar(
                                      scaffoldKey,
                                      'your password has been updated',
                                    );
                                    Future.delayed(
                                      const Duration(
                                        milliseconds: 1500,
                                      ),
                                    ).whenComplete(
                                      () => Get.back(),
                                    );
                                  })
                                : null;
                          } else {}
                        },
                        width: 0.6,
                        height: 34,
                        borderColor: textColor,
                        textColor: textColor,
                        fillColor: scaffoldColor,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
