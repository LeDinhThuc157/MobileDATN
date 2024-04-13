import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../res/vaule.dart';

class ApiQueryLog{
  final Map<String, dynamic> userMap;
  final int statusResponse;
  final String? error;

  ApiQueryLog(this.userMap, this.statusResponse, this.error);
}
Future<dynamic> QueryLog(String year, String month, String day) async {
  final dio = Dio();

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String storedTokenKey = prefs.getString('tokenKey') ?? '';
  try{
    Response response = await dio.post(
        addressQueryLog,
        options: Options(
          headers: {
            "Content-type": "application/json; charset=utf-8",
            "Authorization": "Bearer $storedTokenKey",
          },
        ),
        data:jsonEncode({
          "year": year,
          "month": month,
          "day" : day
        })
    );
    Map<String, dynamic> userMap = jsonDecode(response.toString());
    int statusResponse = response.statusCode!;
    return ApiQueryLog(userMap, statusResponse, '');
  }catch(e){
    String error = e.toString();
    if(error == "FormatException: Unexpected character (at character 1)\nAccount not exist\n^\n"){
      error = "Tài khoản không tồn tại";
    }else{
      if(error == "FormatException: Unexpected character (at character 1)\nPermission denied\n^\n"){
        error = "Không có quyền truy cập";
      }else{
        error = "Không có kết nỗi!";
      }
    }
    return ApiQueryLog({}, -1,error);
  }
}