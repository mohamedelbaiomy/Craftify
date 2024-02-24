// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:ui';

import 'package:animated_button/animated_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:customers_app_google_play/providers/auth_repo.dart';
import 'package:rive/rive.dart';

import '../providers/constants2.dart';
import '../widgets/auth_widgets.dart';
import '../widgets/snackbar.dart';

class CustomerRegister extends StatefulWidget {
  const CustomerRegister({super.key});

  @override
  State<CustomerRegister> createState() => _CustomerRegisterState();
}

class _CustomerRegisterState extends State<CustomerRegister> {
  late String name;
  late String email;
  late String password;
  late String profileImage;
  late String _uid;
  bool processing = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  bool passwordVisible = true;
  final spinkit = const SpinKitFadingCube(
    color: Colors.white70,
    size: 25,
  );
  final ImagePicker _picker = ImagePicker();

  XFile? _imageFile;

  CollectionReference customers =
      FirebaseFirestore.instance.collection('customers');

  void _pickImageFromCamera() async {
    try {
      final pickedImage = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 95,
      );
      setState(() {
        _imageFile = pickedImage;
      });
    } catch (e) {
      setState(() {});
    }
  }

  void _pickImageFromGallery() async {
    try {
      final pickedImage = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 95,
      );
      setState(() {
        _imageFile = pickedImage;
      });
    } catch (e) {
      setState(() {});
    }
  }

  void signUp() async {
    setState(() {
      processing = true;
    });
    if (_formKey.currentState!.validate()) {
      if (_imageFile != null) {
        try {
          await AuthRepo.signUpWithEmailAndPassword(email, password);
          AuthRepo.sendEmailVerification();

          firebase_storage.Reference ref = firebase_storage
              .FirebaseStorage.instance
              .ref('cust-images/$email.jpg');

          await ref.putFile(File(_imageFile!.path));
          _uid = AuthRepo.uid;

          profileImage = await ref.getDownloadURL();

          AuthRepo.updateUserName(name);
          AuthRepo.updateProfileImage(profileImage);

          await customers.doc(_uid).set({
            'cid': _uid,
            'name': name,
            'email': email,
            'password': password,
            'profileimage': profileImage,
            'phone': '',
            'address': '',
            'points': 0,
          });
          _formKey.currentState!.reset();
          setState(() {
            _imageFile = null;
          });
          await Future.delayed(const Duration(microseconds: 100)).whenComplete(
            () => Navigator.pushReplacementNamed(
              context,
              '/customer_login',
            ),
          );
        } on FirebaseAuthException catch (e) {
          setState(() {
            processing = false;
          });
          MyMessageHandler.showSnackBar(_scaffoldKey, e.message.toString());
          if (e.code == 'weak-password') {
            setState(() {
              processing = false;
            });
            MyMessageHandler.showSnackBar(
                _scaffoldKey, 'The password provided is too weak.');
          } else if (e.code == 'email-already-in-use') {
            setState(() {
              processing = false;
            });
            MyMessageHandler.showSnackBar(
                _scaffoldKey, 'The account already exists for that email.');
          }
        }
      } else {
        setState(() {
          processing = false;
        });
        MyMessageHandler.showSnackBar(_scaffoldKey, 'please pick image first');
      }
    } else {
      setState(() {
        processing = false;
      });
      MyMessageHandler.showSnackBar(_scaffoldKey, 'please fill all fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    // const Color(0xff292C31),
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        backgroundColor: scaffoldColor,
        body: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            const RiveAnimation.asset(
              "assets/riveAssets/shapes.riv",
              fit: BoxFit.fill,
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 10),
                child: const SizedBox(),
              ),
            ),
            Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: AnimationConfiguration.toStaggeredList(
                    duration: const Duration(milliseconds: 500),
                    childAnimationBuilder: (widget) => SlideAnimation(
                      horizontalOffset: 50,
                      child: FadeInAnimation(
                        child: widget,
                      ),
                    ),
                    children: [
                      SizedBox(height: 70.h),
                      Center(
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            fontFamily: 'Limelight',
                            color: textColor,
                            fontSize: 40.sp,
                            letterSpacing: 2.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 30.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          DottedBorder(
                            color: textColor,
                            strokeWidth: 1,
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(15),
                            dashPattern: const [8, 8, 8, 8, 8, 8, 8],
                            child: Container(
                              color: Colors.transparent,
                              width: 170.w,
                              height: 135.h,
                              child: _imageFile == null
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              _pickImageFromGallery();
                                            },
                                            icon: Icon(
                                              FontAwesomeIcons.upload,
                                              color: textColor,
                                              size: 30.sp,
                                            ),
                                          ),
                                          SizedBox(height: 10.h),
                                          Text(
                                            "Upload your Photo",
                                            style: TextStyle(
                                              fontFamily: 'Dosis',
                                              fontSize: 14.sp,
                                              letterSpacing: 1.sp,
                                              color: textColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Image.file(
                                      File(_imageFile!.path),
                                      fit: BoxFit.fill,
                                      filterQuality: FilterQuality.high,
                                    ),
                            ),
                          ),
                          Column(
                            children: AnimationConfiguration.toStaggeredList(
                              duration: const Duration(milliseconds: 600),
                              childAnimationBuilder: (widget) => SlideAnimation(
                                horizontalOffset: 60,
                                child: FadeInAnimation(
                                  child: widget,
                                ),
                              ),
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: buttonsColor,
                                    borderRadius: BorderRadius.only(
                                      topLeft: const Radius.circular(15).r,
                                      topRight: const Radius.circular(15).r,
                                    ),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      _pickImageFromCamera();
                                    },
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                Container(
                                  decoration: BoxDecoration(
                                    color: buttonsColor,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: const Radius.circular(10).r,
                                      bottomRight: const Radius.circular(10).r,
                                    ),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.photo,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      _pickImageFromGallery();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 28.h),
                      Padding(
                        padding: const EdgeInsets.all(10).r,
                        child: TextFormField(
                          style: TextStyle(
                            fontFamily: 'Dosis',
                            color: textColor,
                            letterSpacing: 1.sp,
                          ),

                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter your username';
                            }
                            if (value.length > 17) {
                              return 'username must be less than 17 character';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            name = value;
                          },
                          maxLength: 17,
                          //controller: _namecontroller,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            hintText: 'Enter your Username',
                            hintStyle: TextStyle(
                              fontFamily: 'Dosis',
                              color: textColor,
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
                                width: 1.w,
                              ),
                              borderRadius: BorderRadius.circular(10).r,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: buttonsColor,
                                width: 3.w,
                              ),
                              borderRadius: BorderRadius.circular(10).r,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10).r,
                        child: TextFormField(
                          style: TextStyle(
                            fontFamily: 'Dosis',
                            color: textColor,
                            letterSpacing: 1.sp,
                          ),

                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter your email ';
                            } else if (value.isValidEmail() == false) {
                              return 'invalid email';
                            } else if (value.isValidEmail() == true) {
                              return null;
                            }
                            return null;
                          },
                          onChanged: (value) {
                            email = value;
                          },
                          //  controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email Address',
                            hintText: 'Enter your email',
                            hintStyle: TextStyle(
                              fontFamily: 'Dosis',
                              color: textColor,
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
                                width: 1.w,
                              ),
                              borderRadius: BorderRadius.circular(10).r,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: buttonsColor,
                                width: 3.w,
                              ),
                              borderRadius: BorderRadius.circular(10).r,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10).r,
                        child: TextFormField(
                          style: TextStyle(
                            fontFamily: 'Dosis',
                            color: textColor,
                            letterSpacing: 2.sp,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter your password';
                            }
                            if (value.contains("-")) {
                              return "can't include -";
                            }
                            if (value.length < 5) {
                              return 'weak password';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            password = value;
                          },
                          //controller: _passwordController,
                          obscureText: passwordVisible,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  passwordVisible = !passwordVisible;
                                });
                              },
                              icon: Icon(
                                passwordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: textColor,
                              ),
                            ),
                            labelText: 'Password',
                            hintText: 'Enter your password',
                            hintStyle: TextStyle(
                              fontFamily: 'Dosis',
                              color: textColor,
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
                                width: 1.w,
                              ),
                              borderRadius: BorderRadius.circular(10).r,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: buttonsColor,
                                width: 3.w,
                              ),
                              borderRadius: BorderRadius.circular(10).r,
                            ),
                          ),
                        ),
                      ),
                      HaveAccount(
                        haveAccount: 'already have account? ',
                        actionLabel: 'Log In',
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            '/customer_login',
                          );
                        },
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20).r,
                          child: AnimatedButton(
                            duration: 200,
                            shadowDegree: ShadowDegree.dark,
                            height: 40.h,
                            width: 140.w,
                            color: textColor,
                            onPressed: () {
                              processing == true ? null : signUp();
                            },
                            child: processing == true
                                ? SpinKitFadingCube(
                                    color: scaffoldColor,
                                    size: 18.sp,
                                  )
                                : Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      fontFamily: 'Dosis',
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                      color: scaffoldColor,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
