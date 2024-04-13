import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smart_home/view/contentApp.dart';
import 'package:smart_home/res/constants.dart';
import 'package:smart_home/splash_view/soft_button.dart';
import 'package:smart_home/view/loginPage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 5000), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: CircularSoftButton(
            radius: 60,
            icon: Center(
              child: Image.asset(
                'assets/icons/smart-home.png',
                height: 50,
                width: 50,
                scale: 1,
              ),
            )),
      ),
    );
  }
}
