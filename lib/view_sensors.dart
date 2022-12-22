// ignore_for_file: prefer_final_fields, sort_child_properties_last

import 'dart:async';
import 'dart:io';

import 'package:barometer/constant.dart';
import 'package:barometer/service.dart';
import 'package:device_imei/device_imei.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:device_information/device_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barometer/flutter_barometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stats/stats.dart';

class SensorsView extends StatefulWidget {
  const SensorsView({super.key});

  @override
  State<SensorsView> createState() => _SensorsViewState();
}

class _SensorsViewState extends State<SensorsView> {
  bool isActiveStart = false;
  bool isSendData = false;
  double _currentPressure = 0.0,
      _minimumPressure = 0.0,
      _maximumPressure = 0.0,
      _deviation = 0.0;
  String? _imeiNo, _modelName = "", _manufacturerName = "";
  bool isNotExistBarometer = false;

  TextEditingController _imeiController = TextEditingController();

  List<double> _currentPressureList = [];

  Timer? _timer;
  @override
  void initState() {
    super.initState();
    valuesData();
    checkpermissions();
    Future.delayed(const Duration(seconds: 1), () => standeredDaviation());
    _timer = Timer.periodic(
        const Duration(seconds: 6), (Timer t) => standeredDaviation());
  }

  Future<void> checkpermissions() async {
    if (await Permission.phone.request().isDenied) {
      await Permission.phone.request();
    } else {
      initPlatformState();
    }
  }

  Future<void> initPlatformState() async {
    print("Hello Function is call");
    late String imeiNo = '', modelName = '', manufacturer = '';
    try {
      imeiNo = await DeviceInformation.deviceIMEINumber;
      modelName = await DeviceInformation.deviceModel;
      manufacturer = await DeviceInformation.deviceManufacturer;
    } on PlatformException catch (e) {
      print(e.message);
    }
    if (!mounted) return;
    setState(() {
      _imeiNo = imeiNo;
      _modelName = modelName;
      _manufacturerName = manufacturer;
    });
  }

  void valuesData() async {
    Future.delayed(const Duration(seconds: 2), () {
      if (_currentPressure == 0.0) {
        setState(() {
          isNotExistBarometer = true;
        });
      } else {
        setState(() {
          isNotExistBarometer = false;
        });
      }
    });

    flutterBarometerEvents.listen((FlutterBarometerEvent event) {
      setState(() {
        _currentPressure = (event.pressure * 1000).round() / 1000;
        _currentPressureList.add(_currentPressure);
      });
    });
  }

  void standeredDaviation() {
    List<double> input = _currentPressureList;
    final stats = Stats.fromData(input);
    setState(() {
      _minimumPressure = double.parse(stats.min.toString());
      _maximumPressure = double.parse(stats.max.toString());
      _deviation = double.parse(stats.standardDeviation.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SizedBox.expand(
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  color: Colors.transparent,
                  width: width,
                  height: height * 0.37,
                  padding: EdgeInsets.symmetric(horizontal: width / 7),
                  child: Center(child: Image.asset(Constants.logoPath)),
                ),
                Column(
                  children: [
                    Column(
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
                          width: width - (width / 20) * 2,
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
                          width: width - (width / 20) * 2,
                          height: 40,
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
                            padding: const EdgeInsets.only(bottom: 8),
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
                                controller:
                                    Platform.isIOS ? _imeiController : null,
                                // initialValue: Platform.isAndroid ? _imeiNo : null,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    contentPadding: const EdgeInsets.only(
                                        left: 15,
                                        bottom: 5,
                                        top: 11,
                                        right: 15),
                                    hintText: Platform.isAndroid
                                        ? _imeiNo ?? "Please Enter IMEI Number"
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
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      color: Colors.transparent,
                      width: width,
                      margin: EdgeInsets.symmetric(horizontal: width / 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          tileWidget(
                            title: 'Current Pressure',
                            value: isNotExistBarometer
                                ? "Barometer sensor Not Exist in this Device"
                                : _currentPressure.toStringAsFixed(3),
                            isNotExistBaeometer: isNotExistBarometer,
                          ),
                          tileWidget(
                            title: 'Maximum  Pressure',
                            value: isNotExistBarometer
                                ? "Barometer sensor Not Exist in this Device"
                                : _maximumPressure.toStringAsFixed(3),
                            isNotExistBaeometer: isNotExistBarometer,
                          ),
                          tileWidget(
                            title: 'Minimum Pressure',
                            value: isNotExistBarometer
                                ? "Barometer sensor Not Exist in this Device"
                                : _minimumPressure.toStringAsFixed(3),
                            isNotExistBaeometer: isNotExistBarometer,
                          ),
                          tileWidget(
                            title: 'Standard Deviation',
                            value: isNotExistBarometer
                                ? "Barometer sensor Not Exist in this Device"
                                : _deviation.toStringAsFixed(3),
                            isNotExistBaeometer: isNotExistBarometer,
                          ),
                          customButton(
                            isActive: isActiveStart,
                            callback: (val) {
                              if (Platform.isIOS) {
                                if (_imeiController.text.isEmpty) {
                                  alert(context, 'Error',
                                      "Please Enter IMEI Number", () {
                                    Navigator.pop(context);
                                  });
                                  return;
                                }
                                if (_imeiController.text.length < 14) {
                                  alert(context, 'Error', "invalid IMEI Number",
                                      () {
                                    Navigator.pop(context);
                                  });
                                  return;
                                }
                              }
                              setState(() {
                                isActiveStart = val;
                              });
                              funcationcall();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget tileWidget({
    String title = 'Sensors Name',
    dynamic value = 123.456,
    required bool isNotExistBaeometer,
  }) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Column(
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
            width: width,
            height: width / 12,
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: width * 0.04,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
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
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(3, 0, 3, 3),
            width: width,
            height: width / 12,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(11.5),
                  bottomRight: Radius.circular(11.5),
                ),
              ),
              width: width,
              height: double.infinity,
              child: Center(
                child: GradientText(
                  value.toString(),
                  style: TextStyle(
                    fontSize:
                        isNotExistBaeometer ? width * 0.032 : width * 0.04,
                    fontWeight: FontWeight.w600,
                  ),
                  gradient: const LinearGradient(colors: [
                    Color(0xff1692d0),
                    Color(0xff132e72),
                  ]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget customButton({
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

  void funcationcall() async {
    if (isActiveStart) {
      _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
        Map data = {
          "IMEI": Platform.isIOS ? _imeiController.text : _imeiNo,
          "Model": "$_manufacturerName  $_modelName}",
          "Barometer Data": {
            "Max Pressure": _maximumPressure.toStringAsFixed(3),
            "Min Pressure": _minimumPressure.toStringAsFixed(3),
            "Deviation": _deviation.toStringAsFixed(3),
          }
        };
        HttpClinet.postApi(Constants.apiPath, data);
      });
    } else {
      _timer!.cancel();
    }
  }
}

class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    super.key,
    required this.gradient,
    this.style,
  });

  final String text;
  final TextStyle? style;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text, style: style),
    );
  }
}

alert(context, title, msg, function, {no = 1}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        backgroundColor: Colors.white,
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        content: Text(
          msg,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          alertActionButton(
              title == 'Success'
                  ? 'OK'
                  : title == 'Confirm'
                      ? 'Yes'
                      : 'Close',
              function)
        ],
      );
    },
  );
}

alertActionButton(text, function) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
    child: MaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      textColor: Colors.white,
      color: const Color(0xff132e72),
      child: Text(
        text,
        textAlign: TextAlign.center,
      ),
      onPressed: function,
    ),
  );
}
