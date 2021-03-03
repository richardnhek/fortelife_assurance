import 'package:dio/dio.dart';
import 'package:forte_life/constants/constants.dart';

class AuthService {
  static dynamic login({String username, String password}) async {
    Dio dio = Dio();
    Response response = await dio.post(
      "$END_POINT/auth/agent/login",
      options: Options(
        headers: {"Content-Type": "application/json"},
      ),
      data: {
        "username": username,
        "password": password,
      },
    );
    return response.data;
  }

  static dynamic getCurrentUser({String token}) async {
    Dio dio = Dio();
    Response response = await dio.get(
      "$END_POINT/auth/current",
      options: Options(
        headers: {"Authorization": "Bearer $token"},
      ),
    );
    return response.data;
  }
}
