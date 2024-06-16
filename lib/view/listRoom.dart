import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_home/provider/ValueProvider.dart';
import 'package:smart_home/view/scan_device_bt.dart';
import 'package:smart_home/view/viewHistory.dart';

import '../api/apiChangePassword.dart';
import 'homePage.dart';
import 'loginPage.dart';

class ListRoom extends StatefulWidget {
  const ListRoom({super.key});

  @override
  State<ListRoom> createState() => _ListRoomState();
}

class _ListRoomState extends State<ListRoom> with SingleTickerProviderStateMixin {
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
            return Container(
              width: size.width,
              height: size.height,
              child:  Stack(
                children: [
                  ListView.builder(
                      itemCount: provider.value.listDevice.length,
                      itemBuilder: (context, snapshot){
                        return Container(
                          margin: EdgeInsets.all(20),
                          height: 50,
                          child: GestureDetector (
                              onTap: (){
                                Navigator.push(
                                    context, MaterialPageRoute(builder: (context) => HomePage(device_id: provider.value.listDevice[snapshot].device_id,)));
                              },
                              child: Container(
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(width: 20,),
                                    Container(
                                      child: Image.asset("assets/icons/smart-home.png",height: 40,width: 40,),
                                    ),
                                    SizedBox(),
                                    Container(
                                      width: 230,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(provider.value.listDevice[snapshot].device_id),
                                          Text("Status: ${provider.value.listDevice[snapshot].status ? "Online" : "Offline"}")
                                        ],
                                      ),
                                    ),
                                    Container()
                                  ],
                                ),
                              )
                          ),
                        );

                      }
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
          onPressed: () {
            print("Add");
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => ScanBT()));
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
