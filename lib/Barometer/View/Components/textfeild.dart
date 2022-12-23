import 'dart:io';

import 'package:flutter/material.dart';

Widget customTextFeild({
  required BuildContext context,
  required TextEditingController controller,
  String? imeiNo,
}) {
  var height = MediaQuery.of(context).size.height;
  var width = MediaQuery.of(context).size.width;
  return Column(
    children: [
      Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xff1692d0),
              Color(0xff132e72),
            ],
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        width: double.infinity, //width - (width / 20) * 2,
        height: width / 12,
        child: Center(
          child: Text(
            "Mobile IMEI Number",
            style: TextStyle(
              fontSize: width * 0.04,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
      Container(
        width: double.infinity, //width: width - (width / 20) * 2,
        height: width / 12,
        padding: const EdgeInsets.fromLTRB(3, 0, 3, 3),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xff1692d0),
              Color(0xff132e72),
            ],
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        child: Container(
          padding: EdgeInsets.only(bottom: width / 70),
          width: width - (width / 20) * 2,
          height: width / 12,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
          child: Center(
            child: TextFormField(
              textAlign: TextAlign.center,
              cursorColor: const Color(0xff1692d0),
              controller: Platform.isIOS ? controller : null,
              // initialValue: Platform.isAndroid ? _imeiNo : null,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.only(
                      left: 15, bottom: 5, top: 11, right: 15),
                  hintText: Platform.isAndroid
                      ? imeiNo ?? "Please Enter IMEI Number"
                      : "Please Enter IMEI Number",
                  hintStyle: TextStyle(
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff132e72),
                  )),
              readOnly: Platform.isIOS ? false : true,
            ),
          ),
        ),
      ),
    ],
  );
}
