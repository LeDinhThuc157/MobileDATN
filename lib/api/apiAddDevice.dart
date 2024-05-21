import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../res/vaule.dart';

class ApiAddDevice{
  final Map<String, dynamic> userMap;
  final int statusResponse;
  final String? error;

  ApiAddDevice(this.userMap, this.statusResponse, this.error);
}

Future<dynamic> AddDevice(String index, String aDevice, String device_id) async {
  final dio = Dio();

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String storedTokenKey = prefs.getString('tokenKey') ?? '';
  try{
    Response response = await dio.post(
        addressAddDevice,
        options: Options(
          headers: {
            "Content-type": "application/json; charset=utf-8",
            "Authorization": "Bearer $storedTokenKey",
          },
        ),
        data:jsonEncode({
          "aDevice": aDevice,
          "index": index,
          "device_id" : device_id
        })
    );
    Map<String, dynamic> userMap = jsonDecode(response.toString());
    int statusResponse = response.statusCode!;
    return ApiAddDevice(userMap, statusResponse, '');
  }catch(e){
    String error = e.toString();
    if(error == "FormatException: Unexpected character (at character 1)\nAccount not exist\n^\n"){
      error = "Tài khoản không tồn tại";
    }else{
      if(error == "FormatException: Unexpected character (at character 1)\nDevice not exist\n^\n"){
        error = "Không có loại thiết bị";
      }else{
        error = "Không có kết nỗi!";
      }
    }
    return ApiAddDevice({}, -1,error);
  }
}