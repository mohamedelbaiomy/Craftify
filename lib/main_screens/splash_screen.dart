import 'dart:async';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glitcheffect/glitcheffect.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/customer_login.dart';
import '../providers/cart_provider.dart';
import '../providers/constants2.dart';
import '../providers/id_provider.dart';
import '../providers/wish_provider.dart';
import 'customer_home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<String> documentId;
  late String docId = context.read<IdProvider>().getData;

  @override
  void initState() {
    super.initState();
    context.read<Cart>().loadCartItemsProvider();
    context.read<Wish>().loadWishItemsProvider();
    context.read<IdProvider>().getDocId();
    //docId = context.read<IdProvider>().getData;
    documentId = _prefs.then((SharedPreferences prefs) {
      return prefs.getString('customerid') ?? '';
    }).then((String value) {
      setState(() {
        docId = value;
      });
      return docId;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: AnimatedSplashScreen(
        backgroundColor: Colors.transparent,
        splashIconSize: 300.sp,
        splashTransition: SplashTransition.fadeTransition,
        splash: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GlitchEffect(
                repeat: false,
                duration: const Duration(milliseconds: 1850),
                child: Text(
                  "Craftify",
                  style: TextStyle(
                    fontFamily: 'Explora',
                    fontSize: 70.sp,
                    color: textColor,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 2.5.sp,
                  ),
                ),
              ),
              SizedBox(height: 50.h),
              Align(
                alignment: Alignment.bottomCenter,
                child: CupertinoActivityIndicator(
                  color: textColor,
                  animating: true,
                  radius: 10.r,
                ),
              ),
            ],
          ),
        ),
        nextScreen:
            docId != '' ? const CustomerHomeScreen() : const CustomerLogin(),
      ),
    );
  }
}

/*
class _SecondScreenState extends State<SecondScreen> {
  @override
  void initState() {
    Timer(const Duration(milliseconds: 2500), () {
      Navigator.of(context).pushReplacement(SlideTransitionAnimation(

      ));
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 2000),
            curve: Curves.fastLinearToSlowEaseIn,
            width: _a ? width : 0,
            height: height,
            color: Colors.black,
          ),
          Center(
            child: Text(
              'Mohamed Elbaiomy',
              style: GoogleFonts.macondo(
                fontWeight: FontWeight.w600,
                fontSize: 37,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
*/
