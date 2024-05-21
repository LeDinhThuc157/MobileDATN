// import 'package:flutter/material.dart';
// import 'package:smart_home/api/apiAddDevice.dart';
// import 'package:smart_home/api/apiDeleteDevice.dart';
// import 'package:smart_home/class/Door.dart';
// import 'package:smart_home/class/Light.dart';
// import 'package:smart_home/class/Light_1.dart';
// import 'package:smart_home/class/Light_2.dart';
// import 'package:smart_home/class/valueDeviceClass.dart';
// import 'package:smart_home/view/device/controlDoor.dart';
// import 'package:smart_home/view/device/controlLight.dart';
//
// import '../../class/Door_1.dart';
// import '../../class/Door_2.dart';
//
// class ListDoor extends StatefulWidget {
//   late ValueDeviceClass valueDeviceClass;
//   ListDoor({super.key,required this.valueDeviceClass});
//
//   @override
//   State<ListDoor> createState() => _ListDoorState();
// }
//
// class _ListDoorState extends State<ListDoor> {
//   List<Door> lDoor = [];
//   bool sAuto1 = false;
//   bool sOn_Off1 = false;
//   String status1 = '';
//   bool sAuto2 = false;
//   bool sOn_Off2 = false;
//   String status2 = '';
//
//   void setupValue(ValueDeviceClass valueDeviceClass){
//     sAuto1 = valueDeviceClass.dm1 == 1;
//     sOn_Off1 = valueDeviceClass.ds1 == 1;
//     status1 = sAuto1 ? "Auto" : sOn_Off1 ? "On" : "Off";
//     if(valueDeviceClass.dr1 == 1) lDoor.add(Door_1("Door 1",sAuto1, sOn_Off1, status1));
//     sAuto2 = valueDeviceClass.dm2 == 1;
//     sOn_Off2 = valueDeviceClass.ds2 == 1;
//     status2 = sAuto2 ? "Auto" : sOn_Off2 ? "On" : "Off";
//     if(valueDeviceClass.dr2 == 1)  lDoor.add(Door_2("Door 2",sAuto2, sOn_Off2, status2));
//   }
//   @override
//   Widget build(BuildContext context) {
//     setupValue(widget.valueDeviceClass);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("List Door"),
//         actions: [
//           IconButton(
//             onPressed: () async {
//               showDialog(context: context,
//                 builder: (BuildContext context) {
//                   TextEditingController stt = TextEditingController();
//                   return AlertDialog(
//                     title: Text('Add Door'),
//                     content: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: <Widget>[
//                         TextField(
//                           controller: stt,
//                           decoration: InputDecoration(labelText: 'Enter serial number device'),
//                         ),
//                       ],
//                     ),
//                     actions: <Widget>[
//                       ElevatedButton(
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                         },
//                         child: Text('Cancel'),
//                       ),
//                       ElevatedButton(
//                         onPressed: () async {
//                           ApiAddDevice add = await AddDevice(stt.text, "adoor",'');
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               backgroundColor: Colors.green, // Màu xanh cho thành công
//                               content: Text('Add successfully!'),
//                             ),
//                           );
//                           // if(add.statusResponse == 200){
//                           //   ScaffoldMessenger.of(context).showSnackBar(
//                           //     SnackBar(
//                           //       backgroundColor: Colors.green, // Màu xanh cho thành công
//                           //       content: Text('Add successfully!'),
//                           //     ),
//                           //   );
//                           // }else{
//                           //   ScaffoldMessenger.of(context).showSnackBar(
//                           //     SnackBar(
//                           //       backgroundColor: Colors.red, // Màu xanh cho thành công
//                           //       content: Text('Add fail!'),
//                           //     ),
//                           //   );
//                           // }
//                         },
//                         child: Text('Save'),
//                       ),
//                     ],
//                   );
//                 },
//               );
//
//             },
//             icon: const Icon(Icons.add),
//             tooltip: 'Open add door',
//           )
//         ],
//       ),
//       body: ListView.builder(
//         itemCount : lDoor.length,
//         itemBuilder: (context, snapshot){
//           return Container(
//             margin: EdgeInsets.all(20),
//             height: 50,
//             decoration: BoxDecoration(
//               color: Colors.white, // Màu nền của container
//               borderRadius: BorderRadius.circular(10), // Độ cong của góc
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.5), // Màu và độ trong suốt của bóng đổ
//                   spreadRadius: 5, // Độ rộng mà bóng đổ lan ra
//                   blurRadius: 7, // Độ mờ của bóng đổ
//                   offset: Offset(0, 3), // Độ dịch chuyển của bóng đổ theo trục X và trục Y
//                 ),
//               ],
//             ),
//             child: GestureDetector (
//                 onTap: (){
//                   Navigator.push(
//                       context, MaterialPageRoute(builder: (context) => ControlDoor(door: lDoor[snapshot], index: "${snapshot + 1}",)));
//                 },
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Container(
//                       child: Image.asset("assets/icons/doori.png",height: 40,width: 40,),
//                     ),
//                     SizedBox(),
//                     Container(
//                       width: 230,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(lDoor[snapshot].name),
//                           Text("Status: ${lDoor[snapshot].status}")
//                         ],
//                       ),
//                     ),
//                     Container()
//                   ],
//                 )
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
