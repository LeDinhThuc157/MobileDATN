import 'dart:math';

import 'package:flutter/cupertino.dart';

import 'ValueProvider.dart';

class HomeScreenViewModel extends ValueProvider {
  //-------------VARIABLES-------------//
  int selectedIndex = 0;
  int randomNumber = 1;
  final PageController pageController = PageController();
  bool isLightOn = true;
  bool isACON = false;
  bool isSpeakerON = false;
  bool isFanON = false;
  bool isLightFav = false;
  bool isACFav = false;
  bool isSpeakerFav = false;
  bool isFanFav = false;
  void generateRandomNumber() {
    randomNumber = Random().nextInt(8);
    notifyListeners();
  }
  void lightFav(){
    isLightFav = !isLightFav;
    notifyListeners();
  }
  void acFav(){
    isACFav = !isACFav;
    notifyListeners();
  }
  void speakerFav() {
    isSpeakerFav = !isSpeakerFav;
    notifyListeners();
  }
  void fanFav() {
    isFanFav = !isFanFav;
    notifyListeners();
  }

  void acSwitch() {
    isACON = !isACON;
    notifyListeners();
  }

  void speakerSwitch() {
    isSpeakerON = !isSpeakerON;
    notifyListeners();
  }

  void fanSwitch() {
    isFanON = !isFanON;
    notifyListeners();
  }
  void lightSwitch() {

    isLightOn = !isLightOn;
    print("swicth compleyte $isLightOn");
    notifyListeners();
  }

  ///On tapping bottom nav bar items
  void onItemTapped(int index) {
    selectedIndex = index;
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
    notifyListeners();
  }
}
