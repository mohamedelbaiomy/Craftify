import 'dart:ui';

import 'package:animated_button/animated_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:customers_app_google_play/minor_screens/forgot_password.dart';
import 'package:customers_app_google_play/providers/auth_repo.dart';
import 'package:customers_app_google_play/providers/id_provider.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/constants2.dart';
import '../widgets/auth_widgets.dart';
import '../widgets/snackbar.dart';

class CustomerLogin extends StatefulWidget {
  const CustomerLogin({super.key});

  @override
  State<CustomerLogin> createState() => _CustomerLoginState();
}

class _CustomerLoginState extends State<CustomerLogin> {
  //final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  CollectionReference customers =
      FirebaseFirestore.instance.collection('customers');

  CollectionReference anonymous =
      FirebaseFirestore.instance.collection('anonymous');

  Future<bool> checkIfDocExists(String docId) async {
    try {
      var doc = await customers.doc(docId).get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  setUserId(User user) {
    context.read<IdProvider>().setCustomerId(user);
  }

  bool docExists = false;

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    return await FirebaseAuth.instance
        .signInWithCredential(credential)
        .whenComplete(() async {
      User user = FirebaseAuth.instance.currentUser!;
      setUserId(user);
      /*final SharedPreferences pref = await _prefs;
      pref.setString('customerid', user.uid);*/
      docExists = await checkIfDocExists(user.uid);
      docExists == false
          ? await customers.doc(user.uid).set({
              'name': user.displayName,
              'email': user.email,
              'profileimage': user.photoURL,
              'phone': user.phoneNumber,
              'address': '',
              'points': 0,
              'cid': user.uid,
            }).then(
              (value) => navigate(),
            )
          : navigate();
    });
  }

  late String email;
  late String password;
  bool processing = false;
  bool sendEmailVerification = false;
  final spinkit = SpinKitFadingCube(
    color: scaffoldColor,
    size: 25,
  );
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  bool passwordVisible = true;

  void navigate() {
    Get.offNamed('/customer_home');
  }

  void logIn() async {
    setState(() {
      processing = true;
    });
    Future.delayed(const Duration(seconds: 1), () async {
      if (_formKey.currentState!.validate()) {
        try {
          await AuthRepo.signInWithEmailAndPassword(email, password);
          await AuthRepo.reloadUserData();
          if (await AuthRepo.checkEmailVerification()) {
            _formKey.currentState!.reset();
            User user = FirebaseAuth.instance.currentUser!;
            setUserId(user);
            /*User user = FirebaseAuth.instance.currentUser!;
            final SharedPreferences pref = await _prefs;
            pref.setString('customerid', user.uid);*/

            navigate();
          } else {
            setState(() {
              processing = false;
              sendEmailVerification = true;
            });
            MyMessageHandler.showSnackBar(
                _scaffoldKey, 'please check your inbox');
          }
        } on FirebaseAuthException catch (e) {
          setState(() {
            processing = false;
          });
          MyMessageHandler.showSnackBar(_scaffoldKey, e.message.toString());
        }
      } else {
        setState(() {
          processing = false;
        });
        MyMessageHandler.showSnackBar(_scaffoldKey, 'please fill all fields');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      SizedBox(height: 85.h),
                      Center(
                        child: Text(
                          "Log In",
                          style: TextStyle(
                            fontFamily: 'Limelight',
                            letterSpacing: 2.sp,
                            color: textColor,
                            fontSize: 38.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      sendEmailVerification == true
                          ? Center(
                              child: Container(
                                height: 32.h,
                                width: 190.w,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(7).r,
                                ),
                                child: MaterialButton(
                                  onPressed: () async {
                                    MyMessageHandler.showSnackBar(
                                      _scaffoldKey,
                                      'Sending email verification . . .',
                                    );
                                    try {
                                      await FirebaseAuth.instance.currentUser!
                                          .sendEmailVerification();
                                    } catch (e) {
                                      if (kDebugMode) {
                                        print(e);
                                      }
                                    }
                                    Future.delayed(const Duration(seconds: 3))
                                        .whenComplete(() {
                                      setState(() {
                                        sendEmailVerification == false;
                                      });
                                      MyMessageHandler.showSnackBar(
                                        _scaffoldKey,
                                        'Check your email now',
                                      );
                                    });
                                  },
                                  child: Center(
                                    child: Text(
                                      'Resend Email Verification',
                                      style: TextStyle(
                                        fontFamily: 'Dosis',
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1.sp,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(height: 32.h),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 20,
                        ).r,
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
                          cursorColor: textColor,
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
                                borderRadius: BorderRadius.circular(10).r),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: buttonsColor, width: 1.w),
                                borderRadius: BorderRadius.circular(10).r),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: buttonsColor, width: 3.w),
                                borderRadius: BorderRadius.circular(10).r),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 20,
                        ).r,
                        child: TextFormField(
                          cursorColor: textColor,
                          style: TextStyle(
                            fontFamily: 'Dosis',
                            color: textColor,
                            letterSpacing: 1.sp,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter your password';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            password = value;
                          },
                          //   controller: _passwordController,
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
                              letterSpacing: 1,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10).r,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: buttonsColor, width: 1.w),
                              borderRadius: BorderRadius.circular(10).r,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: buttonsColor, width: 3.w),
                              borderRadius: BorderRadius.circular(10).r,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(7).r,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                Get.to(
                                  const ForgotPassword(),
                                  transition: Transition.leftToRight,
                                );
                              },
                              child: Text(
                                'Forget Password ?',
                                style: TextStyle(
                                  fontFamily: 'Dosis',
                                  color: textColor,
                                  fontSize: 17.sp,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                            HaveAccount(
                              haveAccount: 'Don\'t Have Account? ',
                              actionLabel: 'Sign Up',
                              onPressed: () {
                                Get.offNamed(
                                  '/customer_signup',
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20).r,
                          child: AnimatedButton(
                            duration: 10,
                            enabled: true,
                            shadowDegree: ShadowDegree.dark,
                            height: 40.h,
                            width: 150.w,
                            color: textColor,
                            onPressed: () {
                              processing == true ? null : logIn();
                            },
                            child: processing == true
                                ? SpinKitFadingCube(
                                    color: scaffoldColor,
                                    size: 18.sp,
                                  )
                                : Text(
                                    'Sign In',
                                    style: TextStyle(
                                      fontFamily: 'Dosis',
                                      letterSpacing: 1.sp,
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                      color: scaffoldColor,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30.h),
                      /*  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Log in as guest here",
                            style: TextStyle(
                              fontFamily: 'Dosis',
                              letterSpacing: 2.sp,
                              color: Colors.white70,
                              fontSize: 14.sp,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              await FirebaseAuth.instance
                                  .signInAnonymously()
                                  .whenComplete(() async {
                                _uid = FirebaseAuth.instance.currentUser!.uid;
                                await anonymous.doc(_uid).set({
                                  'name': '',
                                  'email': '',
                                  'points': 0,
                                  'profileimage': '',
                                  'phone': '',
                                  'address': '',
                                  'cid': _uid,
                                });
                              });
                              await Future.delayed(
                                const Duration(microseconds: 100),
                              ).whenComplete(
                                () => Navigator.pushReplacementNamed(
                                    context, '/customer_home'),
                              );
                            },
                            icon: const Icon(
                              Icons.arrow_forward,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),*/
                      SizedBox(height: 40.h),
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 30,
                          left: 30,
                        ).r,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () {
                                var whatsapp = "+201009429689";
                                final Uri url = Uri.parse(
                                    "whatsapp://send?phone=$whatsapp&text=ازيك ي محمد");
                                Future<void> _launchUrl() async {
                                  if (!await launchUrl(
                                    url,
                                    mode: LaunchMode.externalApplication,
                                  )) {
                                    throw 'Could not launch $url';
                                  }
                                }

                                _launchUrl();
                              },
                              child: Icon(
                                FontAwesomeIcons.whatsapp,
                                color: Colors.green,
                                size: 18.sp,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                final Uri url = Uri.parse(
                                    "https://www.facebook.com/Original262003/");
                                Future<void> _launchUrl() async {
                                  if (!await launchUrl(
                                    url,
                                    mode: LaunchMode
                                        .externalNonBrowserApplication,
                                  )) {
                                    throw 'Could not launch $url';
                                  }
                                }

                                _launchUrl();
                              },
                              child: Icon(
                                FontAwesomeIcons.facebook,
                                color: Colors.blue,
                                size: 18.sp,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                final Uri url = Uri.parse(
                                    "https://www.instagram.com/mohamed_elbaiomy262003/");
                                Future<void> _launchUrl() async {
                                  if (!await launchUrl(
                                    url,
                                    mode: LaunchMode
                                        .externalNonBrowserApplication,
                                  )) {
                                    throw 'Could not launch $url';
                                  }
                                }

                                _launchUrl();
                              },
                              child: Icon(
                                FontAwesomeIcons.instagram,
                                color: Colors.deepOrange,
                                size: 18.sp,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                final Uri url = Uri.parse(
                                    "https://www.linkedin.com/in/mohamed-elbaiomy-7b12b6191/");
                                Future<void> _launchUrl() async {
                                  if (!await launchUrl(
                                    url,
                                    mode: LaunchMode
                                        .externalNonBrowserApplication,
                                  )) {
                                    throw 'Could not launch $url';
                                  }
                                }

                                _launchUrl();
                              },
                              child: Icon(
                                FontAwesomeIcons.linkedinIn,
                                color: Colors.blue[300]!,
                                size: 18.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 28.h),
                      Center(
                        child: Text(
                          "Craftify",
                          style: TextStyle(
                            fontFamily: 'CinzelDecorative',
                            color: textColor,
                            letterSpacing: 3.sp,
                            fontSize: 16.sp,
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

  /* Widget googleLogInButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(50, 50, 50, 20).r,
      child: Material(
        elevation: 3,
        color: Colors.grey.shade300,
        child: MaterialButton(
          onPressed: () {
            signInWithGoogle();
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(
                FontAwesomeIcons.google,
                color: Colors.red,
              ),
              Text(
                'Sign In With Google',
                style: TextStyle(
                  fontFamily: 'Dosis',
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget divider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FractionallySizedBox(
            widthFactor: 80,
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ),
          Text(
            'Or',
            style: TextStyle(
              fontFamily: 'Dosis',
            ),
          ),
          FractionallySizedBox(
            widthFactor: 80,
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }*/
}
