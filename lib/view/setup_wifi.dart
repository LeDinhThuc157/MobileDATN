import 'dart:async';
import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:wifi_scan/wifi_scan.dart';

class Setup_Wifi extends StatefulWidget {
  final BluetoothDevice? device;

  Setup_Wifi({super.key, this.device});

  @override
  State<Setup_Wifi> createState() => _Setup_WifiState();
}

class _Setup_WifiState extends State<Setup_Wifi> {
  TextEditingController name = new TextEditingController();
  TextEditingController password = new TextEditingController();
  List<WiFiAccessPoint> accessPoints = [];
  StreamSubscription<List<WiFiAccessPoint>>? subscription;
  List<String> wifiName = [];
  String wifi = "";

  void _startListeningToScannedResults() async {
    print("Quét");
    var results = await WiFiScan.instance.getScannedResults();
    setState(() {
      accessPoints = results;
      wifiName = results.map((result) => result.ssid).toList();
    });
    print("Danh sách WiFi: $wifiName");
      wifiName = [];
          for (var i in accessPoints) {
            wifiName.add(i.ssid);
          }
    // final can =
    //     await WiFiScan.instance.canGetScannedResults(askPermissions: true);
    // switch (can) {
    //   case CanGetScannedResults.yes:
    //     Future.delayed(Duration(seconds: 5), () {
    //       subscription =
    //           WiFiScan.instance.onScannedResultsAvailable.listen((results) {
    //             setState(() => accessPoints = results);
    //           });
    //       print("D: $accessPoints");
    //       wifiName = [];
    //       for (var i in accessPoints) {
    //         wifiName.add(i.ssid);
    //       }
    //       print("Hoàn Thành");
    //     });
    //     break;
    //   case CanGetScannedResults.notSupported:
    //   // TODO: Handle this case.
    //   case CanGetScannedResults.noLocationPermissionRequired:
    //   // TODO: Handle this case.
    //   case CanGetScannedResults.noLocationPermissionDenied:
    //   // TODO: Handle this case.
    //   case CanGetScannedResults.noLocationPermissionUpgradeAccuracy:
    //   // TODO: Handle this case.
    //   case CanGetScannedResults.noLocationServiceDisabled:
    //   // TODO: Handle this case.
    // }
  }
  @override
  initState() {
    _startListeningToScannedResults();
    print("initState Called");
  }

  @override
  dispose() {
    super.dispose();
    subscription?.cancel();
  }

  Future<void> service() async {
    List<BluetoothService> services = await widget.device!.discoverServices();
    services.forEach((service) async {
      // do something with service
      var characteristics = service.characteristics;
      for (BluetoothCharacteristic c in characteristics) {
        if (c.properties.write) {
          String data_sent = "w:" + wifi + "\tp:" + password.text;
          List<int> bytes =
              utf8.encode(data_sent); // Chuyển đổi văn bản thành mảng byte
          await c.write(bytes);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ConfigWifi"),
      ),
      body: Column(
        children: [
          NameWifi(),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Text("Password:"),
                SizedBox(width: 8.0), // Để tạo khoảng cách giữa Text và TextField
                Container(
                  width: 200.0, // Chiều rộng cố định của TextField
                  decoration: BoxDecoration(
                    border: Border.all(), // Thêm viền để phân biệt
                    borderRadius: BorderRadius.circular(8.0), // Bo tròn viền
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextField(
                      controller: password,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          TextButton(
              onPressed: () {
                // _startListeningToScannedResults();
                service();
                AwesomeDialog(
                  context: context,
                  animType: AnimType.leftSlide,
                  headerAnimationLoop: false,
                  showCloseIcon: true,
                  title: 'Setup Thành Công!',
                  desc:
                  'Tên Wifi: ${wifi.toString()}\nPassword: ${password.text}',
                  btnOkOnPress: () {
                  },
                  btnOkIcon: Icons.check_circle,
                  onDismissCallback: (type) {
                  },
                ).show();
              },
              child: Text("Sent")),
          // Flexible(
          //   child: Center(
          //     child: accessPoints.isEmpty
          //         ? const Text("NO SCANNED RESULTS")
          //         : ListView.builder(
          //             itemCount: accessPoints.length,
          //             itemBuilder: (context, i) {
          //               return Text("${accessPoints[i].ssid}");
          //             }),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget NameWifi() {
    return Container(
      child: Row(
        children: [
          Text("WifiName:"),
          Container(
            padding: EdgeInsets.only(top: 10),
            child: DropdownMenu<String>(
              width: 200,
              requestFocusOnTap: false,
              menuHeight: 200,
              label: const Text('ChoseWifi'),
              onSelected: (value) {
                setState(() {
                  wifi = value!;
                });
              },
              dropdownMenuEntries: wifiName.map((e) {
                return DropdownMenuEntry<String>(
                  label: e,
                  value: e
                );
              }).toList(),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _startListeningToScannedResults();
              });
            },
            child: Icon(Icons.change_circle_outlined),
          )
        ],
      ),
    );
  }
}
