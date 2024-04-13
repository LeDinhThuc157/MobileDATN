import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:smart_home/bluetooth/bluetooth_on_off.dart';
import 'package:smart_home/view/setup_wifi.dart';

class ScanBT extends StatefulWidget {

  ScanBT({super.key});

  @override
  State<ScanBT> createState() => _ScanBTState();
}

class _ScanBTState extends State<ScanBT> {
  List<ScanResult> list_devcice = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scan"),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.red,
            height: 40,
            width: 100,
            child: TextButton(
              onPressed: () async {
                Bluetooth bluetooth = await On_Off();
                setState(() {
                  list_devcice = bluetooth.listResult;
                });
              },
              child: Text("Scan",style: TextStyle(color: Colors.black),),
            ),
          ),
          list_devcice == [] ? Container(child: Text("Không có"),) : Container(
            height: 500,
            child: ListView.builder(
                itemCount: list_devcice.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      TextButton(
                        onPressed: () {
                          connectToDevice(list_devcice[index].device);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Setup_Wifi(
                                  device: list_devcice[index].device,
                                )),
                          );
                        },
                        child: Row(
                          children: [
                            Container(
                              child: Icon(Icons.bluetooth),
                            ),
                            Column(
                              children: [
                                Container(
                                  child: Text(
                                      "${list_devcice?[index].device.name}"),
                                ),
                                Container(
                                  child: Text(
                                      "${list_devcice?[index].device.id}"),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  );
                }),
          ),
        ],
      )
    );
  }
}
