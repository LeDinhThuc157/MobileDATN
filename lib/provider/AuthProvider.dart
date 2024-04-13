
import 'dart:convert';

import 'package:dio/dio.dart';

class ApiLogin{
  final Map<String, dynamic> userMap;
  final int statusResponse;
  final String? error;

  ApiLogin(this.userMap, this.statusResponse, this.error);

  Future<dynamic> login(String username, String password) async {
    // Logic xác thực đăng nhập
    final dio = Dio();
    try{
      Response response = await dio.post(
          "http://white-dev.aithings.vn:8888/api/LoginAPI/UsersLogin",
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
      if(error == "FormatException: Unexpected character (at character 1)\nTài khoản không tồn tại\n^\n"){
        error = "Tài khoản không tồn tại";
      }else{
        if(error == "FormatException: Unexpected character (at character 1)\nSai mật khẩu\n^\n"){
          error = "Sai mật khẩu";
        }else{
          error = "Không có kết nỗi!";
        }
      }
      return ApiLogin({}, -1,error);
    }
  }
}