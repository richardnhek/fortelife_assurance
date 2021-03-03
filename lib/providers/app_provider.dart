import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

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

}
