import '../api/apiRDeviceDetails.dart';

class ValueDeviceClass{
  late String device_id;
  late bool status;
  late DateTime lastReceived;
  late String deviceName;
  late String version;

  late double tem;
  late double hum;
  late double vMq2;
  late double dr1; //Cửa 1 hoạt động hay không
  late double dm1; // Chế độ hoạt động của auto của cửa 1
  late double ds1; // Cửa 1 đóng hay mở
  late double dr2; //  Cửa 2 hoạt động hay không
  late double dm2; // Chế độ hoạt động của auto của cửa 2
  late double ds2; // Cửa 2 đóng hay mở

  late double fn1; // Quạt 1 có hoạt động hay không
  late double fs1; // Mức chạy của quạt 1
  late double fn2; // Quạt 1 có hoạt động hay không
  late double fs2; // Mức chạy của quạt 1

  late double ld1; // Đèn 1 hoạt động hay không
  late double lm1; // Chế độ hoạt động của auto của đèn 1
  late double ls1; // Đèn 1 đóng hay mở
  late double ld2; // Đèn 2 hoạt động hay không
  late double lm2; // Chế độ hoạt động của auto của dèn 2
  late double ls2; // Đèn 2 đóng hay mở

  late double bs; // Chế độ còi
  ValueDeviceClass(){
    device_id = '';
    status = false;
    lastReceived = DateTime.now();
    deviceName = '';
    version = '';
    tem = -1;
    hum = -1;
    vMq2 = -1;
    dr1 = -1;
    dr2 = -1;
    dm1 = -1;
    dm2 = -1;
    ds1 = -1;
    ds2 = -1;
    fn1 = -1;
    fn2 = -1;
    fs1 = -1;
    fs2 = -1;
    ld1 = -1;
    ld2 = -1;
    lm1 = -1;
    lm2 = -1;
    ls1 = -1;
    ls2 = -1;
    bs = -1;
  }
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
