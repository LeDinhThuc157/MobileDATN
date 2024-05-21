
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../res/vaule.dart';
import '../view/homePage.dart';
import '../view/listRoom.dart';

class ApiLogin {
  final Map<String, dynamic> userMap;
  final int statusResponse;
  final String? error;

  ApiLogin(this.userMap, this.statusResponse, this.error);
}
  Future<dynamic> login(String username, String password) async {
    // Logic xác thực đăng nhập
    final dio = Dio();
    try{
      Response response = await dio.post(
          addressLogin,
          options: Options(
            headers: {
              "Content-type": "application/json; charset=utf-8",
            },
          ),
          data:jsonEncode({
            "username": "${username.toString()}",
            "password": "${password.toString()}"
          })
      );
      Map<String, dynamic> userMap = jsonDecode(response.toString());
      int statusResponse = response.statusCode!;
      return ApiLogin(userMap, statusResponse,'');
    }catch(e){
      String error = e.toString();
      print("AXC: $error");
      if(error == "FormatException: Unexpected character (at character 1)\nAccount not exist\n^\n"){
        error = "Tài khoản không tồn tại";
      }else{
        if(error == "FormatException: Unexpected character (at character 1)\nIncorrect password\n^\n"){
          error = "Sai mật khẩu";
        }else{
          error = "Không có kết nỗi!";
        }
      }
      return ApiLogin({}, -1,error);
    }
  }

  Future<dynamic> checkTokenKey(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String storedTokenKey = prefs.getString('tokenKey') ?? '';
  if (storedTokenKey.isNotEmpty) {
    // Nếu có token key, gửi yêu cầu đến server để xác thực
    Response response = await Dio().post(
      addressLogin,
      options: Options(
        headers: {
          "Content-type": "application/json; charset=utf-8",
          "Authorization": "Bearer $storedTokenKey",
        },
      ),
    );
    if (response.statusCode == 200) {
      // Nếu xác thực thành công, điều hướng người dùng đến trang chính
      // Nếu sử dụng MaterialApp, có thể sử dụng Navigator.pushReplacement thay vì push
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ListRoom()),
      );
    }
  }
}

