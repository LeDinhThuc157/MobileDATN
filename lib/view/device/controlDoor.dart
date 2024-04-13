import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_home/provider/ValueProvider.dart';

import '../../api/apiControlDevice.dart';
import '../../class/Door.dart';

class ControlDoor extends StatefulWidget {
  Door door;
  final String index;
  ControlDoor({super.key, required this.door, required this.index});

  @override
  State<ControlDoor> createState() => _ControlDoorState();
}

class _ControlDoorState extends State<ControlDoor> {

  void setvalue(ControlDoor widget){
    widget.door.sAuto == 1 ? widget.door.status == "Auto" : widget.door.sOn_Off == 1 ? widget.door.status = "Online" : widget.door.status = "Offline";
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isOn_Off = widget.door.sOn_Off == 1 ?  true : false;
    bool isOAuto = widget.door.sAuto == 1 ? true : false;
    setvalue(widget);
    return ChangeNotifierProvider(
      create: (context) => ValueProvider()..startFetching(),
      child: Consumer<ValueProvider> (
        builder: (context, provider, _){
          return Container(
            height: size.height,
            width: size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Column(
                    children: [
                      Text("Control ${widget.door.name}"),
                      Text(
                          "Status: ${widget.door.status}"
                      )
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Text("Turn On/Off"),
                            Switch(
                                value: isOn_Off,
                                onChanged: (value){
                                  setState(() async {
                                    String mode = value ? "1" : "0";
                                    ApiControlDevice control = await ControlDevice(widget.index, "cdoor", mode);
                                    if(control.statusResponse == 200){
                                      isOn_Off = value;
                                      setState(() {
                                        setvalue(widget);
                                      });
                                    }else{
                                      print("Fail Control");
                                    }
                                  });
                                }
                            )
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            Text("Auto Mode"),
                            Switch(
                                value: isOAuto,
                                onChanged: (value){
                                  setState(() async {
                                    String mode = value ? "1" : "0";
                                    ApiControlDevice control = await ControlDevice(widget.index, "autodoor", mode);
                                    if(control.statusResponse == 200){
                                      isOAuto = value;
                                      setState(() {
                                        setvalue(widget);
                                      });
                                    }else{
                                      print("Fail Control");
                                    }
                                  });
                                }
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      TextButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          child: Container(
                            child: Text(
                                "Back"
                            ),
                          )
                      ),
                      TextButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          child: Container(
                            child: Text(
                                "Delete"
                            ),
                          )
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
