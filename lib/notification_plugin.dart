import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' show Platform;

import 'package:rxdart/subjects.dart';

class NotificationPlugin {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  // ignore: close_sinks
  final BehaviorSubject<ReceivedNotification>
      didReceiveLocalNotificationSubject =
      BehaviorSubject<ReceivedNotification>();
  var initSettings;

  NotificationPlugin._() {
    init();
  }

  init() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    print("notification initialized");
    if (Platform.isIOS) {
      _requestIOSPermission();
    }
    initializePlatformSpecific();
  }

  initializePlatformSpecific() {
    var initializeAndroidSettings =
        AndroidInitializationSettings('@mipmap/forte');
    var initializeIOSSettings = IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: false,
        onDidReceiveLocalNotification: (id, title, body, payload) async {
          ReceivedNotification receivedNotification = ReceivedNotification(
              id: id, title: title, body: body, payload: payload);
          didReceiveLocalNotificationSubject.add(receivedNotification);
        });
    initSettings = InitializationSettings(
        android: initializeAndroidSettings, iOS: initializeIOSSettings);
  }

  _requestIOSPermission() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        .requestPermissions(alert: false, badge: true, sound: true);
  }

  setListenerForLowerVersion(Function notificationForLowerVersion) {
    didReceiveLocalNotificationSubject.listen((receivedNotification) {
      notificationForLowerVersion(receivedNotification);
    });
  }

  setOnSelectNotification(Function onSelectNotification) async {
    await flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: (String payload) async {
      onSelectNotification(payload);
    });
  }

  Future<void> showNotification() async {
    var androidChannelSpecifics = AndroidNotificationDetails(
      "CHANNEL_ID",
      "CHANNEL_NAME",
      "CHANNEL_DESCRIPTION",
      importance: Importance.max,
      priority: Priority.high,
      timeoutAfter: 6000,
      styleInformation: DefaultStyleInformation(true, true),
      playSound: true,
    );
    var iosChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidChannelSpecifics, iOS: iosChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, "Forte Life Assurance",
        "App Generated PDF", platformChannelSpecifics,
        payload: "PDF Saved In Downloads");
  }
}

NotificationPlugin notificationPlugin = NotificationPlugin._();

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({this.id, this.title, this.body, this.payload});
}
