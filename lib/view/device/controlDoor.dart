// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:smart_home/class/Door.dart';
// import 'package:smart_home/class/Light.dart';
// import 'package:smart_home/provider/ValueProvider.dart';
// import 'package:smart_home/view/homePage.dart';
//
// import '../../api/apiControlDevice.dart';
// import '../../api/apiDeleteDevice.dart';
//
// class ControlDoor extends StatefulWidget {
//   Door door;
//   final String index;
//   ControlDoor({super.key, required this.door, required this.index});
//
//   @override
//   State<ControlDoor> createState() => _ControlDoorState();
// }
//
// class _ControlDoorState extends State<ControlDoor> {
//
//   void setvalue(ControlDoor widget){
//     print("Mode: ${widget.door.sOn_Off } : ${widget.door.sAuto}");
//     if(widget.door.sAuto){
//       widget.door.status = "Auto";
//     }else{
//       if(widget.door.sOn_Off){
//         widget.door.status = "Online";
//       }else{
//         widget.door.status = "Offline";
//       }
//     }
//     print("Status: ${widget.door.status}");
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     setvalue(widget);
//     return ChangeNotifierProvider(
//       create: (context) => ValueProvider()..startFetching(),
//       child: Scaffold(
//         body: Consumer<ValueProvider> (
//           builder: (context, provider, _){
//             return Container(
//               height: size.height,
//               width: size.width,
//               child: Column(
//                 children: [
//                   Container(
//                     height: 200,
//                     width: 300,
//                     margin: EdgeInsets.only(top: 150),
//                     decoration: BoxDecoration(
//                       color: Colors.white, // Màu nền của container
//                       borderRadius: BorderRadius.circular(10), // Độ cong của góc
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.5), // Màu và độ trong suốt của bóng đổ
//                           spreadRadius: 2, // Độ rộng mà bóng đổ lan ra
//                           blurRadius: 7, // Độ mờ của bóng đổ
//                           offset: Offset(0, 3), // Độ dịch chuyển của bóng đổ theo trục X và trục Y
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       children: [
//                         Container(
//                           height: 40,
//                         ),
//                         Image.asset('assets/icons/doori.png',height: 50,width: 50,),
//                         Text("Control ${widget.door.name}",
//                           style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold
//                           ),),
//                         Container(
//                           height: 40,
//                         ),
//                         Text(
//                           "Status: ${widget.door.status}",
//                           style: TextStyle(
//                               fontSize: 24
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                   Container(
//                     child: Column(
//                       children: [
//                         Container(
//                           margin: EdgeInsets.only(left: 20,right: 20,top: 70),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Container(
//                                 child: Text("Turn On/Off: "),
//                                 width: 100,
//                               ),
//                               GestureDetector(
//                                 onTap: () async {
//                                   ApiControlDevice control = await ControlDevice(widget.index, "cdoor", "1");
//                                   setState(() {
//                                     widget.door.sOn_Off = true;
//                                     setvalue(widget);
//                                   });
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(
//                                       backgroundColor: Colors.green, // Màu xanh cho thành công
//                                       content: Text('Control Door On!'),
//                                     ),
//                                   );
//                                 },
//                                 child: Container(
//                                     height: 20,
//                                     width: 50,
//                                     decoration: BoxDecoration(
//                                       color: Colors.green, // Màu nền của container
//                                       borderRadius: BorderRadius.circular(10), // Độ cong của góc
//                                     ),
//                                     child: Center(
//                                       child: Text("On", style: TextStyle(color: Colors.white),),
//                                     )
//                                 ),
//                               ),
//                               GestureDetector(
//                                 onTap: () async {
//                                   ApiControlDevice control = await ControlDevice(widget.index, "cdoor", "0");
//                                   setState(() {
//                                     widget.door.sOn_Off = false;
//                                     setvalue(widget);
//                                   });
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(
//                                       backgroundColor: Colors.red, // Màu xanh cho thành công
//                                       content: Text('Control Door Off!'),
//                                     ),
//                                   );
//                                 },
//                                 child: Container(
//                                     height: 20,
//                                     width: 50,
//                                     decoration: BoxDecoration(
//                                       color: Colors.red, // Màu nền của container
//                                       borderRadius: BorderRadius.circular(10), // Độ cong của góc
//                                     ),
//                                     child: Center(
//                                       child: Text("Off", style: TextStyle(color: Colors.white),),
//                                     )
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Container(
//                           margin: EdgeInsets.all(20),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Container(
//                                 child: Text("Auto Mode:"),
//                                 width: 100,
//                               ),
//                               GestureDetector(
//                                 onTap: () async {
//                                   ApiControlDevice control = await ControlDevice(widget.index, "autodoor", "1");
//                                   setState(() {
//                                     widget.door.sAuto = true;
//                                     setvalue(widget);
//                                   });
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(
//                                       backgroundColor: Colors.green, // Màu xanh cho thành công
//                                       content: Text('Control AutoDoor On!'),
//                                     ),
//                                   );
//                                 },
//                                 child: Container(
//                                     height: 20,
//                                     width: 50,
//                                     decoration: BoxDecoration(
//                                       color: Colors.green, // Màu nền của container
//                                       borderRadius: BorderRadius.circular(10), // Độ cong của góc
//                                     ),
//                                     child: Center(
//                                       child: Text("On", style: TextStyle(color: Colors.white),),
//                                     )
//                                 ),
//                               ),
//                               GestureDetector(
//                                 onTap: () async {
//                                   ApiControlDevice control = await ControlDevice(widget.index, "autodoor", "0");
//                                   setState(() {
//                                     widget.door.sAuto = false;
//                                     setvalue(widget);
//                                   });
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(
//                                       backgroundColor: Colors.red, // Màu xanh cho thành công
//                                       content: Text('Control AutoDoor Off!'),
//                                     ),
//                                   );
//                                 },
//                                 child: Container(
//                                     height: 20,
//                                     width: 50,
//                                     decoration: BoxDecoration(
//                                       color: Colors.red, // Màu nền của container
//                                       borderRadius: BorderRadius.circular(10), // Độ cong của góc
//                                     ),
//                                     child: Center(
//                                       child: Text("Off", style: TextStyle(color: Colors.white),),
//                                     )                                ),
//                               ),
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                   Container(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         TextButton(
//                             onPressed: (){
//                               Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
//                             },
//                             child: Container(
//                               child: Text(
//                                   "Back"
//                               ),
//                             )
//                         ),
//                         TextButton(
//                             onPressed: () async {
//                               ApiDeleteDevice add = await DeleteDevice(widget.index, "rdoor");
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(
//                                   backgroundColor: Colors.green, // Màu xanh cho thành công
//                                   content: Text('Delete successfully!'),
//                                 ),
//                               );
//                               Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
//                               // if(add.statusResponse == 200){
//                               //   ScaffoldMessenger.of(context).showSnackBar(
//                               //     SnackBar(
//                               //       backgroundColor: Colors.green, // Màu xanh cho thành công
//                               //       content: Text('Delete successfully!'),
//                               //     ),
//                               //   );
//                               //   Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
//                               // }else{
//                               //   ScaffoldMessenger.of(context).showSnackBar(
//                               //     SnackBar(
//                               //       backgroundColor: Colors.red, // Màu xanh cho thành công
//                               //       content: Text('Delete fail!'),
//                               //     ),
//                               //   );
//                               // }
//                             },
//                             child: Container(
//                               child: Text(
//                                   "Delete"
//                               ),
//                             )
//                         ),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
