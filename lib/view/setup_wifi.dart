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
  bool get isStreaming => subscription != null;
  List<String> wifiName = [];
  String wifi = "";
  bool shouldCheckCan = true;
  /// Show snackbar.
  void kShowSnackBar(BuildContext context, String message) {
    if (kDebugMode) print(message);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
  Future<void> _startScan(BuildContext context) async {
    // check if "can" startScan
    if (shouldCheckCan) {
      // check if can-startScan
      // final can =
      //     await WiFiScan.instance.canGetScannedResults(askPermissions: true);
      final can = await WiFiScan.instance.canStartScan(askPermissions: true);
      // if can-not, then show error
      if (can != CanStartScan.yes) {
        if (mounted) kShowSnackBar(context, "Cannot start scan: $can");
        return;
      }
    }

    wifiName = [];
    var results = await WiFiScan.instance.getScannedResults();
    setState(() {
      accessPoints = results;
      wifiName = results.map((result) => result.ssid).toList();
    });
    for (var i in accessPoints) {
      wifiName.add(i.ssid);
    }
  }
  void _startListeningToScannedResults() async {
    print("Quét");
    print("Danh sách WiFi: $wifiName");
    wifiName = [];
    var results = await WiFiScan.instance.getScannedResults();
    setState(() {
      accessPoints = results;
      wifiName = results.map((result) => result.ssid).toList();
    });
    for (var i in accessPoints) {
      wifiName.add(i.ssid);
    }
  }

  String _warningName = '', _warningPass = '';
  void _validateAndSend() {
    String textN = name.text.trim();
    String textP = password.text.trim();

    if (textN.isEmpty) {
      setState(() {
        _warningName = 'Please enter some text.';
      });
    } else if (textP.isEmpty) {
      setState(() {
        _warningPass = 'Please enter some text.';
      });
    }
     else {
      // Code to send the text
      setState(() {
        _warningPass = ''; // Clear any previous warnings
      });
      // Add your code to send the text here
      print('Text sent: $_warningPass');
      service();
      AwesomeDialog(
        context: context,
        animType: AnimType.leftSlide,
        headerAnimationLoop: false,
        showCloseIcon: true,
        title: 'Setup Thành Công!',
        desc:
        'Tên Wifi: ${name.text}\nPassword: ${password.text}',
        btnOkOnPress: () {
        },
        btnOkIcon: Icons.check_circle,
        onDismissCallback: (type) {
        },
      ).show();
    }
  }

  @override
  initState() {
    // _startScan(context);
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
          String data_sent = "w:" + name.text + "\tp:" + password.text;
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
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Text("WifiName:"),
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
                      controller: name,
                      decoration: InputDecoration(
                        hintText: 'Name Wifi',
                        errorText: _warningName.isNotEmpty ? _warningName : null,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
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
                        errorText: _warningPass.isNotEmpty ? _warningPass : null,
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
                _validateAndSend();
              },
              child: Text("Sent")),
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
            onPressed: () async => _startScan(context),
            child: Icon(Icons.change_circle_outlined),
          )
        ],
      ),
    );
  }
}
