import 'package:device_information/device_information.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class DeviceDataView extends StatefulWidget {
  @override
  _DeviceDataViewState createState() => _DeviceDataViewState();
}

class _DeviceDataViewState extends State<DeviceDataView> {
  String _platformVersion = 'Unknown',
      _imeiNo = "",
      _modelName = "",
      _manufacturerName = "",
      _deviceName = "",
      _productName = "",
      _cpuType = "",
      _hardware = "";
  var _apiLevel;

  @override
  void initState() {
    super.initState();
    checkpermissions();

    // initPlatformState();
  }

  Future<void> checkpermissions() async {
    if (await Permission.phone.request().isDenied) {
      await Permission.phone.request();
    } else {
      initPlatformState();
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    print("Hello Function is call");
    late String platformVersion,
        imeiNo = '',
        modelName = '',
        manufacturer = '',
        deviceName = '',
        productName = '',
        cpuType = '',
        hardware = '';
    var apiLevel;
    // Platform messages may fail,
    // so we use a try/catch PlatformException.

    try {
      platformVersion = await DeviceInformation.platformVersion;
      imeiNo = await DeviceInformation.deviceIMEINumber;
      modelName = await DeviceInformation.deviceModel;
      manufacturer = await DeviceInformation.deviceManufacturer;
      apiLevel = await DeviceInformation.apiLevel;
      deviceName = await DeviceInformation.deviceName;
      productName = await DeviceInformation.productName;
      // cpuType = await DeviceInformation.cpuName;
      hardware = await DeviceInformation.hardware;
    } on PlatformException catch (e) {
      platformVersion = '${e.message}';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = "Running on :$platformVersion";
      _imeiNo = imeiNo;
      _modelName = modelName;
      _manufacturerName = manufacturer;
      _apiLevel = apiLevel;
      _deviceName = deviceName;
      _productName = productName;
      _cpuType = cpuType;
      _hardware = hardware;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Information Plugin Example app'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 40,
            ),
            Text('$_platformVersion\n'),
            SizedBox(
              height: 10,
            ),
            Text('IMEI Number: $_imeiNo\n'),
            SizedBox(
              height: 10,
            ),
            Text('Device Model: $_modelName\n'),
            SizedBox(
              height: 10,
            ),
            Text('API Level: $_apiLevel\n'),
            SizedBox(
              height: 10,
            ),
            Text('Manufacture Name: $_manufacturerName\n'),
            SizedBox(
              height: 10,
            ),
            Text('Device Name: $_deviceName\n'),
            SizedBox(
              height: 10,
            ),
            Text('Product Name: $_productName\n'),
            SizedBox(
              height: 10,
            ),
            Text('CPU Type: $_cpuType\n'),
            SizedBox(
              height: 10,
            ),
            Text('Hardware Name: $_hardware\n'),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
