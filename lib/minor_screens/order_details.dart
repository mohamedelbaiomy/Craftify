import 'package:get/get.dart';
import '../widgets/auto_direction.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:customers_app_google_play/providers/constants2.dart';
import 'package:customers_app_google_play/widgets/appbar_widgets.dart';
import 'package:qr_flutter/qr_flutter.dart';

class OrderDetails extends StatefulWidget {
  final dynamic order;
  const OrderDetails({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  late double rate;
  late String comment;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        leading: AppBarBackButton(
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: scaffoldColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8).r,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: 120.h,
                  width: 150.w,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7).r,
                    child: CachedNetworkImage(
                      filterQuality: FilterQuality.high,
                      fit: BoxFit.contain,
                      imageUrl: widget.order['orderimage'],
                    ),
                  ),
                ),
                SizedBox(width: 15.w),
                QrImageView(
                  data: widget.order['orderid'],
                  version: QrVersions.auto,
                  backgroundColor: Colors.white,
                  gapless: true,
                  size: 110.r,
                  errorStateBuilder: (cxt, err) {
                    return Center(
                      child: Text(
                        'error',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: textColor),
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                AutoDirection(
                  text: widget.order['ordername'],
                  child: Text(
                    "${widget.order['ordername']}",
                    style: TextStyle(
                      fontFamily: "EnglishSC",
                      letterSpacing: 1.sp,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w200,
                      color: textColor,
                    ),
                  ),
                ),
                SizedBox(width: 20.w),
                Text(
                  ('x  ') + (widget.order['orderqty'].toString()),
                  style: TextStyle(
                    fontFamily: 'Dosis',
                    letterSpacing: 1,
                    color: textColor,
                  ),
                ),
              ],
            ),
            /*Text(
              "Order ID: ${widget.order['orderid']}",
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 13.sp,
                letterSpacing: 1,
                fontFamily: 'Dosis',
              ),
            ),*/
            SizedBox(height: 15.h),
            Text(
              "Order date : ${DateFormat.yMMMd().add_jm().format(widget.order['orderdate'].toDate()).toString()}",
              style: TextStyle(
                color: textColor,
                fontSize: 13.sp,
                letterSpacing: 2.sp,
                fontWeight: FontWeight.w500,
                fontFamily: 'Dosis',
              ),
            ),
            SizedBox(height: 15.h),
            Text(
              "Delivery date : ${DateFormat.yMMMd().add_jm().format(widget.order['deliverydate'].toDate()).toString()}",
              style: TextStyle(
                color: textColor,
                fontSize: 13.sp,
                letterSpacing: 2.sp,
                fontWeight: FontWeight.w500,
                fontFamily: 'Dosis',
              ),
            ),
            SizedBox(height: 30.h),
            Text(
              ('Name : ') + (widget.order['custname']),
              style: TextStyle(
                fontFamily: 'Dosis',
                letterSpacing: 2,
                fontSize: 15.sp,
                color: textColor,
              ),
            ),
            SizedBox(height: 15.h),
            Row(
              children: [
                Text(
                  'Phone No : ',
                  style: TextStyle(
                    fontFamily: 'Dosis',
                    letterSpacing: 2,
                    fontSize: 14.sp,
                    color: textColor,
                  ),
                ),
                Text(
                  widget.order['phone'],
                  style: TextStyle(
                    fontFamily: 'Dosis',
                    letterSpacing: 5,
                    fontSize: 14.sp,
                    color: textColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.h),
            Text(
              ('Email Address : ') + (widget.order['email']),
              style: TextStyle(
                fontFamily: 'Dosis',
                fontSize: 15.sp,
                color: textColor,
              ),
            ),
            SizedBox(height: 15.h),
            Text(
              ('Address : ') + (widget.order['address']),
              style: TextStyle(
                fontFamily: 'Dosis',
                letterSpacing: 0.5,
                fontSize: 15.sp,
                color: textColor,
              ),
            ),
            SizedBox(height: 15.h),
            Row(
              children: [
                Text(
                  ('Payment Status : '),
                  style: TextStyle(
                    fontFamily: 'Dosis',
                    fontSize: 15.sp,
                    letterSpacing: 2,
                    color: textColor,
                  ),
                ),
                Text(
                  (widget.order['paymentstatus']),
                  style: TextStyle(
                    fontFamily: 'Dosis',
                    letterSpacing: 2,
                    fontSize: 15.sp,
                    color: textColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.h),
            Row(
              children: [
                Text(
                  ('Store Id : '),
                  style: TextStyle(
                    fontFamily: 'Dosis',
                    fontSize: 15.sp,
                    letterSpacing: 2,
                    color: textColor,
                  ),
                ),
                Text(
                  (widget.order['sid']),
                  style: TextStyle(
                    fontFamily: 'Dosis',
                    letterSpacing: 2,
                    fontSize: 15.sp,
                    color: textColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}
