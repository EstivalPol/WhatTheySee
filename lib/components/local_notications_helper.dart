import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:whattheysee/components/ob_homecontroller.dart';
import 'package:whattheysee/model/mediaitem.dart';
import 'package:whattheysee/screens/ui/detail/detail_screen.dart';

class NotificationHelper {
  NotificationHelper._internal() {
    // set notif initialize

    //set notification
    const settingsAndroid = AndroidInitializationSettings('app_icon');
    final settingsIOS = DarwinInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) =>
            onSelectNotification(payload!));

    _notifications.initialize(
        InitializationSettings(android: settingsAndroid, iOS: settingsIOS));
    //set notification onSelectNotification: onSelectNotification

    debugPrint("[NotificationHelper] initialization...");
  }

  static final NotificationHelper _instance = NotificationHelper._internal();

  static NotificationHelper get instance {
    return _instance;
  }

  int thisId = 1;

  int get id {
    return thisId;
  }

  set id(int id) {
    thisId = id;
  }

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  get notifications => _notifications;

  // function for notif
  Future onSelectNotification(String? payload) async {
    try {
      if (payload == null) return;

      dynamic getnotif = jsonDecode(payload);
      dynamic message = getnotif['data'] ?? getnotif;

      String? idMovie = message['miv'] ?? "";
      debugPrint("[onSelectNotification] NotificationHelper idMovie $idMovie");

      if (idMovie != null && idMovie.isNotEmpty) {
        final ObHomeController c = ObHomeController.to;
        c.loadLocalDataMedia({});

        int getid = int.parse(idMovie.toString());
        MediaItem? getItem;
        List<MediaItem>? results = c.itemResp.value.result;
        if (results != null && results.isNotEmpty) {
          results = results.where((element) => element.id == getid).toList();
        }

        if (results!.isNotEmpty) {
          getItem = results[0];
        } else {
          results = c.itemResp.value.popular;
          if (results != null && results.isNotEmpty) {
            results = results.where((element) => element.id == getid).toList();
          }

          if (results!.isNotEmpty) {
            getItem = results[0];
          } else {
            results = c.itemResp.value.trending;
            if (results != null && results.isNotEmpty) {
              results =
                  results.where((element) => element.id == getid).toList();
            }
            if (results!.isNotEmpty) {
              getItem = results[0];
            } else {
              results = c.itemResp.value.upcoming;
              if (results != null && results.isNotEmpty) {
                results =
                    results.where((element) => element.id == getid).toList();
              }
              if (results!.isNotEmpty) {
                getItem = results[0];
              }
            }
          }
        }

        if (getItem != null && getItem.id != 0) {
          debugPrint("${getItem.id}");
          c.setItemPass(getItem, true, null);
          Get.to(DetailScreen(item: getItem));
        }
      }
    } catch (e) {
      debugPrint("[NotificationHelper] onSelectNotification .. error $e");
    }

    try {
      await notifications.cancelAll();
    } catch (e) {
      debugPrint("");
    }
  }

  // function for notif

  Future cancelNotification(int id) => notifications.cancel(id);
  Future cancelAll() => notifications.cancelAll();

  NotificationDetails get _noSound {
    var vibrationPattern = Int64List(2);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;

    final androidChannelSpecifics = AndroidNotificationDetails(
      '21230',
      'SILENTWHATTHEYSEE',
      channelDescription: 'SILENTNOTIF_WHATTHEYSEE',
      playSound: false,
      importance: Importance.high,
      priority: Priority.defaultPriority,
      category: const AndroidNotificationCategory(
        "SILENT_ALARM",
      ),
      vibrationPattern: vibrationPattern,
      //ticker: 'tickerSilent',
    );
    const iOSChannelSpecifics = DarwinNotificationDetails(presentSound: false);

    return NotificationDetails(
        android: androidChannelSpecifics, iOS: iOSChannelSpecifics);
  }

  Future showSilentNotification({
    required String title,
    required String body,
    int id = 1,
    dynamic payload,
  }) =>
      _showSilentNotification(
        title: title,
        body: body,
        id: id,
        type: _noSound,
        payload: payload,
      );

  NotificationDetails get _ongoing {
    var vibrationPattern = Int64List(2);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;

    const String tHISID = '21201';
    const String tHISTITLE = 'Notif WhatTheySee';
    const String tHISDESC = 'NOTIFICATION WHATTHEYSEE';
    String fileTone = 'tone';

    var androidChannelSpecifics = AndroidNotificationDetails(
      tHISID,
      tHISTITLE,
      channelDescription: tHISDESC,
      importance: Importance.high,
      priority: Priority.defaultPriority,
      sound: RawResourceAndroidNotificationSound(fileTone),
      largeIcon: const DrawableResourceAndroidBitmap('icon_big'),
      vibrationPattern: vibrationPattern,
      enableLights: true,
      autoCancel: true,
    );

    var iOSChannelSpecifics = DarwinNotificationDetails(
      presentSound: true,
      sound: '$fileTone.mp3',
    ); //IOSNotificationDetails();

    return NotificationDetails(
        android: androidChannelSpecifics, iOS: iOSChannelSpecifics);
  }

  NotificationDetails get _ongoingSilent {
    var vibrationPattern = Int64List(2);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    //vibrationPattern[2] = 5000;
    //vibrationPattern[3] = 2000;

    const tHISID = '21232';
    const tHISTITLE = 'NOTIF_SILENT';
    const tHISDESC = 'NOTSILENT_WHATTHEYSEE';

    var androidChannelSpecifics = AndroidNotificationDetails(
      tHISID,
      tHISTITLE,
      channelDescription: tHISDESC,
      importance: Importance.high,
      priority: Priority.max,
      category: const AndroidNotificationCategory(
        "SILENT_ALARM",
      ),
      //sound: RawResourceAndroidNotificationSound('adzan.mp3'),
      vibrationPattern: vibrationPattern,
      //enableLights: true,
      playSound: false,
      //color: Color.fromARGB(255, 255, 0, 0),
      //ledColor: Color(0xFF00AFEF),
      //ledOnMs: 1000,
      //ledOffMs: 500,
      autoCancel: true,
      //ticker: 'tickerNoSound',
    );

    const iOSChannelSpecifics = DarwinNotificationDetails(presentSound: false);

    return NotificationDetails(
        android: androidChannelSpecifics, iOS: iOSChannelSpecifics);
  }

  Future showOngoingNotification({
    required String title,
    required String body,
    int id = 1,
  }) {
    debugPrint("[NotificationHelper] id $id");
    debugPrint("[NotificationHelper] this.thisId $thisId");

    return _showNotification(
      title: title,
      body: body,
      id: thisId,
      type: _ongoing,
    );
  }

  Future _showNotification({
    required String title,
    required String body,
    required NotificationDetails type,
    int id = 1,
  }) =>
      notifications.show(thisId, title, body, type);

  Future _showSilentNotification({
    required String title,
    required String body,
    required NotificationDetails type,
    int id = 1,
    dynamic payload,
  }) =>
      notifications.show(thisId, title, body, type,
          payload: json.encode(payload));

  Future showOngoingScheduleNotification({
    required String title,
    required String body,
    required int seconds,
    int id = 1,
  }) =>
      _showScheduleNotification(
        title: title,
        body: body,
        type: _ongoing,
        seconds: seconds,
      );

  Future _showScheduleNotification({
    required String title,
    required String body,
    required NotificationDetails type,
    required int seconds,
    int id = 1,
  }) =>
      notifications.schedule(
        id,
        title,
        body,
        DateTime.now().add(Duration(seconds: seconds)),
        type,
      );

  Future showOngoingScheduleNotificationDuration({
    required String title,
    required String body,
    required Duration duration,
    int id = 1,
    dynamic payload,
  }) =>
      _showScheduleNotificationDuration(
        title: title,
        body: body,
        type: _ongoing,
        duration: duration,
        payload: payload,
      );

  Future _showScheduleNotificationDuration({
    required String title,
    required String body,
    required NotificationDetails type,
    required Duration duration,
    int id = 1,
    dynamic payload,
  }) =>
      notifications.schedule(
        id,
        title,
        body,
        DateTime.now().add(duration),
        type,
        payload: jsonEncode(payload),
      );

//silent only
  Future showOngoingScheduleSilentNotificationDuration({
    required String title,
    required String body,
    required Duration duration,
    int id = 1,
  }) =>
      _showScheduleSilentNotificationDuration(
        title: title,
        body: body,
        type: _ongoingSilent,
        duration: duration,
      );

  Future _showScheduleSilentNotificationDuration({
    required String title,
    required String body,
    required NotificationDetails type,
    required Duration duration,
    int id = 1,
  }) =>
      notifications.schedule(
          id, title, body, DateTime.now().add(duration), type);

  //for silent

  // instant access
  Future scheduleSilentNotification(title, body, duration, id) =>
      showOngoingScheduleSilentNotificationDuration(
        title: title,
        body: body,
        duration: duration,
        id: id,
      );

  Future scheduleNotification(title, body, duration, id, payload) =>
      showOngoingScheduleNotificationDuration(
        title: title,
        body: body,
        duration: duration,
        id: id,
        payload: payload,
      );
  // instant access
}
