import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_home/splash_view/splash_screen.dart';
import 'package:smart_home/view/homePage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'api/apiControlDevice.dart';
import 'api/apiViewListDevice.dart';
import 'api/loginApi.dart';

Future<void> main() async {
  // int numberOfRuns = 1000;
  // List<int> durations = [];
  // print("/////////////// Kiểm thử 1000 Accout not exist /////////////////\n");
  // for (int i = 0; i < numberOfRuns; i++) {
  //   var t1 = DateTime.now();
  //   try{
  //     ApiControlDevice response =
  //     await ControlDevice("1","cdoor","1","52:0E:D7:12:C4:35");
  //     //     .timeout(Duration(milliseconds: 100),
  //     //   onTimeout: () {
  //     //     throw TimeoutException("Mất kết nối, vui lòng thử lại.");
  //     //   },
  //     // );
  //     Map<String, dynamic> userMap = response.userMap;
  //     var t2 = DateTime.now();
  //     var duration = t2.difference(t1).inMilliseconds;
  //     durations.add(duration);
  //     print("$i: ${duration}ms");
  //   } on TimeoutException catch (e){
  //   }
  // }
  //
  // // Tính toán thời gian phản hồi trung bình
  // double averageDuration = durations.reduce((a, b) => a + b) / numberOfRuns;
  // print("Average response time: ${averageDuration}ms");
  //
  // // Tính toán độ lệch chuẩn
  // num sumOfSquaredDifferences = durations
  //     .map((duration) => pow(duration - averageDuration, 2))
  //     .reduce((a, b) => a + b);
  // double standardDeviation = sqrt(sumOfSquaredDifferences / numberOfRuns);
  // print("Standard deviation: ${standardDeviation}ms");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _loadSavedValue();
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.initialize("441e3824-126c-458d-bcbb-f75bde50dc86");
    OneSignal.Notifications.requestPermission(true).then((value){
      print("signal value: $value");
    });
  }
  Future<void> _loadSavedValue() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String _savedValue = prefs.getString('username') ?? '';
    OneSignal.login("admin@datn");

  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  SplashScreen(),
    );
  }
}

