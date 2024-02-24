import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hexcolor/hexcolor.dart';

Color scaffoldColor = HexColor("#0b0b0c");
Color textColor = HexColor("#e6e6e6");
const Color buttonsColor = Colors.white30;
const ScrollPhysics gallariesScroll = NeverScrollableScrollPhysics();

var gallariesSpinkit = Center(
  child: SpinKitRipple(
    color: textColor,
    size: 60,
  ),
);

var productsSpinkit = const Center(
  child: SpinKitRipple(
    color: Colors.black,
    size: 60,
  ),
);
