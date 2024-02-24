import 'package:flutter/material.dart';
import 'package:customers_app_google_play/categories/handmade_categ.dart';
import '../providers/constants2.dart';
import '../widgets/appbar_widgets.dart';

List<ItemsData> items = [
  ItemsData(label: 'handmade'),
  /* ItemsData(label: 'men'),
  ItemsData(label: 'women'),
  ItemsData(label: 'shoes'),
  ItemsData(label: 'bags'),
  ItemsData(label: 'electronics'),
  ItemsData(label: 'accessories'),
  ItemsData(label: 'home & garden'),
  ItemsData(label: 'kids'),
  ItemsData(label: 'beauty'),*/
];

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with AutomaticKeepAliveClientMixin<CategoryScreen> {
  final PageController _pageController = PageController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    for (var element in items) {
      element.isSelected = false;
    }
    setState(() {
      items[0].isSelected = true;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: scaffoldColor,
        automaticallyImplyLeading: false,
        title: const AppBarTitle(title: 'Categories'),
      ),
      body: Stack(
        children: [
          Positioned(bottom: 0, left: 0, child: sideNavigator(size)),
          Positioned(bottom: 0, right: 0, child: categView(size)),
        ],
      ),
    );
  }

  Widget sideNavigator(Size size) {
    return SizedBox(
      height: size.height * 0.8,
      width: size.width * 0.23,
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 600),
                curve: Curves.fastOutSlowIn,
              );
            },
            //items[index].isSelected == true ?
            child: Container(
              padding: const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: items[index].isSelected == true
                        ? Colors.yellow
                        : Colors.black,
                    width: 2,
                  ),
                ),
              ),
              height: 50,
              width: 90,
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  items[index].label,
                  style: TextStyle(
                    fontFamily: 'Dosis',
                    color: items[index].isSelected == true
                        ? textColor
                        : Colors.white60,
                    fontSize: 13,
                    fontWeight: items[index].isSelected == true
                        ? FontWeight.w700
                        : null,
                    letterSpacing: 2,
                    wordSpacing: 1,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget categView(Size size) {
    return Container(
      height: size.height * 0.8,
      width: size.width * 0.76,
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: Colors.grey.shade800, width: 3),
        ),
      ),
      child: PageView(
        controller: _pageController,
        onPageChanged: (value) {
          for (var element in items) {
            element.isSelected = false;
          }
          setState(() {
            items[value].isSelected = true;
          });
        },
        scrollDirection: Axis.horizontal,
        children: const [
          HandmadeCategory(),
          /*  MenCategory(),
          WomenCategory(),
          ShoesCategory(),
          BagsCategory(),
          ElectronicsCategory(),
          AccessoriesCategory(),
          HomeGardenCategory(),
          KidsCategory(),
          BeautyCategory(),*/
        ],
      ),
    );
  }
}

class ItemsData {
  String label;
  bool isSelected;

  ItemsData({required this.label, this.isSelected = false});
}
