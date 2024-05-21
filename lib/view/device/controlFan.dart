// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:smart_home/api/apiDeleteDevice.dart';
// import 'package:smart_home/class/Light.dart';
// import 'package:smart_home/provider/ValueProvider.dart';
// import 'package:smart_home/view/homePage.dart';
//
// import '../../api/apiControlDevice.dart';
// import '../../class/Fan.dart';
//
// class ControFan extends StatefulWidget {
//   Fan fan;
//   final String index;
//   ControFan({super.key, required this.fan, required this.index});
//
//   @override
//   State<ControFan> createState() => _ControFanState();
// }
//
// class _ControFanState extends State<ControFan> {
//
//   // void setvalue(ControFan widget){
//   //   widget.light.sAuto == 1 ? widget.light.status == "Auto" : widget.light.sOn_Off == 1 ? widget.light.status = "Online" : widget.light.status = "Offline";
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return ChangeNotifierProvider(
//         create: (context) => ValueProvider()..startFetching(),
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
//                     color: Colors.white, // Màu nền của container
//                     borderRadius: BorderRadius.circular(10), // Độ cong của góc
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.5), // Màu và độ trong suốt của bóng đổ
//                         spreadRadius: 2, // Độ rộng mà bóng đổ lan ra
//                         blurRadius: 7, // Độ mờ của bóng đổ
//                         offset: Offset(0, 3), // Độ dịch chuyển của bóng đổ theo trục X và trục Y
//                       ),
//                     ],
//                   ),
//                     child: Column(
//                       children: [
//                         Container(
//                           height: 40,
//                         ),
//                         Image.asset('assets/icons/fan.png',height: 50,width: 50,),
//                         Text("Control ${widget.fan.name}",
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold
//                         ),),
//                         Container(
//                           height: 40,
//                         ),
//                         Text(
//                             "Status: ${widget.fan.status}",
//                           style: TextStyle(
//                             fontSize: 24
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                   Container(
//                     child: Column(
//                       children: [
//                         Container(
//                           margin: EdgeInsets.only(left: 20,right: 20,top: 20),
//
//                           child: Center(
//                             child: Text("Control ", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),),
//                           ),
//                           width: 100,
//                         ),
//                         Container(
//                           margin: EdgeInsets.only(left: 20,right: 20,top: 20),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               GestureDetector(
//                                 onTap: () async {
//                                   ApiControlDevice control = await ControlDevice(widget.index, "cfan", "0");
//                                   setState(() {
//                                     widget.fan.status = "0";
//                                   });
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(
//                                       backgroundColor: Colors.green, // Màu xanh cho thành công
//                                       content: Text('Control Fan: 0!'),
//                                     ),
//                                   );
//                                 },
//                                 child: Container(
//                                   height: 40,
//                                   width: 50,
//                                     decoration: BoxDecoration(
//                                       color: Colors.green, // Màu nền của container
//                                       borderRadius: BorderRadius.circular(10), // Độ cong của góc
//                                     ),
//                                     child: Center(
//                                       child: Text("0", style: TextStyle(color: Colors.white, fontSize: 20),),
//                                     )
//                                 ),
//                               ),
//                               GestureDetector(
//                                 onTap: () async {
//                                   ApiControlDevice control = await ControlDevice(widget.index, "cfan", "1");
//                                   setState(() {
//                                     widget.fan.status = "1";
//                                   });
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(
//                                       backgroundColor: Colors.green, // Màu xanh cho thành công
//                                       content: Text('Control Fan: 1!'),
//                                     ),
//                                   );
//                                 },
//                                 child: Container(
//                                     height: 40,
//                                     width: 50,
//                                     decoration: BoxDecoration(
//                                       color: Colors.green, // Màu nền của container
//                                       borderRadius: BorderRadius.circular(10), // Độ cong của góc
//                                     ),
//                                     child: Center(
//                                       child: Text("1", style: TextStyle(color: Colors.white,fontSize: 20),),
//                                     )
//                                 ),
//                               ),
//                               GestureDetector(
//                                 onTap: () async {
//                                   ApiControlDevice control = await ControlDevice(widget.index, "cfan", "2");
//                                   setState(() {
//                                     widget.fan.status = "2";
//                                   });
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(
//                                       backgroundColor: Colors.green, // Màu xanh cho thành công
//                                       content: Text('Control Fan: 2!'),
//                                     ),
//                                   );
//                                 },
//                                 child: Container(
//                                     height: 40,
//                                     width: 50,
//                                     decoration: BoxDecoration(
//                                       color: Colors.green, // Màu nền của container
//                                       borderRadius: BorderRadius.circular(10), // Độ cong của góc
//                                     ),
//                                     child: Center(
//                                       child: Text("2", style: TextStyle(color: Colors.white,fontSize: 20),),
//                                     )
//                                 ),
//                               ),
//                               GestureDetector(
//                                 onTap: () async {
//                                   ApiControlDevice control = await ControlDevice(widget.index, "cfan", "3");
//                                   setState(() {
//                                     widget.fan.status = "3";
//                                   });
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(
//                                       backgroundColor: Colors.green, // Màu xanh cho thành công
//                                       content: Text('Control Fan: 3!'),
//                                     ),
//                                   );
//                                 },
//                                 child: Container(
//                                     height: 40,
//                                     width: 50,
//                                     decoration: BoxDecoration(
//                                       color: Colors.green, // Màu nền của container
//                                       borderRadius: BorderRadius.circular(10), // Độ cong của góc
//                                     ),
//                                     child: Center(
//                                       child: Text("3", style: TextStyle(color: Colors.white,fontSize: 20),),
//                                     )
//                                 ),
//                               ),
//                               GestureDetector(
//                                 onTap: () async {
//                                   ApiControlDevice control = await ControlDevice(widget.index, "cfan", "4");
//                                   setState(() {
//                                     widget.fan.status = "4";
//                                   });
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(
//                                       backgroundColor: Colors.green, // Màu xanh cho thành công
//                                       content: Text('Control Fan: 4!'),
//                                     ),
//                                   );
//                                 },
//                                 child: Container(
//                                     height: 40,
//                                     width: 50,
//                                     decoration: BoxDecoration(
//                                       color: Colors.green, // Màu nền của container
//                                       borderRadius: BorderRadius.circular(10), // Độ cong của góc
//                                     ),
//                                     child: Center(
//                                       child: Text("4", style: TextStyle(color: Colors.white,fontSize: 20),),
//                                     )
//                                 ),
//                               ),
//                               GestureDetector(
//                                 onTap: () async {
//                                   ApiControlDevice control = await ControlDevice(widget.index, "cfan", "5");
//                                   setState(() {
//                                     widget.fan.status = "5";
//                                   });
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(
//                                       backgroundColor: Colors.green, // Màu xanh cho thành công
//                                       content: Text('Control Fan: 5!'),
//                                     ),
//                                   );
//                                 },
//                                 child: Container(
//                                     height: 40,
//                                     width: 50,
//                                     decoration: BoxDecoration(
//                                       color: Colors.green, // Màu nền của container
//                                       borderRadius: BorderRadius.circular(10), // Độ cong của góc
//                                     ),
//                                     child: Center(
//                                       child: Text("5", style: TextStyle(color: Colors.white,fontSize: 20),),
//                                     )
//                                 ),
//                               ),
//
//                             ],
//                           ),
//                         ),
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
//                               ApiDeleteDevice add = await DeleteDevice(widget.index, "rfan");
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(
//                                   backgroundColor: Colors.green, // Màu xanh cho thành công
//                                   content: Text('Delete successfully!'),
//                                 ),
//                               );
//                               Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
//                               // if(add.statusResponse == 200){
//                               //
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
