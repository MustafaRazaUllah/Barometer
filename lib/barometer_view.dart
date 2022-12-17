import 'package:barometer/devicedata.dart';
import 'package:device_information/device_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barometer/flutter_barometer.dart';

import 'package:permission_handler/permission_handler.dart';

class BarometerView extends StatefulWidget {
  @override
  _BarometerViewState createState() => _BarometerViewState();
}

class _BarometerViewState extends State<BarometerView> {
  // BarometerValue _currentPressure = const BarometerValue(0.0);

  String _platformVersion = 'Unknown',
      _imeiNo = "",
      _modelName = "",
      _manufacturerName = "",
      _deviceName = "",
      _productName = "",
      _cpuType = "",
      _hardware = "";
  double _currentPressure = 0.0;
  var _apiLevel;

  @override
  void initState() {
    super.initState();
    valuesdara();
    checkpermissions();
    // FlutterBarometer.currentPressureEvent.listen((event) {
    //   setState(() {
    //     _currentPressure = event;
    //   });
    // });
  }

  void valuesdara() async {
    flutterBarometerEvents.listen((FlutterBarometerEvent event) {
      // print(event);
      setState(() {
        _currentPressure = event.pressure;
      });
    });
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
    late String platformVersion,
        imeiNo = '',
        modelName = '',
        manufacturer = '',
        deviceName = '',
        productName = '',
        cpuType = '',
        hardware = '';
    var apiLevel;

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

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
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
        title: const Text(
          'Flutter Barometer',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            customDiveder("Device Information"),
            const SizedBox(height: 20),

            deviceInfoText(
              _imeiNo,
              'IMEI No',
            ),
            deviceInfoText(
              _modelName,
              'Model Name',
            ),
            deviceInfoText(
              _manufacturerName,
              'Manufacturer By',
            ),
            deviceInfoText(
              _apiLevel,
              'API Level',
            ),
            deviceInfoText(
              _platformVersion,
              'Platform Version',
            ),

            const SizedBox(height: 20),
            customDiveder("Pressure Information"),
            const SizedBox(height: 20),
            // customText(
            //   '${(_currentPressure * 1000).round() / 1000}',
            //   'inHg',
            // ),
            // customText(
            //   '${(_currentPressure.millimeterOfMercury * 1000).round() / 1000}',
            //   'mmHg',
            // ),
            // customText(
            //   '${(_currentPressure.poundsSquareInch * 1000).round() / 1000}',
            //   'psi',
            // ),
            // customText(
            //   '${(_currentPressure.atm * 1000).round() / 1000}',
            //   'atm',
            // ),
            const SizedBox(height: 50),
            Container(
              width: MediaQuery.of(context).size.width / 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.amber,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      "Current Pressure",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    customText(
                      '${(_currentPressure * 1000).round() / 1000}',
                      'hPa',
                    ),
                  ],
                ),
              ),
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => DeviceDataView(),
            //       ),
            //     );
            //   },
            //   child: const Text('Start'),
            // ),
          ],
        ),
      ),
    );
  }
}

Widget customDiveder(
  title,
) {
  return Row(
    children: [
      Expanded(
        child: Container(
          height: 2,
          color: Colors.grey,
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Text(
          '$title',
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      Expanded(
        child: Container(
          height: 2,
          color: Colors.grey,
        ),
      ),
    ],
  );
}

Widget customText(text, subtext) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10.0),
    child: Row(
      children: [
        Text(
          '$text',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        Text(
          '$subtext',
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
      ],
    ),
  );
}

Widget deviceInfoText(text, subtext) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10.0),
    child: Row(
      children: [
        Text(
          '$subtext',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        Text(
          '$text',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}
