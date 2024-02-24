import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:customers_app_google_play/customer_screens/address_book.dart';
import 'package:customers_app_google_play/main_screens/customer_home.dart';
import 'package:flutter/material.dart';
import 'package:customers_app_google_play/providers/id_provider.dart';
import 'package:customers_app_google_play/widgets/appbar_widgets.dart';
import 'package:customers_app_google_play/widgets/buttons.dart';
import 'package:customers_app_google_play/widgets/snackbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:uuid/uuid.dart';

import '../providers/constants2.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({Key? key}) : super(key: key);

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  late String firstName;
  late String lastName;
  late String phone;
  late String fullAddress;
  late String notes;
  String countryValue = 'Choose Country';
  String stateValue = 'Choose State';
  String cityValue = 'Choose City';

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldKey,
      child: Scaffold(
        backgroundColor: scaffoldColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: scaffoldColor,
          leading: AppBarBackButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddressBook(),
                  ),
                  (route) => false);
            },
          ),
          title: const AppBarTitle(title: 'Add Address'),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    right: 20,
                    left: 20,
                    top: 5,
                  ).r,
                  child: SelectState(
                    style: TextStyle(
                      fontFamily: 'Dosis',
                      color: textColor,
                      letterSpacing: 1.sp,
                    ),
                    dropdownColor: Colors.black,
                    onCountryChanged: (value) {
                      setState(() {
                        countryValue = value;
                      });
                    },
                    onStateChanged: (value) {
                      setState(() {
                        stateValue = value;
                      });
                    },
                    onCityChanged: (value) {
                      setState(() {
                        cityValue = value;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 20, 28, 30).r,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 145.w,
                            child: TextFormField(
                              cursorColor: textColor,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'please enter your first name';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                firstName = value!.trim();
                              },
                              style: TextStyle(
                                fontFamily: 'Dosis',
                                color: textColor,
                                letterSpacing: 1.sp,
                              ),
                              decoration: InputDecoration(
                                labelText: 'First Name',
                                labelStyle: TextStyle(
                                  fontFamily: 'Dosis',
                                  color: textColor,
                                  fontSize: 12.sp,
                                  letterSpacing: 1.sp,
                                ),
                                hintText: 'enter your first name',
                                hintStyle: TextStyle(
                                  fontFamily: 'Dosis',
                                  color: buttonsColor,
                                  fontSize: 12.sp,
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 0.4.w,
                                    color: textColor,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1.5.w,
                                    color: textColor,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 0.4.w,
                                    color: textColor,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1.w,
                                    color: textColor,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 145.w,
                            child: TextFormField(
                              cursorColor: textColor,
                              style: TextStyle(
                                fontFamily: 'Dosis',
                                color: textColor,
                                letterSpacing: 1.sp,
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'please enter your last name';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                lastName = value!.trim();
                              },
                              decoration: InputDecoration(
                                labelText: 'last Name',
                                labelStyle: TextStyle(
                                  fontFamily: 'Dosis',
                                  color: textColor,
                                  fontSize: 12.sp,
                                  letterSpacing: 1.sp,
                                ),
                                hintText: 'enter your last name',
                                hintStyle: TextStyle(
                                  fontFamily: 'Dosis',
                                  color: buttonsColor,
                                  fontSize: 12.sp,
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 0.4.w,
                                    color: textColor,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1.5.w,
                                    color: textColor,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 0.4.w,
                                    color: textColor,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1.w,
                                    color: textColor,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 17.h),
                      SizedBox(
                        child: TextFormField(
                          keyboardType: TextInputType.phone,
                          cursorColor: textColor,
                          style: TextStyle(
                            fontFamily: 'Dosis',
                            color: textColor,
                            letterSpacing: 2.sp,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter your phone number';
                            }
                            if (value.length <= 10) {
                              return 'Phone Number is wrong';
                            }
                            if (value.length > 11) {
                              return 'Phone Number is wrong';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            phone = value!.trim();
                          },
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            labelStyle: TextStyle(
                              fontFamily: 'Dosis',
                              color: textColor,
                              fontSize: 13.sp,
                              letterSpacing: 1.sp,
                            ),
                            hintText: 'example : 01009429689',
                            hintStyle: TextStyle(
                              fontFamily: 'Dosis',
                              color: buttonsColor,
                              fontSize: 13.sp,
                              letterSpacing: 2.sp,
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 0.4.w,
                                color: textColor,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1.5.w,
                                color: textColor,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 0.4.w,
                                color: textColor,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1.w,
                                color: textColor,
                                style: BorderStyle.solid,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 17.h),
                      SizedBox(
                        child: TextFormField(
                          cursorColor: textColor,
                          maxLines: 1,
                          style: TextStyle(
                            fontFamily: 'Dosis',
                            color: textColor,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter your full address';
                            }
                            if (value.length <= 5) {
                              return 'address is wrong';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            fullAddress = value!;
                          },
                          decoration: InputDecoration(
                            labelText: 'Full Address',
                            labelStyle: TextStyle(
                              fontFamily: 'Dosis',
                              color: textColor,
                              fontSize: 13.sp,
                              letterSpacing: 1.sp,
                            ),
                            hintText: 'address like in your formal id',
                            hintStyle: TextStyle(
                              fontFamily: 'Dosis',
                              color: buttonsColor,
                              fontSize: 13.sp,
                              letterSpacing: 1.sp,
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 0.4.w,
                                color: textColor,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1.5.w,
                                color: textColor,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 0.4.w,
                                color: textColor,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1.w,
                                color: textColor,
                                style: BorderStyle.solid,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 17.h),
                      SizedBox(
                        child: TextFormField(
                          maxLines: 4,
                          style: TextStyle(
                            fontFamily: 'Dosis',
                            color: textColor,
                            letterSpacing: 1.sp,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter some notes to help us find you quickly';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            notes = value!;
                          },
                          cursorColor: textColor,
                          decoration: InputDecoration(
                            labelText: 'Notes',
                            labelStyle: TextStyle(
                              fontFamily: 'Dosis',
                              color: textColor,
                              fontSize: 13.sp,
                              letterSpacing: 1.sp,
                            ),
                            hintText: 'any additional information',
                            hintStyle: TextStyle(
                              fontFamily: 'Dosis',
                              color: buttonsColor,
                              letterSpacing: 2.5.sp,
                              fontSize: 13.sp,
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 0.4.w,
                                color: textColor,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1.5.w,
                                color: textColor,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 0.4.w,
                                color: textColor,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1.w,
                                color: textColor,
                                style: BorderStyle.solid,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomSheet: Container(
          color: scaffoldColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 55).r,
            child: CommonButton(
              borderRadius: 9,
              title: 'Add New Address',
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  if (countryValue != 'Choose Country' &&
                      stateValue != 'Choose State' &&
                      cityValue != 'Choose City') {
                    showProgress();
                    formKey.currentState!.save();
                    CollectionReference addressRef = FirebaseFirestore.instance
                        .collection('customers')
                        .doc(context.read<IdProvider>().getData)
                        .collection('address');
                    var addressId = const Uuid().v4();
                    await addressRef.doc(addressId).set(
                      {
                        'addressid': addressId,
                        'firstname': firstName,
                        'lastname': lastName,
                        'phone': phone,
                        'fulladdress': fullAddress,
                        'country': countryValue,
                        'state': stateValue,
                        'city': cityValue,
                        'notes': notes,
                        'default': true,
                      },
                    ).whenComplete(() {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CustomerHomeScreen(),
                          ),
                          (route) => false);
                      Get.to(const AddressBook());
                    });
                  } else {
                    MyMessageHandler.showSnackBar(
                      scaffoldKey,
                      'please set your location',
                    );
                  }
                } else {
                  MyMessageHandler.showSnackBar(
                    scaffoldKey,
                    'please fill all fields',
                  );
                }
              },
              width: 1.w,
              height: 30.h,
              borderColor: textColor,
              textColor: scaffoldColor,
              fillColor: textColor,
              letterSpacing: 3.sp,
            ),
          ),
        ),
      ),
    );
  }

  void showProgress() {
    ProgressDialog progress = ProgressDialog(context: context);
    progress.show(
      max: 100,
      backgroundColor: Colors.white,
      msg: 'please wait',
      progressType: ProgressType.valuable,
      progressBgColor: Colors.black,
      borderRadius: 30.r,
    );
  }
}
