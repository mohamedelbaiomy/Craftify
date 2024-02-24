import 'package:flutter/material.dart';

import '../utilities/categ_list.dart';
import '../widgets/categ_widgets.dart';

class HandmadeCategory extends StatelessWidget {
  const HandmadeCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width * 0.75,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CategHeaderLabel(
                      headerLabel: 'Handmade',
                    ),
                    const SizedBox(height: 60),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.66,
                      child: GridView.count(
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 45,
                        crossAxisSpacing: 5,
                        crossAxisCount: 3,
                        children: List.generate(
                          handmade.length - 1,
                          (index) {
                            return SubcategModel(
                              mainCategName: 'handmade',
                              subCategName: handmade[index + 1],
                              assetName:
                                  'assets/images/handmade/handmade$index.jpg',
                              subcategLabel: handmade[index + 1],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          /*  const Positioned(
            bottom: 0,
            right: 0,
            child: SliderBar(
              maincategName: 'handmade',
            ),
          ),*/
        ],
      ),
    );
  }
}
