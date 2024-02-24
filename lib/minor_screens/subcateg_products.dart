import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lottie/lottie.dart';
import 'package:customers_app_google_play/models/product_model.dart';
import 'package:customers_app_google_play/providers/constants2.dart';
import 'package:customers_app_google_play/widgets/appbar_widgets.dart';
import 'package:customers_app_google_play/widgets/buttons.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class SubCategProducts extends StatefulWidget {
  final String maincategName;
  final String subcategName;
  final bool fromOnboarding;
  const SubCategProducts(
      {Key? key,
      required this.subcategName,
      required this.maincategName,
      this.fromOnboarding = false})
      : super(key: key);

  @override
  State<SubCategProducts> createState() => _SubCategProductsState();
}

class _SubCategProductsState extends State<SubCategProducts> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  double _minPrice = 0;
  double _maxPrice = 999;
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> prodcutsStream = FirebaseFirestore.instance
        .collection('products')
        .where('maincateg', isEqualTo: widget.maincategName)
        .where('subcateg', isEqualTo: widget.subcategName)
        .where('price',
            isLessThanOrEqualTo: _maxPrice, isGreaterThanOrEqualTo: _minPrice)
        .snapshots();
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      backgroundColor: scaffoldColor,
/*
      endDrawer: Drawer(
        width: 250,
        backgroundColor: Colors.black87,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Min Price: ',
                          style: TextStyle(
                            fontFamily: 'Dosis',
                            color: textColor,
                            letterSpacing: 2,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(
                          height: 60,
                          width: 160,
                          child: TextFormField(
                            controller: _controller2,
                            onChanged: (value) {
                              setState(() {
                                _minPrice = double.tryParse(value) ?? 0;
                              });
                            },
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            smartQuotesType: SmartQuotesType.enabled,
                            autovalidateMode: AutovalidateMode.always,
                            style: TextStyle(
                              fontFamily: 'Dosis',
                              letterSpacing: 1,
                              color: textColor,
                            ),
                            maxLength: 3,
                            cursorColor: textColor,
                            validator: (value) {
                              if (value!.isNotEmpty &&
                                  double.parse(value) > _maxPrice) {
                                return 'invalid';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'min price',
                              hintStyle: const TextStyle(
                                fontFamily: 'Dosis',
                                color: Colors.white30,
                                fontSize: 13,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: buttonsColor,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: buttonsColor, width: 2),
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Max Price: ',
                          style: TextStyle(
                            fontFamily: 'Dosis',
                            color: textColor,
                            letterSpacing: 2,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(
                          height: 60,
                          width: 160,
                          child: TextFormField(
                            controller: _controller1,
                            onChanged: (value) {
                              setState(() {
                                _maxPrice = double.tryParse(value) ?? 999;
                              });
                            },
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            smartQuotesType: SmartQuotesType.enabled,
                            autovalidateMode: AutovalidateMode.always,
                            style: TextStyle(
                              fontFamily: 'Dosis',
                              letterSpacing: 1,
                              color: textColor,
                            ),
                            maxLength: 3,
                            cursorColor: textColor,
                            validator: (value) {
                              if (value!.isNotEmpty &&
                                  double.parse(value) > _maxPrice) {
                                return 'invalid';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'max price',
                              hintStyle: const TextStyle(
                                fontFamily: 'Dosis',
                                color: Colors.white30,
                                fontSize: 13,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: buttonsColor,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: buttonsColor, width: 2),
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: _minPrice,
                      min: 0,
                      activeColor: textColor,
                      secondaryActiveColor: scaffoldColor,
                      inactiveColor: Colors.white24,
                      max: 999,
                      divisions: 100,
                      label: 'Min Price',
                      onChanged: (value) {
                        setState(() {
                          _minPrice = value;
                          _controller2.text = value.toInt().toString();
                        });
                      },
                    ),
                    Slider(
                      value: _maxPrice,
                      activeColor: textColor,
                      secondaryActiveColor: scaffoldColor,
                      inactiveColor: Colors.white24,
                      min: 0,
                      max: 999,
                      divisions: 100,
                      label: 'Max Price',
                      onChanged: (value) {
                        setState(() {
                          _maxPrice = value;
                          _controller1.text = value.toInt().toString();
                        });
                      },
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.25,
                    ),
                  ],
                );
              }),
              CommonButton(
                borderRadius: 10,
                title: 'Apply',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {});
                  }
                },
                width: 0.4,
                height: 30,
                borderColor: buttonsColor,
                textColor: scaffoldColor,
                fillColor: textColor,
                letterSpacing: 1,
              )
            ],
          ),
        ),
      ),
*/
      appBar: AppBar(
        elevation: 0,
        backgroundColor: scaffoldColor,
        leading: widget.fromOnboarding == true
            ? IconButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/customer_home');
                },
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: textColor,
                ),
              )
            : AppBarBackButton(
                onPressed: () {
                  Get.back();
                },
              ),
        title: AppBarTitle(title: widget.subcategName),
        actions: [
          /* GestureDetector(
            child: const Icon(
              Icons.filter_list_sharp,
              color: textColor,
            ),
          ),*/
          Builder(
            builder: (context) => IconButton(
              onPressed: () {
                // Scaffold.of(context).openEndDrawer();
                showModalBottomSheet(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18).r,
                      topRight: const Radius.circular(18).r,
                    ),
                  ),
                  backgroundColor: Colors.grey.shade300,
                  elevation: 2,
                  useSafeArea: true,
                  context: context,
                  builder: (context) => SizedBox(
                    height: 250.h,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          StatefulBuilder(
                            builder:
                                (BuildContext context, StateSetter setState) {
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Min Price: ',
                                        style: TextStyle(
                                          fontFamily: 'Dosis',
                                          color: scaffoldColor,
                                          letterSpacing: 1.sp,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 50.h,
                                        width: 150.w,
                                        child: TextFormField(
                                          controller: _controller2,
                                          onChanged: (value) {
                                            setState(() {
                                              _minPrice =
                                                  double.tryParse(value) ?? 0;
                                            });
                                          },
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          smartQuotesType:
                                              SmartQuotesType.enabled,
                                          autovalidateMode:
                                              AutovalidateMode.always,
                                          style: TextStyle(
                                            fontFamily: 'Dosis',
                                            letterSpacing: 1.sp,
                                            color: Colors.black87,
                                          ),
                                          maxLength: 3,
                                          cursorColor: Colors.black87,
                                          validator: (value) {
                                            if (value!.isNotEmpty &&
                                                double.parse(value) >
                                                    _maxPrice) {
                                              return 'invalid';
                                            }
                                            return null;
                                          },
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            hintText: 'min price',
                                            hintStyle: TextStyle(
                                              fontFamily: 'Dosis',
                                              color: Colors.black54,
                                              fontSize: 12.sp,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10).r,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.black87,
                                                width: 0.5.w,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10).r,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.black87,
                                                width: 1.w,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10).r,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5.h),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Max Price: ',
                                        style: TextStyle(
                                          fontFamily: 'Dosis',
                                          color: scaffoldColor,
                                          letterSpacing: 1.sp,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 50.h,
                                        width: 150.w,
                                        child: TextFormField(
                                          controller: _controller1,
                                          onChanged: (value) {
                                            setState(() {
                                              _maxPrice =
                                                  double.tryParse(value) ?? 999;
                                            });
                                          },
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          smartQuotesType:
                                              SmartQuotesType.enabled,
                                          autovalidateMode:
                                              AutovalidateMode.always,
                                          style: TextStyle(
                                            fontFamily: 'Dosis',
                                            letterSpacing: 1.sp,
                                            color: Colors.black87,
                                          ),
                                          maxLength: 3,
                                          cursorColor: Colors.black87,
                                          validator: (value) {
                                            if (value!.isNotEmpty &&
                                                double.parse(value) >
                                                    _maxPrice) {
                                              return 'invalid';
                                            }
                                            return null;
                                          },
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            hintText: 'max price',
                                            hintStyle: TextStyle(
                                              fontFamily: 'Dosis',
                                              color: Colors.black45,
                                              fontSize: 12.sp,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10).r,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.black87,
                                                width: 0.5.w,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10).r,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.black87,
                                                width: 1.w,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10).r,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Slider(
                                    value: _minPrice,
                                    min: 0,
                                    activeColor: scaffoldColor,
                                    secondaryActiveColor: textColor,
                                    inactiveColor: Colors.black26,
                                    max: 999,
                                    divisions: 100,
                                    label: 'Min Price',
                                    onChanged: (value) {
                                      setState(() {
                                        _minPrice = value;
                                        _controller2.text =
                                            value.toInt().toString();
                                      });
                                    },
                                  ),
                                  Slider(
                                    value: _maxPrice,
                                    activeColor: scaffoldColor,
                                    secondaryActiveColor: textColor,
                                    inactiveColor: Colors.black26,
                                    min: 0,
                                    max: 999,
                                    divisions: 100,
                                    label: 'Max Price',
                                    onChanged: (value) {
                                      setState(() {
                                        _maxPrice = value;
                                        _controller1.text =
                                            value.toInt().toString();
                                      });
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                          CommonButton(
                            borderRadius: 7,
                            title: 'Apply',
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                setState(() {});
                              }
                            },
                            width: 0.4,
                            height: 30,
                            borderColor: buttonsColor,
                            textColor: textColor,
                            fillColor: scaffoldColor,
                            letterSpacing: 1,
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
              icon: const Icon(
                PixelArtIcons.menu,
                color: Colors.white70,
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: prodcutsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text(
              'Something went wrong',
              style: TextStyle(
                fontFamily: 'Dosis',
                letterSpacing: 1.sp,
                color: textColor,
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return gallariesSpinkit;
          }

          if (snapshot.data!.docs.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  "assets/json/13525-empty.json",
                  repeat: false,
                  filterQuality: FilterQuality.high,
                  height: 300,
                  width: double.infinity,
                ),
                Text(
                  'This category \n\n has no items yet !',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Dosis',
                    fontSize: 15.sp,
                    color: Colors.white54,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3.sp,
                  ),
                ),
              ],
            );
          }

          return AnimationLimiter(
            child: StaggeredGridView.countBuilder(
              /*  physics: const BouncingScrollPhysics(
                decelerationRate: ScrollDecelerationRate.normal,
              ),*/
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              crossAxisCount: 2,
              itemBuilder: (context, index) {
                return AnimationConfiguration.staggeredGrid(
                  position: index,
                  duration: const Duration(milliseconds: 300),
                  columnCount: snapshot.data!.docs.length,
                  child: SlideAnimation(
                    verticalOffset: 50,
                    child: FadeInAnimation(
                      child: ProductModel(
                        products: snapshot.data!.docs[index],
                      ),
                    ),
                  ),
                );
              },
              staggeredTileBuilder: (context) => const StaggeredTile.fit(1),
            ),
          );
        },
      ),
    );
  }
}
