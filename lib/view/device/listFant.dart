// import 'package:flutter/material.dart';
// import 'package:smart_home/class/Fan.dart';
// import 'package:smart_home/class/Light.dart';
// import 'package:smart_home/class/Light_1.dart';
// import 'package:smart_home/class/Light_2.dart';
// import 'package:smart_home/class/valueDeviceClass.dart';
// import 'package:smart_home/view/device/controlLight.dart';
//
// import '../../api/apiAddDevice.dart';
// import 'controlFan.dart';
//
// class ListFan extends StatefulWidget {
//   late ValueDeviceClass valueDeviceClass;
//   ListFan({super.key, required this.valueDeviceClass});
//
//   @override
//   State<ListFan> createState() => _ListFanState();
// }
//
// class _ListFanState extends State<ListFan> {
//   List<Fan> lfan = [];
//   int  value1 = 0;
//   String status1 = '';
//   int value2 = 0;
//   String status2 = '';
//
//   void setupValue(ValueDeviceClass valueDeviceClass){
//     status1 = valueDeviceClass.fs1.toInt().toString();
//     if(valueDeviceClass.fn1 == 1) lfan.add(Fan("Fan 1", value1, status1));
//     status2 = valueDeviceClass.fs2.toInt().toString();
//     if(valueDeviceClass.fn2 == 1) lfan.add(Fan("Light 2", value2, status2));
//   }
//   // @override
//   // void initState(){
//   //   setupValue(ListLight(valueDeviceClass: null,));
//   // }
//   @override
//   Widget build(BuildContext context) {
//     setupValue(widget.valueDeviceClass);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("List Fan"),
//         actions: [
//           IconButton(
//             onPressed: (){
//               showDialog(context: context,
//                 builder: (BuildContext context) {
//                   TextEditingController stt = TextEditingController();
//                   return AlertDialog(
//                     title: Text('Add Fan'),
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
//                           ApiAddDevice add = await AddDevice(stt.text, "afan",'');
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
//             },
//             icon: const Icon(Icons.add),
//             tooltip: 'Open add fan',
//           )
//         ],
//       ),
//
//       body: ListView.builder(
//         itemCount : lfan.length,
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
//                       onTap: (){
//                         Navigator.push(
//                             context, MaterialPageRoute(builder: (context) => ControFan(fan: lfan[snapshot], index: "${snapshot + 1}",)));
//                       },
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           Container(
//                             child: Image.asset("assets/icons/fan.png",height: 40,width: 40,),
//                           ),
//                           SizedBox(),
//                           Container(
//                             width: 230,
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(lfan[snapshot].name),
//                                 Text("Status: ${lfan[snapshot].status}")
//                               ],
//                             ),
//                           ),
//                           Container()
//                         ],
//                       )
//                   ),
//           );
//         },
//       ),
//     );
//   }
// }
