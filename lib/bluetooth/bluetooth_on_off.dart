import 'dart:io';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class Bluetooth{
  List<ScanResult> listResult;

  Bluetooth(this.listResult);

}
Future<Bluetooth> On_Off() async {
  List<ScanResult> listResult = [];
  try{
    if (await FlutterBluePlus.isSupported == false) {
      print("Bluetooth not supported by this device");
      return Bluetooth([]);
    }
    FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) async {
      print("State: $state");
      if (state == BluetoothAdapterState.on) {
        // Bắt đầu quét các thiết bị Bluetooth
        FlutterBluePlus.startScan(timeout: Duration(seconds: 4));
        // Lắng nghe sự kiện khi tìm thấy thiết bị mới
        FlutterBluePlus.scanResults.listen((results) {
          for (ScanResult result in results) {
            print('Found device: ${result.device.name} (${result.device.id})');
            // Kiểm tra xem có phải là ESP32 không
            listResult = results;
          }
        });
      } else {
        // show an error to the user, etc
      }
    });
    if (Platform.isAndroid) {
      await FlutterBluePlus.turnOn();
    }
    print("Complete: $listResult");
    return Bluetooth(listResult);
  }catch(e){
    print(e);
    return Bluetooth([]);
  }
}

void connectToDevice(BluetoothDevice device) async {
  await device.connect();
}

