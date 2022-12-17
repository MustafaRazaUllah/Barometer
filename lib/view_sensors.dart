// ignore_for_file: prefer_final_fields

import 'dart:async';

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
  String _imeiNo = "", _modelName = "", _manufacturerName = "";

  List<double> _currentPressureList = [];

  Timer? _timer;
  @override
  void initState() {
    super.initState();
    valuesdara();
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

  void valuesdara() async {
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
      body: SizedBox.expand(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                color: Colors.transparent,
                width: width,
                padding: EdgeInsets.symmetric(horizontal: width / 7),
                child: Center(child: Image.asset('assets/applogo.png')),
              ),
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
                      value: _currentPressure.toStringAsFixed(3)),
                  tileWidget(
                      title: 'Maximum  Pressure',
                      value: _maximumPressure.toStringAsFixed(3)),
                  tileWidget(
                      title: 'Minimum Pressure',
                      value: _minimumPressure.toStringAsFixed(3)),
                  tileWidget(
                    title: 'Standard Deviation',
                    value: _deviation.toStringAsFixed(3),
                  ),
                  customButton(
                    isActive: isActiveStart,
                    callback: (val) {
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
      ),
    );
  }

  Widget tileWidget({
    String title = 'Sensors Name',
    dynamic value = 123.456,
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
            height: width / 10,
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: width * 0.05,
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
            height: width / 10,
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
                    fontSize: width * 0.05,
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
      padding: const EdgeInsets.only(bottom: 15.0),
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
        setState(() {
          Map data = {
            "IMEI": _imeiNo,
            "Model": "$_manufacturerName  $_modelName}",
            "Barometer Data": {
              "Max Pressure": _maximumPressure.toStringAsFixed(3),
              "Min Pressure": _minimumPressure.toStringAsFixed(3),
              "Deviation": _deviation.toStringAsFixed(3),
            }
          };
          print("==>  ${data.toString()}");
        });
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
