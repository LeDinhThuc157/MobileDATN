import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../res/vaule.dart';

class ApiChangePassword{

  final String? error;
  final int? status;

  ApiChangePassword(this.error, this.status);
}

Future<dynamic> featureChangePassword(String oldPassWord, String newPassWord) async {
  final dio = Dio();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String storedTokenKey = prefs.getString('tokenKey') ?? '';
  try{
    Response response = await dio.post(
        addressChangePass,
        options: Options(
          headers: {
            "Content-type": "application/json; charset=utf-8",
            "Authorization": "Bearer $storedTokenKey",
          },
        ),
        data:jsonEncode({
          "password": "${oldPassWord}",
          "newpassword": "${newPassWord}"
        })
    );
    Map<String, dynamic> userMap = jsonDecode(response.toString());
    int statusResponse = response.statusCode!;
    if(statusResponse == 200){
      return ApiChangePassword("",statusResponse);
    }
    else{
      return ApiChangePassword('Không thành công!',statusResponse);
    }
  }catch(e){
    String error = e.toString();
    if(error == "FormatException: Unexpected character (at character 1)\nAccount not exist\n^\n"){
      error = "Tài khoản không tồn tại";
    }else if(error == "FormatException: Unexpected character (at character 1)\nMật khẩu cũ sai!\n^\n"){
      error = "Mật khẩu cũ sai!";
    }else if(error == "FormatException: Unexpected character (at character 1)\nMật khẩu mới trùng lặp!\n^\n"){
      error = "Mật khẩu mới trùng lặp!";
    }
    return ApiChangePassword(error,-1);
  }
}