import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forte_life/configs/language.dart';
import 'package:forte_life/constants/constants.dart';
import 'package:forte_life/models/http_exception.dart';
import 'package:forte_life/services/rider_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProvider extends ChangeNotifier {
  // Bottom Navigation Index
  int _activeTabIndex = 0;

  int get activeTabIndex => _activeTabIndex;

  set activeTabIndex(int i) {
    _activeTabIndex = i;
    notifyListeners();
  }
  //

  // LP and P are the same or not
  bool _differentPerson = false;
  bool get differentPerson => _differentPerson;

  set differentPerson(bool i) {
    _differentPerson = i;
    notifyListeners();
  }
  //

  // Switch between info and calculator
  int _calculationPage = 0;
  int get calculationPage => _calculationPage;

  set calculationPage(int i) {
    _calculationPage = i;
    notifyListeners();
  }
  //

  // Switch between info and calculator
  int _calculationPageEdu = 0;
  int get calculationPageEdu => _calculationPageEdu;

  set calculationPageEdu(int i) {
    _calculationPageEdu = i;
    notifyListeners();
  }
  //

  // PDF screen index
  int _pdfScreenIndex = 0;
  int get pdfScreenIndex => _pdfScreenIndex;

  set pdfScreenIndex(int i) {
    _pdfScreenIndex = i;
    notifyListeners();
  }
  //

  // Add Rider
  bool _addRider = false;
  bool get addRider => _addRider;

  set addRider(bool i) {
    _addRider = i;
    notifyListeners();
  }
  //

  void setAppOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  // Categories tab index is to tell the navigator which child the Categories tab is currently on
  int _categoriesTabIndex = 0;

  int get categoriesTabIndex => _categoriesTabIndex;

  set categoriesTabIndex(int i) {
    _categoriesTabIndex = i;
    notifyListeners();
  }
  //

  //Check type of device
  bool _isTablet = false;
  bool get isTablet => _isTablet;
  set isTablet(bool a) {
    _isTablet = a;
    notifyListeners();
  }

  Future<void> getDeviceType(double shortestSide) async {
    _isTablet = shortestSide >= 500.0;
    notifyListeners();
  }
  //

  //Languages
  String _language = LANGUAGE_KHMER;
  String get language => _language;
  set language(String l) {
    _language = l;
    notifyListeners();
  }

  Map<String, String> _lang = {};
  Map<String, String> get lang => LANGUAGE_MAP.map(
        (key, value) {
          return MapEntry(key, LANGUAGE_MAP[key][_language]);
        },
      );

  Future<void> getLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      String appLanguage = prefs.getString(APP_LANGUAGE);

      if (appLanguage == null) throw Exception("undefined language");

      _language = appLanguage;
    } catch (e) {
      _language = LANGUAGE_ENGLISH;
    }
    // _language = LANGUAGE_ENGLISH;
    notifyListeners();
  }
  //

  //Request Permissions
  Map<Permission, PermissionStatus> _permissions = {
    Permission.notification: PermissionStatus.undetermined,
    Permission.storage: PermissionStatus.undetermined,
  };
  Map<Permission, PermissionStatus> get permissions => _permissions;
  Future<void> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.notification,
      Permission.storage,
    ].request();

    _permissions = statuses;
    print(_permissions);
    notifyListeners();
  }
  //

  //Get Username
  String _userName = " ";
  String get userName => _userName;

  set userName(String i) {
    _userName = i;
    notifyListeners();
  }
  //

  //Get Username
  String _lastLogin = " ";
  String get lastLogin => _lastLogin;

  set lastLogin(String i) {
    _lastLogin = i;
    notifyListeners();
  }
  //

  //Get Root Path
  String _rootPath = " ";
  String get rootPath => _rootPath;

  set rootPath(String i) {
    _rootPath = i;
    notifyListeners();
  }
  //

  //Get Rider Limitation
  Future<void> getRider() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final response = await RiderService.getRider();
      prefs.setInt(RIDER_AMOUNT, response['amount']);
      print(prefs.getInt(RIDER_AMOUNT));
      notifyListeners();
    } on DioError catch (error) {
      print(error.response);
      if (error.response == null) {
        throw HttpException(SERVICE_UNAVAILABLE_MESSAGE);
      } else {
        throw HttpException(error.response.data['message']);
      }
    }
  }
  //

}
