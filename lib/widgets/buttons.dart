import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/*
class PrimaryShadowedButton extends StatelessWidget {
  const PrimaryShadowedButton(
      {Key? key,
      required this.child,
      required this.onPressed,
      required this.borderRadius,
      required this.color})
      : super(key: key);

  final Widget child;
  final double borderRadius;
  final Color color;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          gradient: const RadialGradient(
              colors: [Colors.black54, Colors.black],
              center: Alignment.topLeft,
              radius: 2),
          boxShadow: [
            BoxShadow(
                color: color.withOpacity(0.25),
                offset: const Offset(3, 2),
                spreadRadius: 1,
                blurRadius: 8)
          ]),
      child: MaterialButton(
        padding: const EdgeInsets.all(0),
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            child,
          ],
        ),
      ),
    );
  }
}
*/

/*
class BlackButton extends StatelessWidget {
  final String label;
  final Function() onPressed;
  final double width;
  const BlackButton(
      {Key? key,
      required this.label,
      required this.onPressed,
      required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      width: MediaQuery.of(context).size.width * width,
      decoration: BoxDecoration(
        color: buttonsColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: MaterialButton(
        onPressed: onPressed,
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: textColor,
              fontWeight: FontWeight.w500,
              letterSpacing: 2,
              fontFamily: 'Dosis',
            ),
          ),
        ),
      ),
    );
  }
}
*/

class CommonButton extends StatelessWidget {
  final String title;
  final Function() onPressed;
  final double width;
  final double height;
  final double letterSpacing;
  final Color borderColor;
  final double borderRadius;
  final Color textColor;
  final Color fillColor;
  const CommonButton({
    super.key,
    required this.title,
    required this.onPressed,
    required this.width,
    required this.height,
    required this.borderColor,
    required this.textColor,
    required this.fillColor,
    required this.letterSpacing,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height.h,
      width: 400 * width.w,
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(borderRadius).r,
        border: Border.all(color: borderColor),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(borderRadius).r,
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontFamily: 'Dosis',
              color: textColor,
              fontWeight: FontWeight.w600,
              letterSpacing: letterSpacing,
            ),
          ),
        ),
      ),
    );
  }
}
