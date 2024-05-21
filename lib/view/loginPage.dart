
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/loginApi.dart';
import '../res/constants.dart';
import 'homePage.dart';
import 'listRoom.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String tokenKey = '';

  @override
  void initState() {
    super.initState();
    checkTokenKey(context);
  }

  // Future<void> checkTokenKey() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String storedTokenKey = prefs.getString('tokenKey') ?? '';
  //   if (storedTokenKey.isNotEmpty) {
  //     // Nếu có token key, gửi yêu cầu đến server để xác thực
  //     Response response = await Dio().post(
  //       address,
  //       options: Options(
  //         headers: {
  //           "Content-type": "application/json; charset=utf-8",
  //           "Authorization": "Bearer $tokenKey",
  //         },
  //       ),
  //     );
  //     if (response.statusCode == 200) {
  //       // Nếu xác thực thành công, điều hướng người dùng đến trang chính
  //       // Nếu sử dụng MaterialApp, có thể sử dụng Navigator.pushReplacement thay vì push
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => HomePage()),
  //       );
  //     }
  //   }
  // }

  Future<void>  sentLogin() async {
    ApiLogin response =
    await login(emailController.text, passwordController.text);
    Map<String, dynamic> userMap = response.userMap;

    // print("Phan hoi: ${response.statusResponse}");
    // print("${userMap["tokenkey"]}");
    if (response.statusResponse == 200) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("tokenKey", userMap["tokenkey"]);
      await prefs.setString("username", userMap["username"]);

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ListRoom()));
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    20.0,
                  ),
                ),
              ),
              title: Text(
                "Thông báo lỗi!",
                style: TextStyle(fontSize: 24.0),
              ),
              content: Text("Lỗi xuất hiện: ${response.error}"),
              actions: [
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(),
            SizedBox(),
            Container(
              child: Stack(
                children: [
                  Container(
                    child: Image.asset(
                      "assets/icons/AITHINGS.png",
                      height: 300,
                      width: 315.93 * width,
                    ),
                  ),
                  Positioned(
                    top: 300 - 56, // Đặt top là chiều cao của hình ảnh cộng với một giá trị padding (ở đây là 16)
                    left: 0, // Đặt left là 0 để căn chữ text theo lề trái
                    right: 0, // Đặt right là 0 để căn chữ text theo lề phải
                    child: Container(
                      alignment: Alignment.center, // Căn chữ text theo trung tâm
                      child: Text(
                        "Login into your account",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: black
                        ),
                      ),
                    ),
                  ),
                ],
              ),

            ),
            SizedBox(),
            SizedBox(),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Email Address",style: TextStyle(fontSize: 16.16),),
                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(221, 223, 226, 100),
                          borderRadius: BorderRadius.circular(20.0), // Đặt bán kính để bo tròn góc
                        ),
                        child: TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            border: InputBorder.none, // Loại bỏ khung viền
                            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20), // Điều chỉnh khoảng cách nội dung và viền
                            labelText: "name@gmail.com",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 60, // Điều chỉnh kích thước theo ý của bạn
                          decoration: BoxDecoration(
                            color: orangeColorLogin,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                           // Màu của Container
                          child: Icon(Icons.mail, color: Colors.white), // Biểu tượng bên trong Container
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Password",style: TextStyle(fontSize: 16.16),),
                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(221, 223, 226, 100),
                          borderRadius: BorderRadius.circular(20.0), // Đặt bán kính để bo tròn góc
                        ),
                        child: TextFormField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            border: InputBorder.none, // Loại bỏ khung viền
                            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20), // Điều chỉnh khoảng cách nội dung và viền
                            labelText: "Enter your password",
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 60, // Điều chỉnh kích thước theo ý của bạn
                          decoration: BoxDecoration(
                            color: orangeColorLogin,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          // Màu của Container
                          child: Icon(Icons.lock, color: Colors.white), // Biểu tượng bên trong Container
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              width: 40*width,
              decoration: BoxDecoration(
                color: orangeColorLogin,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              // Màu của Container
              child: TextButton(
                onPressed: (){
                  sentLogin();
                },
                child: Text("Login now", style: TextStyle(fontSize: 16.16,fontWeight: FontWeight.bold,color: lightShadowColor),),
              ), // Biểu tượng bên trong Container
            ),
            SizedBox(),
            SizedBox(),
            SizedBox(),
            SizedBox(),


          ],
        )
        )
  );}
}
