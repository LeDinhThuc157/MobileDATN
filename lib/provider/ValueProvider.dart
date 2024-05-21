import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smart_home/api/apiControlDevice.dart';
import 'package:smart_home/api/apiViewListDevice.dart';
import '../api/apiRDeviceDetails.dart';
import '../class/ListDevice.dart';
import '../class/valueDeviceClass.dart';

class ValueProvider extends ChangeNotifier {
  ListDevice _valueL = ListDevice();
  bool isLight1On = false;
  bool isLight2On = false;
  bool isDoor1ON = false;
  bool isDoor2ON = false;

  // bool isLight1Fav = false;
  // bool isLight2Fav = false;
  // bool isDoor1Fav = false;
  // bool isDoor2Fav = false;

  bool isAutoLight1 = false;
  bool isAutoLight2 = false;
  bool isAutoDoor1 = false;
  bool isAutoDoor2 = false;

  ListDevice get value => _valueL;
  ValueProvider() {
    value.listDevice = [];
  }
  void fetchValue() async {
    ApiViewListDevice res = await Request();
    Map<String, dynamic> map = res.userMap;
    List<String> list_device = [];
    for(var i in map.keys){
      list_device.add(i);
    }
    ListDevice valueL = new ListDevice();

    for(var id in list_device){
      ApiDeviceDetails response = await RequestDevice(id);
      Map<String, dynamic> userMap = response.userMap;
      ValueDeviceClass value = ValueDeviceClass();
      value.device_id = id;
      value.status = userMap['Status'];
      value.lastReceived = DateTime.parse(userMap['lastReceived']);
      value.deviceName = userMap['Device_name'];
      value.version = userMap['version_running'] == null ? '' : userMap['version_running'];
      value.tem = userMap['lastData']['tem'] == null ? 0 : userMap['lastData']['tem'];
      value.hum = userMap['lastData']['hum'] == null ? 0 : userMap['lastData']['hum'];
      value.vMq2 = userMap['lastData']['mq2'] == null ? 0 : userMap['lastData']['mq2'];
      value.dr1 = userMap['lastData']['dr1'] == null ? 0 : userMap['lastData']['dr1'];
      value.dr2 = userMap['lastData']['dr2'] == null ? 0 : userMap['lastData']['dr2'];
      value.dm1 = userMap['lastData']['dm1'] == null ? 0 : userMap['lastData']['dm1'];
      value.dm2 = userMap['lastData']['dm2'] == null ? 0 : userMap['lastData']['dm2'];
      value.ds1 = userMap['lastData']['ds1'] == null ? 0 : userMap['lastData']['ds1'];
      value.ds2 = userMap['lastData']['ds2'] == null ? 0 : userMap['lastData']['ds2'];
      value.fn1 = userMap['lastData']['fn1'] == null ? 0 : userMap['lastData']['fn1'];
      value.fn2 = userMap['lastData']['fn2'] == null ? 0 : userMap['lastData']['fn2'];
      value.fs1 = userMap['lastData']['fs1'] == null ? 0 : userMap['lastData']['fs1'];
      value.fs2 = userMap['lastData']['fs2'] == null ? 0 : userMap['lastData']['fs2'];
      value.ld1 = userMap['lastData']['ld1'] == null ? 0 : userMap['lastData']['ld1'];
      value.ld2 = userMap['lastData']['ld2'] == null ? 0 : userMap['lastData']['ld2'];
      value.lm1 = userMap['lastData']['lm1'] == null ? 0 : userMap['lastData']['lm1'];
      if (userMap['lastData']['lm2'] == null) {
        value.lm2 = 0;
      } else {
        value.lm2 = userMap['lastData']['lm2'];
      }
      value.ls1 = userMap['lastData']['ls1'] == null ? 0 : userMap['lastData']['ls1'];
      value.ls2 = userMap['lastData']['ls2'] == null ? 0 : userMap['lastData']['ls2'];
      value.bs = userMap['lastData']['bs'] == null ? 0 : userMap['lastData']['bs'];
      valueL.listDevice.add(value);
      setValue(value.ls1,value.ls2,value.ds1,value.ds2,value.dm1,value.dm2,value.lm1,value.lm2);
    }
    _valueL = valueL;
    notifyListeners();
  }

  void startFetching() {
    fetchValue();
    Timer.periodic(Duration(seconds: 10), (timer) {
      fetchValue();
    });
  }

  void setValue(double ls1, double ls2, double ds1, double ds2, double dm1, double dm2, double lm1, double lm2){
    if(ls1 == 1) isLight1On = true;
    if(ls1 == 0) isLight1On = false;
    if(ls2 == 1) isLight2On = true;
    if(ls2 == 0) isLight2On = false;

    if(ds1 == 1) isDoor1ON = true;
    if(ds1 == 0) isDoor1ON = false;
    if(ds2 == 1) isDoor2ON = true;
    if(ds2 == 0) isDoor2ON = false;

    if(lm1 == 1) isAutoLight1 = true;
    if(lm1 == 0) isAutoLight1 = false;
    if(lm2 == 1) isAutoLight2 = true;
    if(lm2 == 0) isAutoLight2 = false;

    if(dm1 == 1) isAutoDoor1 = true;
    if(dm1 == 0) isAutoDoor1 = false;
    if(dm2 == 1) isAutoDoor2 = true;
    if(dm2 == 0) isAutoDoor2 = false;

  }

  Future<void> light1Auto(String id) async {
    isAutoLight1 = !isAutoLight1;
    if(isAutoLight1){
      ApiControlDevice control = await ControlDevice("1", "autolight", "1",id);
    }else{
      ApiControlDevice control = await ControlDevice("1", "autolight", "0",id);
    }
    notifyListeners();
  }
  Future<void> light2Auto(String id) async {
    isAutoLight2 = !isAutoLight2;
    if(isAutoLight2){
      ApiControlDevice control = await ControlDevice("2", "autolight", "1",id);
    }else{
      ApiControlDevice control = await ControlDevice("2", "autolight", "0",id);
    }
    notifyListeners();
  }

  Future<void> door1Auto(String id) async {
    isAutoDoor1 = !isAutoDoor1;
    if(isAutoDoor1){
      ApiControlDevice control = await ControlDevice("1", "autodoor", "1",id);
    }else{
      ApiControlDevice control = await ControlDevice("1", "autodoor", "0",id);
    }
    notifyListeners();
  }
  Future<void> door2Auto(String id) async {
    isAutoDoor2 = !isAutoDoor2;
    if(isAutoDoor2){
      ApiControlDevice control = await ControlDevice("2", "autodoor", "1",id);
    }else{
      ApiControlDevice control = await ControlDevice("2", "autodoor", "0",id);
    }
    notifyListeners();
  }

  Future<void> door1Switch(String id) async {
    isDoor1ON = !isDoor1ON;
    if(isDoor1ON){
      ApiControlDevice control = await ControlDevice("1", "cdoor", "1", id);
      // if(control.statusResponse != 200){
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       backgroundColor: Colors.green, // Màu xanh cho thành công
      //       content: Text('Control light On!'),
      //     ),
      //   );
      // }else{
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       backgroundColor: Colors.red, // Màu xanh cho thành công
      //       content: Text('Control light Fail!'),
      //     ),
      //   );
      // }
    }else{
      ApiControlDevice control = await ControlDevice("1", "cdoor", "0", id);
      // if(control.statusResponse != 200){
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       backgroundColor: Colors.green, // Màu xanh cho thành công
      //       content: Text('Control light Off!'),
      //     ),
      //   );
      // }else{
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       backgroundColor: Colors.red, // Màu xanh cho thành công
      //       content: Text('Control light Fail!'),
      //     ),
      //   );
      // }
    }
    notifyListeners();
  }
  Future<void> door2Switch(String id) async {
    isDoor2ON = !isDoor2ON;
    if(isDoor2ON){
      ApiControlDevice control = await ControlDevice("2", "cdoor", "1", id);
      // if(control.statusResponse != 200){
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       backgroundColor: Colors.green, // Màu xanh cho thành công
      //       content: Text('Control light On!'),
      //     ),
      //   );
      // }else{
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       backgroundColor: Colors.red, // Màu xanh cho thành công
      //       content: Text('Control light Fail!'),
      //     ),
      //   );
      // }
    }else{
      ApiControlDevice control = await ControlDevice("2", "cdoor", "0", id);
      // if(control.statusResponse != 200){
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       backgroundColor: Colors.green, // Màu xanh cho thành công
      //       content: Text('Control light Off!'),
      //     ),
      //   );
      // }else{
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       backgroundColor: Colors.red, // Màu xanh cho thành công
      //       content: Text('Control light Fail!'),
      //     ),
      //   );
      // }
    }
    notifyListeners();
  }
  Future<void> light1Switch(String id) async {
    isLight1On = !isLight1On;
    if(isLight1On){
      ApiControlDevice control = await ControlDevice("1", "clight", "1", id);
      // if(control.statusResponse != 200){
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       backgroundColor: Colors.green, // Màu xanh cho thành công
      //       content: Text('Control light On!'),
      //     ),
      //   );
      // }else{
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       backgroundColor: Colors.red, // Màu xanh cho thành công
      //       content: Text('Control light Fail!'),
      //     ),
      //   );
      // }
    }else{
      ApiControlDevice control = await ControlDevice("1", "clight", "0", id);
      // if(control.statusResponse != 200){
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       backgroundColor: Colors.green, // Màu xanh cho thành công
      //       content: Text('Control light Off!'),
      //     ),
      //   );
      // }else{
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       backgroundColor: Colors.red, // Màu xanh cho thành công
      //       content: Text('Control light Fail!'),
      //     ),
      //   );
      // }
    }
    notifyListeners();
  }
  Future<void> light2Switch(String id) async {
    isLight2On = !isLight2On;
    if(isLight2On){
      ApiControlDevice control = await ControlDevice("2", "clight", "1", id);
      // if(control.statusResponse != 200){
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       backgroundColor: Colors.green, // Màu xanh cho thành công
      //       content: Text('Control light On!'),
      //     ),
      //   );
      // }else{
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       backgroundColor: Colors.red, // Màu xanh cho thành công
      //       content: Text('Control light Fail!'),
      //     ),
      //   );
      // }
    }else{
      ApiControlDevice control = await ControlDevice("2", "clight", "0", id);
      // if(control.statusResponse != 200){
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       backgroundColor: Colors.green, // Màu xanh cho thành công
      //       content: Text('Control light Off!'),
      //     ),
      //   );
      // }else{
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       backgroundColor: Colors.red, // Màu xanh cho thành công
      //       content: Text('Control light Fail!'),
      //     ),
      //   );
      // }
    }
    notifyListeners();
  }

}
