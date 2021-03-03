import 'package:flutter/material.dart';
import 'package:forte_life/constants/constants.dart';
import 'package:forte_life/services/agent_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:forte_life/models/user.dart' as UserModel;
import 'package:forte_life/services/auth_service.dart';
import 'package:dio/dio.dart';
import 'package:forte_life/models/http_exception.dart';

class AuthProvider extends ChangeNotifier {
  SharedPreferences sharedPreferences;
  UserModel.User _user;
  String _accessToken;

  UserModel.User get user {
    return _user;
  }

  String get accessToken {
    return _accessToken;
  }

  set accessToken(String token) {
    _accessToken = token;
    notifyListeners();
  }

  Future<dynamic> login({String username, String password}) async {
    try {
      final response =
          await AuthService.login(username: username, password: password);
      _user = UserModel.User.fromMap(response['data']);

      if (!_user.isActive) {
        throw HttpException("This Account Has Been Suspended");
      }

      final token = response['token'];
      sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setString(APP_ACCESS_TOKEN, token);
      _accessToken = response['token'];
      notifyListeners();
      return _user;
    } on DioError catch (error) {
      print(error.response);
      if (error.response == null) {
        throw HttpException(SERVICE_UNAVAILABLE_MESSAGE);
      } else {
        throw HttpException(error.response.data['message']);
      }
    }
  }

  Future<void> changePassword(String newPassword) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String agentID = prefs.getString(AGENT_ID);
      final response = await AgentService.changePassword(
          agentId: agentID, newPassword: newPassword);
      notifyListeners();
      return response;
    } on DioError catch (error) {
      print(error.response);
      if (error.response == null) {
        throw HttpException(SERVICE_UNAVAILABLE_MESSAGE);
      } else {
        throw HttpException(error.response.data['message']);
      }
    }
  }

  Future<dynamic> getCurrentUser({String token}) async {
    final response = await AuthService.getCurrentUser(token: token);
    _accessToken = token;
    _user = UserModel.User.fromMap(response);
    return response;
  }

  Future<void> logout(BuildContext context) async {
    try {
      _user = null;
      sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.remove(APP_ACCESS_TOKEN);
    } catch (error) {
      print(error);
    }
  }
}
