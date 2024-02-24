import 'package:flutter/material.dart';

class Transition2 extends PageRouteBuilder {
  final Widget page;
  Transition2(this.page)
      : super(
          pageBuilder: (context, animation, anotherAnimation) => page,
          transitionDuration: const Duration(milliseconds: 1000),
          reverseTransitionDuration: const Duration(milliseconds: 200),
          transitionsBuilder: (context, animation, anotherAnimation, child) {
            animation = CurvedAnimation(
                parent: animation,
                curve: Curves.fastLinearToSlowEaseIn,
                reverseCurve: Curves.fastOutSlowIn);
            return ScaleTransition(
              filterQuality: FilterQuality.high,
              alignment: Alignment.center,
              scale: animation,
              child: page,
            );
          },
        );
}
