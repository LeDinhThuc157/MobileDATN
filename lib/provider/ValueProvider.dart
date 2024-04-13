import 'dart:async';
import 'package:flutter/material.dart';
import '../api/apiRDeviceDetails.dart';
import '../class/valueDeviceClass.dart';

class ValueProvider extends ChangeNotifier {
  ValueDeviceClass _value = ValueDeviceClass();

  ValueDeviceClass get value => _value;

  void fetchValue() async {
    ApiDeviceDetails response = await RequestDevice();
    Map<String, dynamic> userMap = response.userMap;

    ValueDeviceClass value = ValueDeviceClass();
    value.status = userMap['Status'];
    value.lastReceived = DateTime.parse(userMap['lastReceived']);
    value.deviceName = userMap['Device_name'];
    value.version = userMap['version_running'] == null ? '' : userMap['version_running'];
    value.tem = userMap['lastData']['tem'] == null ? -1 : userMap['lastData']['tem'];
    value.hum = userMap['lastData']['hum'] == null ? -1 : userMap['lastData']['hum'];
    value.vMq2 = userMap['lastData']['mq2'] == null ? -1 : userMap['lastData']['mq2'];
    value.dr1 = userMap['lastData']['dr1'] == null ? -1 : userMap['lastData']['dr1'];
    value.dr2 = userMap['lastData']['dr2'] == null ? -1 : userMap['lastData']['dr2'];
    value.dm1 = userMap['lastData']['dm1'] == null ? -1 : userMap['lastData']['dm1'];
    value.dm2 = userMap['lastData']['dm2'] == null ? -1 : userMap['lastData']['dm2'];
    value.ds1 = userMap['lastData']['ds1'] == null ? -1 : userMap['lastData']['ds1'];
    value.ds2 = userMap['lastData']['ds2'] == null ? -1 : userMap['lastData']['ds2'];
    value.fn1 = userMap['lastData']['fn1'] == null ? -1 : userMap['lastData']['fn1'];
    value.fn2 = userMap['lastData']['fn2'] == null ? -1 : userMap['lastData']['fn2'];
    value.fs1 = userMap['lastData']['fs1'] == null ? -1 : userMap['lastData']['fs1'];
    value.fs2 = userMap['lastData']['fs2'] == null ? -1 : userMap['lastData']['fs2'];
    value.ld1 = userMap['lastData']['ld1'] == null ? -1 : userMap['lastData']['ld1'];
    value.ld2 = userMap['lastData']['ld2'] == null ? -1 : userMap['lastData']['ld2'];
    value.lm1 = userMap['lastData']['lm1'] == null ? -1 : userMap['lastData']['lm1'];
    value.lm2 = userMap['lastData']['lm2'] == null ? -1 : userMap['lastData']['lm2'];
    value.ls1 = userMap['lastData']['ls1'] == null ? -1 : userMap['lastData']['ls1'];
    value.ls2 = userMap['lastData']['ls2'] == null ? -1 : userMap['lastData']['ls2'];
    value.bs = userMap['lastData']['bs'] == null ? -1 : userMap['lastData']['bs'];

    _value = value;
    notifyListeners();
  }

  void startFetching() {
    fetchValue();
    Timer.periodic(Duration(seconds: 10), (timer) {
      fetchValue();
    });
  }
}
