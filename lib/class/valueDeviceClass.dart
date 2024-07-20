import '../api/apiRDeviceDetails.dart';

class ValueDeviceClass{
  String device_id;
  bool status;
  DateTime lastReceived;
  String deviceName;
  String version;

  double tem;
  double hum;
  double vMq2;
  double dr1;
  double dm1;
  double ds1;
  double dr2;
  double dm2;
  double ds2;

  double fn1;
  double fs1;
  double fn2;
  double fs2;

  double ld1;
  double lm1;
  double ls1;
  double ld2;
  double lm2;
  double ls2;

  double bs;

  ValueDeviceClass({
    required this.device_id,
    required this.status,
    required this.lastReceived,
    required this.deviceName,
    required this.version,
    required this.tem,
    required this.hum,
    required this.vMq2,
    required this.dr1,
    required this.dm1,
    required this.ds1,
    required this.dr2,
    required this.dm2,
    required this.ds2,
    required this.fn1,
    required this.fs1,
    required this.fn2,
    required this.fs2,
    required this.ld1,
    required this.lm1,
    required this.ls1,
    required this.ld2,
    required this.lm2,
    required this.ls2,
    required this.bs,
  });
}

// Future<dynamic> RequestValue() async {
//   ApiDeviceDetails response = await RequestDevice();
//   Map<String, dynamic> userMap = response.userMap;
//   print("$userMap");
//
//   ValueDeviceClass value = new ValueDeviceClass();
//   value.status = userMap['Status'];
//   value.lastReceived = DateTime.parse(userMap['lastReceived']);
//   value.deviceName = userMap['Device_name'];
//   value.version = userMap['version_running'] == null ? '' : userMap['version_running'];
//   value.tem = userMap['lastData']['tem'];
//   value.hum = userMap['lastData']['hum'];
//   value.vMq2 = userMap['lastData']['mq2'];
//   value.dr1 = userMap['lastData']['dr1'];
//   value.dr2 = userMap['lastData']['dr2'];
//   value.dm1 = userMap['lastData']['dm1'];
//   value.dm2 = userMap['lastData']['dm2'];
//   value.ds1 = userMap['lastData']['ds1'];
//   value.ds2 = userMap['lastData']['ds2'];
//   value.fn1 = userMap['lastData']['fn1'];
//   value.fn2 = userMap['lastData']['fn2'];
//   value.fs1 = userMap['lastData']['fs1'];
//   value.fs2 = userMap['lastData']['fs2'];
//   value.ld1 = userMap['lastData']['ld1'];
//   value.ld2 = userMap['lastData']['ld2'];
//   value.lm1 = userMap['lastData']['lm1'];
//   value.lm2 = userMap['lastData']['lm2'];
//   value.ls1 = userMap['lastData']['ls1'];
//   value.ls2 = userMap['lastData']['ls2'];
//   value.bs = userMap['lastData']['bs'];
//   return value;
// }
