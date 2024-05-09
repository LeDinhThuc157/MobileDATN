import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_home/splash_view/splash_screen.dart';
import 'package:smart_home/view/homePage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

Future<void> main() async {
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _savedValue = prefs.getString('username') ?? '';
    OneSignal.login(_savedValue);

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

