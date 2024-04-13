import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:smart_home/view/homePage.dart';


class ContentApp extends StatefulWidget {
  const ContentApp({super.key});

  @override
  State<ContentApp> createState() => _ContentAppState();
}

class _ContentAppState extends State<ContentApp> {
  int chooseIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBarPage(),
      bottomNavigationBar: bottomNavigationBar(),
    );
  }

  Widget bottomNavigationBar(){
    return Container(
      padding: const EdgeInsets.only(left: 20,right: 20,bottom: 20),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: GNav(
            selectedIndex: chooseIndex,
            backgroundColor: Colors.white,
            rippleColor: Colors.white,
            hoverColor: Colors.white,
            haptic: true,
            tabBorderRadius: 30,
            tabActiveBorder: Border.all(color: Colors.transparent, width: 1,),
            tabBorder: Border.all(color: Colors.transparent, width: 1),
            curve: Curves.easeOutExpo,
            duration: const Duration(milliseconds: 300),
            gap: 8,
            color: Colors.black38,
            activeColor: Colors.pinkAccent,
            iconSize: 24,
            tabBackgroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            tabs: [
              GButton(
                icon: Icons.home,
                text: 'Home',
                textSize: 15,
                iconSize: 20,
              ),
              GButton(
                icon: Icons.settings,
                text: 'Settings',
                textSize: 15,
                iconSize: 20,
              ),
            ],
          onTabChange: (index){
            setState(() {
              chooseIndex = index;
            });
          },
        ),
      ),
    );
  }
  Widget getBarPage(){
    return IndexedStack(
      index: chooseIndex,
      children: <Widget>[
        HomePage(),
        // Graph(),
      ],
    );
  }
}