import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_home/class/Light.dart';
import 'package:smart_home/provider/ValueProvider.dart';

import '../../api/apiControlDevice.dart';

class ControlLight extends StatefulWidget {
  Light light;
  final String index;
  ControlLight({super.key, required this.light, required this.index});

  @override
  State<ControlLight> createState() => _ControlLightState();
}

class _ControlLightState extends State<ControlLight> {

  void setvalue(ControlLight widget){
    widget.light.sAuto == 1 ? widget.light.status == "Auto" : widget.light.sOn_Off == 1 ? widget.light.status = "Online" : widget.light.status = "Offline";
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isOn_Off = widget.light.sOn_Off == 1 ?  true : false;
    bool isOAuto = widget.light.sAuto == 1 ? true : false;
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
                      Text("Control ${widget.light.name}"),
                      Text(
                          "Status: ${widget.light.status}"
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
                                    ApiControlDevice control = await ControlDevice(widget.index, "clight", mode);
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
                                    ApiControlDevice control = await ControlDevice(widget.index, "autolight", mode);
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
                          onPressed: (){},
                          child: Container(
                            child: Text(
                                "Back"
                            ),
                          )
                      ),
                      TextButton(
                          onPressed: (){},
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
