import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../res/vaule.dart';

class ApiDeviceDetails{
  final Map<String, dynamic> userMap;
  final int statusResponse;
  final String? error;

  ApiDeviceDetails(this.userMap, this.statusResponse, this.error);
}
Future<dynamic> RequestDevice() async {
  final dio = Dio();

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String storedTokenKey = prefs.getString('tokenKey') ?? '';
  try{
    Response response = await dio.post(
        addressReadDeviceDetails,
        options: Options(
          headers: {
            "Content-type": "application/json; charset=utf-8",
            "Authorization": "Bearer $storedTokenKey",
          },
        ),
    );
    Map<String, dynamic> userMap = jsonDecode(response.toString());
    int statusResponse = response.statusCode!;
    return ApiDeviceDetails(userMap, statusResponse, '');
  }catch(e){
    String error = e.toString();
    if(error == "FormatException: Unexpected character (at character 1)\nAccount not exist\n^\n"){
      error = "Tài khoản không tồn tại";
    }
    else{
      error = "Không có kết nỗi!";
    }
    return ApiDeviceDetails({}, -1,error);
  }
}