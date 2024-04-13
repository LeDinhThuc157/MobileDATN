import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../res/vaule.dart';

class ApiControlDevice{
  final Map<String, dynamic> userMap;
  final int statusResponse;
  final String? error;

  ApiControlDevice(this.userMap, this.statusResponse, this.error);
}
Future<dynamic> ControlDevice(String index, String cDevice, String mode) async {
  final dio = Dio();

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String storedTokenKey = prefs.getString('tokenKey') ?? '';
  try{
    Response response = await dio.post(
        addressControlDevice,
        options: Options(
          headers: {
            "Content-type": "application/json; charset=utf-8",
            "Authorization": "Bearer $storedTokenKey",
          },
        ),
        data:jsonEncode({
          "cDevice": cDevice,
          "index": index,
          "mode" : mode
        })
    );
    Map<String, dynamic> userMap = jsonDecode(response.toString());
    int statusResponse = response.statusCode!;
    return ApiControlDevice(userMap, statusResponse, '');
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
    return ApiControlDevice({}, -1,error);
  }
}