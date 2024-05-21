import 'package:smart_home/class/valueDeviceClass.dart';

class ListDevice{
  late List<ValueDeviceClass> listDevice;
  ListDevice() {
    // Khởi tạo listDevice với một danh sách rỗng hoặc một danh sách cụ thể
    listDevice = [];
  }
  ValueDeviceClass search (String device_id){
    ValueDeviceClass valueDeviceClass = new ValueDeviceClass();
    for(var v in listDevice){
      if(v.device_id == device_id) valueDeviceClass = v;
    }
    return valueDeviceClass;
  }
}