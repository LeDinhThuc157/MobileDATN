import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smart_home/class/Light.dart';
import 'package:smart_home/class/valueDeviceClass.dart';
import 'package:smart_home/provider/ValueProvider.dart';
import 'package:smart_home/view/loginPage.dart';
import 'package:smart_home/view/scan_device_bt.dart';
import 'package:smart_home/widget/boxDevice.dart';
import '../api/apiChangePassword.dart';
import '../class/Door.dart';
import '../res/constants.dart';
import '../widget/circularButton.dart';
import 'device/controlDoor.dart';
import 'device/controlLight.dart';

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
  Future<void> getValue() async {
    ValueDeviceClass valueDevice = await RequestValue();
    print("Value: ${valueDevice.deviceName} // ${valueDevice.status}");
  }
  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getValue();
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

  bool isContainerVisible = false;
  bool isContainerVisible1 = false;
  bool isContainerVisible2 = false;
  bool isContainerVisible3 = false;

  void _toggleContainerVisibility() {
    setState(() {
      isContainerVisible = !isContainerVisible;
    });
  }
  void _toggleContainerVisibility1() {
    setState(() {
      isContainerVisible1 = !isContainerVisible1;
    });
  }
  void _toggleContainerVisibility2() {
    setState(() {
      isContainerVisible2 = !isContainerVisible2;
    });
  }
  void _toggleContainerVisibility3() {
    setState(() {
      isContainerVisible3 = !isContainerVisible3;
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
              onChanged: (String? value) {
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
                              children: [
                                Image.asset('assets/icons/sun.png',height: 77.2,width: 70,),

                                Column(
                                  children: [
                                    Text('${DateFormat('dd/MM/yyyy').format(provider.value.lastReceived)}'),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                  onPressed: () async {
                                    _toggleContainerVisibility();
                                    if(isContainerVisible){
                                      isContainerVisible1 = false;
                                      isContainerVisible2 = false;
                                      isContainerVisible3 = false;
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 1.0,
                                      ),
                                    ),
                                    child: ClipOval(
                                      child: Image.asset(
                                        'assets/icons/lamp.png',
                                        height: 60,
                                        width: 60,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                              ),
                              TextButton(
                                  onPressed: () async {
                                    _toggleContainerVisibility1();
                                    if(isContainerVisible1){
                                      isContainerVisible = false;
                                      isContainerVisible2 = false;
                                      isContainerVisible3 = false;
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 1.0,
                                      ),
                                    ),
                                    child: ClipOval(
                                      child: Image.asset(
                                        'assets/icons/door.png',
                                        height: 60,
                                        width: 60,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )



                              ),
                              TextButton(
                                  onPressed: () async {
                                    _toggleContainerVisibility2();
                                    if(isContainerVisible2){
                                      isContainerVisible1 = false;
                                      isContainerVisible = false;
                                      isContainerVisible3 = false;
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 1.0,
                                      ),
                                    ),
                                    child: ClipOval(
                                      child: Image.asset(
                                        'assets/icons/fan2.png',
                                        height: 60,
                                        width: 60,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )



                              ),
                              TextButton(
                                  onPressed: () async {
                                    _toggleContainerVisibility3();
                                    if(isContainerVisible3){
                                      isContainerVisible1 = false;
                                      isContainerVisible2 = false;
                                      isContainerVisible = false;
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 1.0,
                                      ),
                                    ),
                                    child: ClipOval(
                                      child: Image.asset(
                                        'assets/icons/siren.png',
                                        height: 60,
                                        width: 60,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )



                              ),
                            ],
                          ),
                        ),
                      ),
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
                            height: 200.0,
                            width: 200.0,
                          ),
                        ),
                        // Transform.translate(
                        //   offset: Offset.fromDirection(getRadiansFromDegree(270),degOneTranslationAnimation.value * 100),
                        //   child: Transform(
                        //     transform: Matrix4.rotationZ(getRadiansFromDegree(rotationAnimation.value))..scale(degOneTranslationAnimation.value),
                        //     alignment: Alignment.center,
                        //     child: TextButton(
                        //         onPressed: () async {
                        //           print("First");
                        //         },
                        //         child: Container(
                        //           height: 50,
                        //           width: 50,
                        //           decoration: BoxDecoration(
                        //             color: Colors.black,
                        //             shape: BoxShape.circle,
                        //             border: Border.all(
                        //               color: Colors.black,
                        //               width: 1.0,
                        //             ),
                        //           ),
                        //           child: ClipOval(
                        //             child: Icon(
                        //               Icons.add,
                        //               color: Colors.white,
                        //             ),
                        //           ),
                        //         )
                        //
                        //
                        //
                        //     ),
                        //   ),
                        // ),
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
                  Positioned(
                    left: 20,
                    bottom: 150,
                    right: 20,
                    child: AnimatedOpacity(
                      opacity: isContainerVisible ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 200),
                      child: Container(
                        width: 380,
                        height: 250,
                        child: Container(
                          child: BoxDevice(
                             provider.value.ld1 == 1,
                             provider.value.ld2 == 1,
                             provider.value.lm1 == 1 ? "Auto" : provider.value.ls1 == 1 ? "On" : "Off",
                             provider.value.lm2 == 1 ? "Auto" : provider.value.ls2 == 1 ? "On" : "Off",
                             'Light 1',
                             'Light 2',
                            'assets/icons/lightbulb.png',
                            ControlLight(
                              light: Light(
                                "Light1",
                                provider.value.lm1.toInt(),
                                provider.value.ls1.toInt(),
                                ''
                              ),
                              index: '1',),
                             ControlLight(
                              light: Light(
                                  "Light2",
                                  provider.value.lm2.toInt(),
                                  provider.value.ls2.toInt(),
                                  ''
                              ),
                              index: '2',),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    bottom: 150,
                    right: 20,
                    child: AnimatedOpacity(
                      opacity: isContainerVisible1 ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 200),
                      child: Container(
                        width: 380,
                        height: 250,
                        child: Container(
                          child: BoxDevice(
                             provider.value.dr1 == 1,
                             provider.value.dr2 == 1,
                             provider.value.dm1 == 1 ? "Auto" : provider.value.ds1 == 1 ? "On" : "Off",
                             provider.value.dm2 == 1 ? "Auto" : provider.value.ds2 == 1 ? "On" : "Off",
                             'Door 1',
                            'Door 2',
                            'assets/icons/doori.png',
                            ControlDoor(
                              door: Door(
                                  "Door 1",
                                  provider.value.dm1.toInt(),
                                  provider.value.ds1.toInt(),
                                  ''
                              ),
                              index: '1',),
                            ControlDoor(
                              door: Door(
                                  "Door 2",
                                  provider.value.dm2.toInt(),
                                  provider.value.ds2.toInt(),
                                  ''
                              ),
                              index: '1',),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    bottom: 150,
                    right: 20,
                    child: AnimatedOpacity(
                      opacity: isContainerVisible2 ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 200),
                      child: Container(
                        width: 380,
                        height: 250,
                        child: Container(
                          child: BoxDevice(
                            provider.value.fn1 == 1,
                            provider.value.fn2 == 1,
                            provider.value.fs1.toInt().toString(),
                            provider.value.fs2.toInt().toString(),
                            'Fan 1',
                            'Fan 2',
                            'assets/icons/fan.png',
                            ControlDoor(
                            door: Door(
                                "Door 1",
                                provider.value.dm2.toInt(),
                                provider.value.ds2.toInt(),
                                ''
                            ),
                            index: '1',),
                            ControlDoor(
                            door: Door(
                                "Door 2",
                                provider.value.dm2.toInt(),
                                provider.value.ds2.toInt(),
                                ''
                            ),
                            index: '1',),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    bottom: 120,
                    right: 20,
                    child: AnimatedOpacity(
                      opacity: isContainerVisible3 ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 200),
                      child: Container(
                        width: 380,
                        height: 300,
                        child: Container(
                          child: Text("Số 4"),
                        ),
                      ),
                    ),
                  ),

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

  Widget BoxDevice(bool fdevice1, bool fdevice2, String vdevice1, String vdevice2, String ndevice1, String ndevice2, String image, Widget page1, Widget page2) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black12, // Màu nền của container
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          fdevice1 ? Container(
            margin: EdgeInsets.only(top: 10,bottom: 10,right: 25,left: 25),
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
            child: TextButton(
                onPressed: (){
                  print("Hello1");
                  // Navigator.push(
                  //     context, MaterialPageRoute(builder: (context) => widget.page1));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: Image.asset(image,height: 40,width: 40,),
                    ),
                    SizedBox(),
                    Container(
                      width: 230,
                      child: Column(
                        children: [
                          Text(ndevice1),
                          Text("Status: ${vdevice1}")
                        ],
                      ),
                    ),
                    Container()
                  ],
                )
            ),
          ) : SizedBox(),
          fdevice2 ? Container(
            margin: EdgeInsets.only(top: 10,bottom: 10,right: 25,left: 25),
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
            child: TextButton(
                onPressed: (){
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => page2));
                },
                child: Row(
                  children: [
                    Container(
                      child: Image.asset(image,height: 40,width: 40,),
                    ),
                    Container(
                      width: 230,
                      child: Column(
                        children: [
                          Text(ndevice2),
                          Text("Status: ${vdevice2}")
                        ],
                      ),
                    ),
                    Container()
                  ],
                )
            ),
          ) : SizedBox(),
          fdevice1 && fdevice2 ? SizedBox() : Container(
            margin: EdgeInsets.only(top: 10,bottom: 10),
            width: 100,
            decoration: BoxDecoration(
              color: seekBarLightColor,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: TextButton(
                onPressed: (){
                },
                child: Text("Add",style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                ),)
            ),
          )
        ],
      ),
    );
  }
}
