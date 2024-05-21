import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_home/class/valueDeviceClass.dart';
import 'package:smart_home/config/size_config.dart';
import 'package:smart_home/provider/ValueProvider.dart';
import 'package:smart_home/provider/home_screen_view_model.dart';
import 'package:smart_home/view/device/listDoor.dart';
import 'package:smart_home/view/device/listLight.dart';
import 'package:smart_home/view/loginPage.dart';
import 'package:smart_home/view/scan_device_bt.dart';
import 'package:smart_home/view/viewHistory.dart';
import '../api/apiChangePassword.dart';
import 'components/dark_container.dart';
import 'device/listFant.dart';

class HomePage extends StatefulWidget {
  final String device_id;
  const HomePage({super.key, required this.device_id});

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
            ValueDeviceClass valueDeviceClass = provider.value.search(widget.device_id);
            // bool isLightOn = false;
            // if(valueDeviceClass.ls1 == 1) isLightOn = true;
            // else isLightOn = false;
            DateTime now = DateTime.now();

            // Xác định hình ảnh hiển thị dựa trên giờ hiện tại
            String imagePath;
            if (now.hour >= 6 && now.hour < 18) {
              imagePath = 'assets/icons/sun.png';
            } else {
              imagePath = 'assets/icons/full-moon.png';
            }
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
                                Image.asset(imagePath,height: 77.2,width: 70,),

                                Column(
                                  children: [
                                    Text('${DateFormat('dd/MM/yyyy').format(valueDeviceClass.lastReceived)}'),
                                    Text('${DateFormat('hh:mm').format(valueDeviceClass.lastReceived)}'),
                                    Text('Status: ${valueDeviceClass.status}')
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
                                Text("${valueDeviceClass.tem}℃",style: TextStyle(fontSize: 40),),
                                Text('Độ ẩm: ${valueDeviceClass.hum}%'),
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
                      Container(
                        height: 500,
                        child: ListView(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 180,
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: DarkContainer(
                                      itsOn: provider.isLight1On,
                                      switchButton: (){
                                        provider.light1Switch(valueDeviceClass.device_id);
                                      },
                                      onTap: () {
                                        // Navigator.of(context).pushNamed(SmartSpeaker.routeName);
                                      },
                                      iconAsset: 'assets/icons/light.svg',
                                      device: 'Light',
                                      deviceCount: 'device 1',
                                      isAuto: provider.isAutoLight1,
                                      switchAuto: () {
                                        provider.light1Auto(valueDeviceClass.device_id);
                                      },
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 180,
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: DarkContainer(
                                      itsOn: provider.isLight2On,
                                      switchButton: (){
                                        provider.light2Switch(valueDeviceClass.device_id);
                                      },
                                      onTap: () {
                                        // Navigator.of(context).pushNamed(SmartSpeaker.routeName);
                                      },
                                      iconAsset: 'assets/icons/light.svg',
                                      device: 'Light',
                                      deviceCount: 'device 2',
                                      isAuto: provider.isAutoLight2,
                                      switchAuto: () {
                                        provider.light2Auto(valueDeviceClass.device_id);
                                    },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 180,
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: DarkContainer(
                                      itsOn: provider.isDoor1ON,
                                      switchButton: (){
                                        provider.door1Switch(valueDeviceClass.device_id);
                                      },
                                      onTap: () {
                                        // Navigator.of(context).pushNamed(SmartSpeaker.routeName);
                                      },
                                      iconAsset: 'assets/icons/door.svg',
                                      device: 'Door',
                                      deviceCount: 'device 1',
                                      isAuto: provider.isAutoDoor1,
                                      switchAuto: () {
                                        provider.door1Auto(valueDeviceClass.device_id);
                                      },
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 180,
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: DarkContainer(
                                      itsOn: provider.isDoor2ON,
                                      switchButton: (){
                                        provider.door2Switch(valueDeviceClass.device_id);
                                      },
                                      onTap: () {
                                        // Navigator.of(context).pushNamed(SmartSpeaker.routeName);
                                      },
                                      iconAsset: 'assets/icons/door.svg',
                                      device: 'Door',
                                      deviceCount: 'device 2',
                                      isAuto: provider.isAutoDoor2,
                                      switchAuto: () {
                                        provider.door2Auto(valueDeviceClass.device_id);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ],
              ),
            );

          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {

          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

}
