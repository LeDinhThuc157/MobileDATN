import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../res/vaule.dart';

class ApiUserAddDevice{
  final Map<String, dynamic> userMap;
  final int statusResponse;
  final String? error;

  ApiUserAddDevice(this.userMap, this.statusResponse, this.error);
}
Future<dynamic> Request(String device_id,String username) async {
  final dio = Dio();

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String storedTokenKey = prefs.getString('tokenKey') ?? '';
  try{
    Response response = await dio.post(
        addressUserAddDevice,
        options: Options(
          headers: {
            "Content-type": "application/json; charset=utf-8",
            "Authorization": "Bearer $storedTokenKey",
          },
        ),
        data:jsonEncode({
          "device_id": device_id,
          "username": username
        })
    );
    Map<String, dynamic> userMap = jsonDecode(response.toString());
    int statusResponse = response.statusCode!;
    return ApiUserAddDevice(userMap, statusResponse, '');
  }catch(e){
    String error = e.toString();
    if(error == "FormatException: Unexpected character (at character 1)\nAccount not exist\n^\n"){
      error = "Tài khoản không tồn tại";
    }else if (error == "FormatException: Unexpected character (at character 1)\nDevice id already exist\n^\n"){
      error = "Device id already exist";
    }
    else{
      error = "Không có kết nỗi!";
    }
    return ApiUserAddDevice({}, -1,error);
  }
}