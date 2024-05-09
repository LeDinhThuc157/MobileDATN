import 'package:flutter/material.dart';
import 'package:smart_home/class/Light.dart';
import 'package:smart_home/class/Light_1.dart';
import 'package:smart_home/class/Light_2.dart';
import 'package:smart_home/class/valueDeviceClass.dart';
import 'package:smart_home/view/device/controlLight.dart';

import '../../api/apiAddDevice.dart';

class ListLight extends StatefulWidget {
  late ValueDeviceClass valueDeviceClass;
  ListLight({super.key, required this.valueDeviceClass});

  @override
  State<ListLight> createState() => _ListLightState();
}

class _ListLightState extends State<ListLight> {
  List<Light> lLight = [];
  bool sAuto1 = false;
  bool sOn_Off1 = false;
  String status1 = '';
  bool sAuto2 = false;
  bool sOn_Off2 = false;
  String status2 = '';

  void setupValue(ValueDeviceClass valueDeviceClass){
    sAuto1 = valueDeviceClass.lm1 == 1;
    sOn_Off1 = valueDeviceClass.ls1 == 1;
    status1 = sAuto1 ? "Auto" : sOn_Off1 ? "On" : "Off";
    if(valueDeviceClass.ld1 == 1) lLight.add(Light_1("Light 1",sAuto1, sOn_Off1, status1));

    sAuto2 = valueDeviceClass.lm2 == 1;
    sOn_Off2 = valueDeviceClass.ls2 == 1;
    status2 = sAuto2 ? "Auto" : sOn_Off2 ? "On" : "Off";
    if(valueDeviceClass.ld2 == 1) lLight.add(Light_2("Light 2",sAuto2, sOn_Off2, status2));

  }
  // @override
  // void initState(){
  //   setupValue(ListLight(valueDeviceClass: null,));
  // }
  @override
  Widget build(BuildContext context) {
    setupValue(widget.valueDeviceClass);
    return Scaffold(
      appBar: AppBar(
        title: Text("List Light"),
        actions: [
          IconButton(
              onPressed: (){
                showDialog(context: context,
                  builder: (BuildContext context) {
                    TextEditingController stt = TextEditingController();
                    return AlertDialog(
                      title: Text('Add Lìght'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          TextField(
                            controller: stt,
                            decoration: InputDecoration(labelText: 'Enter serial number device'),
                          ),
                        ],
                      ),
                      actions: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            ApiAddDevice add = await AddDevice(stt.text, "alight");
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.green, // Màu xanh cho thành công
                                content: Text('Add successfully!'),
                              ),
                            );
                            // if(add.statusResponse == 200){
                            //   ScaffoldMessenger.of(context).showSnackBar(
                            //     SnackBar(
                            //       backgroundColor: Colors.green, // Màu xanh cho thành công
                            //       content: Text('Add successfully!'),
                            //     ),
                            //   );
                            // }else{
                            //   ScaffoldMessenger.of(context).showSnackBar(
                            //     SnackBar(
                            //       backgroundColor: Colors.red, // Màu xanh cho thành công
                            //       content: Text('Add fail!'),
                            //     ),
                            //   );
                            // }
                          },
                          child: Text('Save'),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.add),
              tooltip: 'Open add light',
          )
        ],
      ),
      body: ListView.builder(
        itemCount : lLight.length,
        itemBuilder: (context, snapshot){
          return Container(
            margin: EdgeInsets.all(20),
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white, // Màu nền của container
              borderRadius: BorderRadius.circular(10), // Độ cong của góc
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5), // Màu và độ trong suốt của bóng đổ
                  spreadRadius: 5, // Độ rộng mà bóng đổ lan ra
                  blurRadius: 7, // Độ mờ của bóng đổ
                  offset: Offset(0, 3), // Độ dịch chuyển của bóng đổ theo trục X và trục Y
                ),
              ],
            ),
            child: GestureDetector (
                      onTap: (){
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => ControlLight(light: lLight[snapshot], index: "${snapshot + 1}",)));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            child: Image.asset("assets/icons/lightbulb.png",height: 40,width: 40,),
                          ),
                          SizedBox(),
                          Container(
                            width: 230,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(lLight[snapshot].name),
                                Text("Status: ${lLight[snapshot].status}")
                              ],
                            ),
                          ),
                          Container()
                        ],
                      )
                  ),
          );
        },
      ),
    );
  }
}
