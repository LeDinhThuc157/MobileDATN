import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_home/class/Light.dart';
import 'package:smart_home/class/valueDeviceClass.dart';
import 'package:smart_home/provider/ValueProvider.dart';
import 'package:smart_home/view/device/listDoor.dart';
import 'package:smart_home/view/device/listLight.dart';
import 'package:smart_home/view/loginPage.dart';
import 'package:smart_home/view/scan_device_bt.dart';
import 'package:smart_home/view/viewHistory.dart';
import 'package:smart_home/widget/boxDevice.dart';
import '../api/apiChangePassword.dart';
import '../class/Door.dart';
import '../res/constants.dart';
import '../widget/circularButton.dart';
import 'device/controlDoor.dart';
import 'device/controlLight.dart';
import 'device/listFant.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  var animationController;
  var degOneTranslationAnimation,degTwoTranslationAnimation,degThreeTranslationAnimation;
  var rotationAnimation;

  TextEditingController oldpassword = TextEditingController();
  TextEditingController newpassword = TextEditingController();

  double getRadiansFromDegree(double degree) {
    double unitRadian = 57.295779513;
    return degree / unitRadian;
  }


  @override
  void dispose() {
    animationController.dispose();
    // super.dispose();
  }
  String _savedValue = "";
  @override
  void initState() {
    animationController = AnimationController(vsync: this,duration: Duration(milliseconds: 250));
    degOneTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(tween: Tween<double >(begin: 0.0,end: 1.2), weight: 75.0),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 1.2,end: 1.0), weight: 25.0),
    ]).animate(animationController);
    degTwoTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(tween: Tween<double >(begin: 0.0,end: 1.4), weight: 55.0),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 1.4,end: 1.0), weight: 45.0),
    ]).animate(animationController);
    degThreeTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(tween: Tween<double >(begin: 0.0,end: 1.75), weight: 35.0),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 1.75,end: 1.0), weight: 65.0),
    ]).animate(animationController);
    rotationAnimation = Tween<double>(begin: 180.0,end: 0.0).animate(CurvedAnimation(parent: animationController
        , curve: Curves.easeOut));
    super.initState();
    animationController.addListener((){
      setState(() {

      });
    });

  }


  Future<String> getCurrentTime() async {
    var now = DateTime.now();
    var formatter = DateFormat('HH:mm:ss');
    String formattedTime = formatter.format(now);
    return formattedTime;
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ChangeNotifierProvider(
        create: (context) => ValueProvider()..startFetching(),
        child: Scaffold(
        appBar: AppBar(
          title: Text("Home"),
          actions: [
            DropdownButton<String>(
              icon: Icon(Icons.menu),
              menuMaxHeight: 200,
              padding: EdgeInsets.only(right: 20), // Đặt độ nâng của drop-down menu
              onChanged: (String? value) async {
                if(value == 'Change Password'){
                  showDialog(context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Change Password'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            TextField(
                              controller: oldpassword,
                              decoration: InputDecoration(labelText: 'Enter Old Password'),
                              obscureText: true, // Ẩn mật khẩu nhập vào
                            ),
                            TextField(
                              controller: newpassword,
                              decoration: InputDecoration(labelText: 'Enter New Password'),
                              obscureText: true, // Ẩn mật khẩu nhập vào
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
                              ApiChangePassword changePass = await featureChangePassword(oldpassword.text,newpassword.text);
                              if(changePass.status == 200){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.green, // Màu xanh cho thành công
                                    content: Text('Password changed successfully!'),
                                  ),
                                );
                                Navigator.pushReplacement(
                                    context, MaterialPageRoute(builder: (context) => LoginPage()));
                                print("Password changed successfully!");
                              }else{
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.red, // Màu xanh cho thành công
                                    content: Text('${changePass.error}'),
                                  ),
                                );
                                print("${changePass.error}");
                              }

                            },
                            child: Text('Save'),
                          ),
                        ],
                      );
                    },
                  );
                }else if(value == 'Logout'){
                  final SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.setString("tokenKey", "");
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => LoginPage( )));
                }
              },
              items: <String>['Change Password', 'Logout']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        ),

        body: Consumer<ValueProvider>(
          builder: (context, provider, _){

            int countLight = 0, countDoor = 0, countFan = 0;
            if(provider.value.ld1 == 1 && provider.value.ld2 == 1) countLight = 2;
            else if(provider.value.ld1 != 1 && provider.value.ld2 == 1) countLight = 1;
            else if(provider.value.ld1 == 1 && provider.value.ld2 != 1) countLight = 1;
            else countLight = 0;

            if(provider.value.dr1 == 1 && provider.value.dr2 == 1) countDoor = 2;
            else if(provider.value.dr1 != 1 && provider.value.dr2 == 1) countDoor = 1;
            else if(provider.value.dr2 != 1 && provider.value.dr1== 1) countDoor = 1;
            else countDoor = 0;

            if(provider.value.fn1 == 1 && provider.value.fn2 == 1) countFan = 2;
            else if(provider.value.fn1 == 1 && provider.value.fn2 != 1) countFan = 1;
            else if(provider.value.fn2 == 1 && provider.value.fn1 != 1) countFan = 1;
            else countFan = 0;

            return Container(
              width: size.width,
              height: size.height,
              child:  Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(),
                          Container(
                            width: 127, // Đặt chiều rộng container
                            height: 155, // Đặt chiều cao container
                            padding: EdgeInsets.only(top: 10),
                            margin: EdgeInsets.only(top: 20),
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
                            child: Column(
                              children: [
                                Image.asset('assets/icons/sun.png',height: 77.2,width: 70,),

                                Column(
                                  children: [
                                    Text('${DateFormat('dd/MM/yyyy').format(provider.value.lastReceived)}'),
                                    Text('${DateFormat('hh:mm').format(provider.value.lastReceived)}'),
                                    Text('Status: ${provider.value.status}')
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 127, // Đặt chiều rộng container
                            height: 155, // Đặt chiều cao container
                            padding: EdgeInsets.only(top: 20),
                            margin: EdgeInsets.only(top: 20),
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
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(),
                                Text("${provider.value.tem}℃",style: TextStyle(fontSize: 40),),
                                Text('Độ ẩm: ${provider.value.hum}%'),
                                SizedBox(),
                                SizedBox()
                              ],
                            ),
                          ),
                          SizedBox(),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20, top: 30,bottom: 20),
                        child: Text(
                          "Control Device",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          height: 80,
                          width: 350,
                          margin: EdgeInsets.only(bottom: 20),
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
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ListLight(valueDeviceClass: provider.value,)));
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.only(left: 20),
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
                                  child:  Image.asset("assets/icons/lightbulb.png",height: 40,width: 40,),
                                ),
                              ),
                              Container(
                                child: Text(
                                  "Light Connect",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 24
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 20),
                                child: Text(
                                  "${countLight}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 28
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          height: 80,
                          width: 350,
                          margin: EdgeInsets.only(bottom: 20),
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
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ListDoor(valueDeviceClass: provider.value,)));
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.only(left: 20),
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
                                  child:  Image.asset("assets/icons/doori.png",height: 40,width: 40,),
                                ),
                              ),
                              Container(
                                child: Text(
                                  "Door Connect",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 24
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 20),
                                child: Text(
                                  "${countDoor}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 28
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          height: 80,
                          width: 350,
                          margin: EdgeInsets.only(bottom: 20),
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
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ListFan(valueDeviceClass: provider.value,)));
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.only(left: 20),
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
                                  child:  Image.asset("assets/icons/fan.png",height: 40,width: 40,),
                                ),
                              ),
                              Container(
                                child: Text(
                                  "Fan Connect",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 24
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 20),
                                child: Text(
                                  "${countFan}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 28
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Center(
                      //   child: Container(
                      //     height: 80,
                      //     width: 350,
                      //     decoration: BoxDecoration(
                      //       color: Colors.white, // Màu nền của container
                      //       borderRadius: BorderRadius.circular(10), // Độ cong của góc
                      //       boxShadow: [
                      //         BoxShadow(
                      //           color: Colors.grey.withOpacity(0.5), // Màu và độ trong suốt của bóng đổ
                      //           spreadRadius: 5, // Độ rộng mà bóng đổ lan ra
                      //           blurRadius: 7, // Độ mờ của bóng đổ
                      //           offset: Offset(0, 3), // Độ dịch chuyển của bóng đổ theo trục X và trục Y
                      //         ),
                      //       ],
                      //     ),
                      //     child: Row(
                      //       crossAxisAlignment: CrossAxisAlignment.center,
                      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //       children: [
                      //         GestureDetector(
                      //           onTap: (){
                      //
                      //           },
                      //           child: Container(
                      //             padding: EdgeInsets.all(10),
                      //             margin: EdgeInsets.only(left: 20),
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
                      //             child:  Image.asset("assets/icons/lightbulb.png",height: 40,width: 40,),
                      //           ),
                      //         ),
                      //         Container(
                      //           child: Text(
                      //             "Light Connect",
                      //             style: TextStyle(
                      //                 fontWeight: FontWeight.w600,
                      //                 fontSize: 24
                      //             ),
                      //           ),
                      //         ),
                      //         Container(
                      //           margin: EdgeInsets.only(right: 20),
                      //           child: Text(
                      //             "${countLight}",
                      //             style: TextStyle(
                      //                 fontWeight: FontWeight.bold,
                      //                 fontSize: 28
                      //             ),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),

                    ],
                  ),

                  Positioned(
                    bottom: 30,
                    right: 10,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        IgnorePointer(
                          child: Container(
                            margin: EdgeInsets.all(5),
                            color: Colors.transparent,
                            height: 150.0,
                            width: 200.0,
                          ),
                        ),
                        Transform.translate(
                          offset: Offset.fromDirection(getRadiansFromDegree(180),degTwoTranslationAnimation.value * 80),
                          child: Transform(
                            transform: Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value))..scale(degTwoTranslationAnimation.value),
                            alignment: Alignment.center,
                            child: TextButton(
                                onPressed: () async {
                                  print('Second button');
                                  Navigator.push(
                                      context, MaterialPageRoute(builder: (context) => ScanBT()));
                                },
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: ClipOval(
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                  ),
                                )



                            ),
                          ),
                        ),
                        Transform.translate(
                          offset: Offset.fromDirection(getRadiansFromDegree(180),degThreeTranslationAnimation.value * 150),
                          child: Transform(
                            transform: Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value))..scale(degThreeTranslationAnimation.value),
                            alignment: Alignment.center,
                            child: TextButton(
                                onPressed: () async {
                                  Navigator.push(
                                      context, MaterialPageRoute(builder: (context) => ViewHistory()));
                                },
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: ClipOval(
                                    child: Icon(
                                      Icons.question_mark_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //Lamp,
                ],
              ),
            );

          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (animationController.isCompleted) {
              animationController.reverse();
            } else {
              animationController.forward();
            }
          },
          child: Icon(Icons.settings),
        ),
      ),
    );
  }

  // Widget BoxDevice(bool fdevice1, bool fdevice2, String vdevice1, String vdevice2, String ndevice1, String ndevice2, String image, Widget page1, Widget page2) {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       fdevice1 ? Container(
  //         margin: EdgeInsets.only(top: 10,bottom: 10,right: 25,left: 25),
  //         decoration: BoxDecoration(
  //           color: Colors.white, // Màu nền của container
  //           borderRadius: BorderRadius.circular(10), // Độ cong của góc
  //           boxShadow: [
  //             BoxShadow(
  //               color: Colors.grey.withOpacity(0.5), // Màu và độ trong suốt của bóng đổ
  //               spreadRadius: 5, // Độ rộng mà bóng đổ lan ra
  //               blurRadius: 7, // Độ mờ của bóng đổ
  //               offset: Offset(0, 3), // Độ dịch chuyển của bóng đổ theo trục X và trục Y
  //             ),
  //           ],
  //         ),
  //         child: GestureDetector (
  //             onTap: (){
  //               Navigator.push(
  //                   context, MaterialPageRoute(builder: (context) => page1));
  //             },
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               children: [
  //                 Container(
  //                   child: Image.asset(image,height: 40,width: 40,),
  //                 ),
  //                 SizedBox(),
  //                 Container(
  //                   width: 230,
  //                   child: Column(
  //                     children: [
  //                       Text(ndevice1),
  //                       Text("Status: ${vdevice1}")
  //                     ],
  //                   ),
  //                 ),
  //                 Container()
  //               ],
  //             )
  //         ),
  //       ) : SizedBox(),
  //       fdevice2 ? Container(
  //         margin: EdgeInsets.only(top: 10,bottom: 10,right: 25,left: 25),
  //         decoration: BoxDecoration(
  //           color: Colors.white, // Màu nền của container
  //           borderRadius: BorderRadius.circular(10), // Độ cong của góc
  //           boxShadow: [
  //             BoxShadow(
  //               color: Colors.grey.withOpacity(0.5), // Màu và độ trong suốt của bóng đổ
  //               spreadRadius: 5, // Độ rộng mà bóng đổ lan ra
  //               blurRadius: 7, // Độ mờ của bóng đổ
  //               offset: Offset(0, 3), // Độ dịch chuyển của bóng đổ theo trục X và trục Y
  //             ),
  //           ],
  //         ),
  //         child: GestureDetector (
  //             onTap: (){
  //               Navigator.push(
  //                   context, MaterialPageRoute(builder: (context) => page2));
  //             },
  //             child: Row(
  //               children: [
  //                 Container(
  //                   child: Image.asset(image,height: 40,width: 40,),
  //                 ),
  //                 Container(
  //                   width: 230,
  //                   child: Column(
  //                     children: [
  //                       Text(ndevice2),
  //                       Text("Status: ${vdevice2}")
  //                     ],
  //                   ),
  //                 ),
  //                 Container()
  //               ],
  //             )
  //         ),
  //       ) : SizedBox(),
  //       fdevice1 && fdevice2 ? SizedBox() : Container(
  //         margin: EdgeInsets.only(top: 10,bottom: 10),
  //         width: 100,
  //         decoration: BoxDecoration(
  //           color: seekBarLightColor,
  //           borderRadius: BorderRadius.all(
  //             Radius.circular(10),
  //           ),
  //         ),
  //         child: TextButton(
  //             onPressed: (){
  //             },
  //             child: Text("Add",style: TextStyle(
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.bold
  //             ),)
  //         ),
  //       )
  //     ],
  //   );
  // }
}
