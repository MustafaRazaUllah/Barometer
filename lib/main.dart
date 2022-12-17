// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';

import 'package:barometer/barometer_view.dart';
import 'package:barometer/view_sensors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barometer/flutter_barometer.dart';
// import 'package:flutter_barometer_plugin/flutter_barometer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Barometer',
      theme: ThemeData(
        colorScheme: ThemeData().colorScheme.copyWith(primary: Colors.amber),
      ),
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: MyBehavior(),
          child: child!,
        );
      },
      // home: BarometerView(),
      // home: DeviceDataView(),
      home: SensorsView(),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class BarometerScreen extends StatefulWidget {
  const BarometerScreen({super.key});

  @override
  State<BarometerScreen> createState() => _BarometerScreenState();
}

class _BarometerScreenState extends State<BarometerScreen> {
  String? data;

  void valuesdara() async {
    flutterBarometerEvents.listen((FlutterBarometerEvent event) {
      // print(event);
      setState(() {
        data = event.pressure.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Text(
                data ?? "Hello",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                valuesdara();
              },
              child: Text("Click"),
            )
          ],
        ),
      ),
    );
    // StreamBuilder(
    //   stream: Barometer.getBarometerStream(),
    //   builder: (BuildContext context, AsyncSnapshot snapshot) {
    //     if (snapshot.hasData) {
    //       print(snapshot.data);
    //     }
    //     return Container();
    //   },
    // );
  }
}
