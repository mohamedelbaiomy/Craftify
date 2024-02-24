import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:customers_app_google_play/providers/constants2.dart';

import '../minor_screens/subcateg_products.dart';

/*class SliderBar extends StatelessWidget {
  final String maincategName;
  const SliderBar({Key? key, required this.maincategName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var style = GoogleFonts.macondo(
        color: textColor,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 10);
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      width: MediaQuery.of(context).size.width * 0.04,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.brown.withOpacity(0.2),
              borderRadius: BorderRadius.circular(50)),
          child: RotatedBox(
            quarterTurns: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                maincategName == 'beauty'
                    ? const Text('')
                    : Text('<<', style: style),
                Text(maincategName.toUpperCase(), style: style),
                maincategName == 'men'
                    ? const Text('')
                    : Text('>>', style: style),
              ],
            ),
          ),
        ),
      ),
    );
  }
}*/

class SubcategModel extends StatelessWidget {
  final String mainCategName;
  final String subCategName;
  final String assetName;
  final String subcategLabel;
  const SubcategModel(
      {Key? key,
      required this.assetName,
      required this.mainCategName,
      required this.subCategName,
      required this.subcategLabel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
          SubCategProducts(
            maincategName: mainCategName,
            subcategName: subCategName,
          ),
          transition: Transition.fadeIn,
        );
      },
      child: Column(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: textColor,
              ),
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                fit: BoxFit.fill,
                filterQuality: FilterQuality.high,
                image: AssetImage(
                  assetName,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              subcategLabel,
              style: TextStyle(
                  fontFamily: 'Dosis', fontSize: 12, color: textColor),
            ),
          )
        ],
      ),
    );
  }
}

class CategHeaderLabel extends StatelessWidget {
  final String headerLabel;
  const CategHeaderLabel({Key? key, required this.headerLabel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Center(
        child: Text(
          headerLabel,
          style: TextStyle(
            fontSize: 40,
            fontFamily: 'Explora',
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
