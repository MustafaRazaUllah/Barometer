// ignore_for_file: prefer_final_fields, sort_child_properties_last

import 'dart:async';
import 'dart:io';
import 'package:barometer/Constants/constant.dart';
import 'package:barometer/Barometer/Service/service.dart';
import 'package:barometer/Utils/alert.dart';
import 'package:barometer/Barometer/View/Components/tilewidget.dart';
import 'package:device_information/device_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barometer/flutter_barometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stats/stats.dart';

import 'Components/custom_button.dart';
import 'Components/textfeild.dart';

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
    checkBarometer();
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

  void checkBarometer() async {
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
                //
                /* Logo Widget but logo path handle form constant.dart file */
                //
                Container(
                  color: Colors.transparent,
                  width: width,
                  height: height * 0.37,
                  padding: EdgeInsets.symmetric(horizontal: width / 7),
                  child: Center(
                    child: Image.asset(Constants.logoPath),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      //
                      /* On Android Side Get auto IMEI number and iOS side manually add IMEI Number */
                      //
                      customTextFeild(
                        context: context,
                        controller: _imeiController,
                        imeiNo: _imeiNo,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      //
                      /* Get Current Pressure from barometer */
                      //
                      tileWidget(
                        context: context,
                        title: 'Current Pressure',
                        value: isNotExistBarometer
                            ? "Barometer sensor Not Exist in this Device"
                            : _currentPressure.toStringAsFixed(3),
                        isNotExistBaeometer: isNotExistBarometer,
                      ),
                      //
                      /* Get Maximum Pressure from barometer */
                      //
                      tileWidget(
                        context: context,
                        title: 'Maximum  Pressure',
                        value: isNotExistBarometer
                            ? "Barometer sensor Not Exist in this Device"
                            : _maximumPressure.toStringAsFixed(3),
                        isNotExistBaeometer: isNotExistBarometer,
                      ),
                      //
                      /* Get Minimum Pressure from barometer */
                      //
                      tileWidget(
                        context: context,
                        title: 'Minimum Pressure',
                        value: isNotExistBarometer
                            ? "Barometer sensor Not Exist in this Device"
                            : _minimumPressure.toStringAsFixed(3),
                        isNotExistBaeometer: isNotExistBarometer,
                      ),
                      //
                      /* Find Standard Deviation of the Pressure */
                      //
                      tileWidget(
                        context: context,
                        title: 'Standard Deviation',
                        value: isNotExistBarometer
                            ? "Barometer sensor Not Exist in this Device"
                            : _deviation.toStringAsFixed(3),
                        isNotExistBaeometer: isNotExistBarometer,
                      ),
                      customButton(
                        context: context,
                        isActive: isActiveStart,
                        callback: (val) {
                          funcationcall(val);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void funcationcall(dynamic value) async {
    if (Platform.isIOS) {
      if (_imeiController.text.isEmpty) {
        alert(context, 'Error', "Please Enter IMEI Number", () {
          Navigator.pop(context);
        });
        return;
      }
      if (_imeiController.text.length < 14) {
        alert(context, 'Error', "invalid IMEI Number", () {
          Navigator.pop(context);
        });
        return;
      }
    }
    setState(() {
      isActiveStart = value;
    });
    if (isActiveStart) {
      _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
        Map data = {
          "IMEI": Platform.isIOS ? _imeiController.text : _imeiNo,
          "Model": "$_manufacturerName  $_modelName",
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
