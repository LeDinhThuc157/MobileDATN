import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../res/vaule.dart';

class ApiDeleteDevice{
  final Map<String, dynamic> userMap;
  final int statusResponse;
  final String? error;

  ApiDeleteDevice(this.userMap, this.statusResponse, this.error);
}
Future<dynamic> DeleteDevice(String index, String rDevice, String device_id) async {
  final dio = Dio();

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String storedTokenKey = prefs.getString('tokenKey') ?? '';
  try{
    Response response = await dio.post(
        addressDeleteDevice,
        options: Options(
          headers: {
            "Content-type": "application/json; charset=utf-8",
            "Authorization": "Bearer $storedTokenKey",
          },
        ),
        data:jsonEncode({
          "rDevice": rDevice,
          "index": index,
          "device_id":device_id
        })
    );
    Map<String, dynamic> userMap = jsonDecode(response.toString());
    int statusResponse = response.statusCode!;
    return ApiDeleteDevice(userMap, statusResponse, '');
  }catch(e){
    String error = e.toString();
    if(error == "FormatException: Unexpected character (at character 1)\nAccount not exist\n^\n"){
      error = "Tài khoản không tồn tại";
    }else if(error == "FormatException: Unexpected character (at character 1)\nDelete Fan Fail!\n^\n"){
      error = "Xóa quạt thất bại";
    }
    else if(error == "FormatException: Unexpected character (at character 1)\nDelete Door Fail!\n^\n"){
      error = "Xóa cửa thất bại";
    }
    else if(error == "FormatException: Unexpected character (at character 1)\nDelete Light Fail!\n^\n"){
      error = "Xóa đèn thất bại";
    }
    else{
      error = "Không có kết nỗi!";
    }
    return ApiDeleteDevice({}, -1,error);
  }
}