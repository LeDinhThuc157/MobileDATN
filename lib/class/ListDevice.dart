import 'package:smart_home/class/valueDeviceClass.dart';

class ListDevice{
  late List<ValueDeviceClass> listDevice;
  ListDevice() {
    // Khởi tạo listDevice với một danh sách rỗng hoặc một danh sách cụ thể
    listDevice = [];
  }
  ValueDeviceClass search (String device_id){
    ValueDeviceClass valueDeviceClass = new ValueDeviceClass(
      device_id: '',
      status: false,
      lastReceived: DateTime.now(),
      deviceName: '',
      version: '1.0.0',
      tem: 0,
      hum: 0,
      vMq2: 0,
      dr1: 0,
      dm1: 0,
      ds1: 0,
      dr2: 0,
      dm2: 0,
      ds2: 0,
      fn1: 0,
      fs1: 0,
      fn2: 0,
      fs2: 0,
      ld1: 0,
      lm1: 0,
      ls1: 0,
      ld2: 0,
      lm2: 0,
      ls2: 0,
      bs: 0,
    );
    for(var v in listDevice){
      if(v.device_id == device_id) valueDeviceClass = v;
    }
    return valueDeviceClass;
  }
}