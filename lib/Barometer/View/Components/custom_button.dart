import 'package:flutter/material.dart';

Widget customButton({
  required BuildContext context,
  bool isActive = true,
  required Function callback,
}) {
  var height = MediaQuery.of(context).size.height;
  var width = MediaQuery.of(context).size.width;
  return Padding(
    padding: const EdgeInsets.only(top: 10, bottom: 15.0),
    child: Column(
      children: [
        Material(
          child: InkWell(
            onTap: () => callback(!isActive),
            child: Container(
              decoration: !isActive
                  ? BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xff1692d0),
                          Color(0xff132e72),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(15.0),
                    )
                  : BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.red.shade300,
                          Colors.red.shade900,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
              width: width,
              height: width / 7.5,
              child: Center(
                child: Text(
                  isActive ? "Stop Sending Data" : "Start Sending Data",
                  style: TextStyle(
                    fontSize: width * 0.05,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
