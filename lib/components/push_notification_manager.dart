import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:whattheysee/components/ob_homecontroller.dart';
import 'package:whattheysee/model/mediaitem.dart';
import 'package:whattheysee/screens/ui/detail/detail_screen.dart';
import 'package:timezone/data/latest_all.dart' as tz;

class PushNotificationsManager {
  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;
  static final PushNotificationsManager _instance =
      PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  FirebaseMessaging get firebaseMessaging => _firebaseMessaging;
  bool _initialized = false;

  AndroidNotificationChannel? channel;
  static const String iconNotif = "app_icon";
  static const String iconBigNotif = "icon_big";
  static const String idNotif = '${ObHomeController.aPPNAME}_App';
  static const String titleNotif =
      '${ObHomeController.aPPNAME}_BroadcastMessage';
  static const String descNotif =
      '${ObHomeController.aPPNAME}_NotificationAlert';

  init() async {
    tz.initializeTimeZones();

    if (!_initialized) {
      _initialized = true;

      channel = const AndroidNotificationChannel(
        idNotif, // id
        titleNotif, // title
        description: descNotif, // description
        importance: Importance.high,
      );

      try {
        final NotificationSettings settings =
            await firebaseMessaging.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
        );

        debugPrint('User granted permission: ${settings.authorizationStatus}');
      } catch (e) {
        debugPrint("Error setting ${e.toString()}");
      }

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      if (GetPlatform.isIOS) {
        await firebaseMessaging.setForegroundNotificationPresentationOptions(
          alert: true, // Required to display a heads up notification
          badge: true,
          sound: true,
        );
      }
    }

    firebaseMessaging.getInitialMessage().then((RemoteMessage? message) async {
      ObHomeController.to.secondCall();
      if (message != null) {
        onBackgroundMessage(message);
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage? message) async {
      ObHomeController.to.secondCall();
      if (message != null) {
        onBackgroundMessage(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) {
      debugPrint('A new onMessageOpenedApp event was published!');
      ObHomeController.to.secondCall();
      if (message != null) {
        onBackgroundMessage(message);
      }
    });

    firebaseMessaging.getToken().then((String? token) {
      if (token != null) {
        ObHomeController.to.saveToken(token);
        ObHomeController.to.secondCall();
      }
    });

    firebaseMessaging.onTokenRefresh.listen((String? newtoken) {
      if (newtoken != null) {
        ObHomeController.to.saveToken(newtoken);
        ObHomeController.to.secondCall();
      }
    });

    //subscribe topics

    //await subscribeFCMTopic(fcmTopicName);
  }

  static Future<dynamic>? onBackgroundMessage(RemoteMessage remote) {
    //debugPrint('[PushNotificationsManager] onBackgroundMessage: $message');
    Map<String, dynamic>? message = remote.data;
    if (message.containsKey('data')) {
      getDataFcm(message);
    }
    return null;
  }

  static bool isProcessNotif = false;
  static getDataFcm(Map<String, dynamic> message) {
    debugPrint("[PushNotificationsManager] getDataFcm $message");

    try {
      String id = '101';
      if (message.containsKey('notification')) {
        var notif = message['notification'];
        debugPrint("[PushNotificationsManager] getnotiffff $notif");

        String? idMovie = "";

        try {
          if (GetPlatform.isIOS) {
            idMovie = message['miv'];
          } else {
            var messageData = message['data'];
            //debugPrint("[PushNotificationsManager] getnotiffff11111 $messageData");
            if (messageData['miv'] != null && messageData['miv'].length > 1) {
              idMovie = messageData['miv'];
            }
          }
        } catch (e) {
          debugPrint("");
        }

        if (notif['title'] == null || notif['body'] == null) {
          try {
            if (idMovie != null && idMovie.length > 1) {
              ObHomeController.to.loadLocalDataMedia({});
              Future.delayed(const Duration(milliseconds: 1200), () {
                ObHomeController.to.loadLocalDataMedia({});
                gotoScreenByIdMovie(idMovie!);
              });

              return;
            }
          } catch (e) {
            debugPrint("");
          }

          return;
        }

        if (isProcessNotif) return;
        isProcessNotif = true;

        Future.delayed(const Duration(milliseconds: 3500), () {
          isProcessNotif = false;
        });

        final ObHomeController c = ObHomeController.to;
        c.createNotif(
          notif['title'],
          notif['body'],
          int.parse(id),
          message,
        );

        Future.delayed(Duration.zero, () async {
          c.secondCall();
          c.fetchHome(false);
        });

        //debugPrint(
        //    "[PushNotificationsManager] getDataFcm ${message['notification']}");
      }
    } catch (e) {
      debugPrint("[PushNotificationsManager] error $e");
    }
  }

  static gotoScreenByIdMovie(String? miv) {
    //debugPrint("[PushNotificationsManager] gotoScreenByIdMovie ");
    try {
      String idMovie = miv ?? "";
      //debugPrint("[PushNotificationsManager] gotoScreenByIdMovie idMovie $idMovie");

      if (idMovie != '' && idMovie.isNotEmpty) {
        final ObHomeController c = ObHomeController.to;
        c.loadLocalDataMedia({});

        int getid = int.parse(idMovie.toString());
        MediaItem? getItem;
        List<MediaItem>? results = c.itemResp.value.result!;
        if (results.isNotEmpty) {
          results = results.where((element) => element.id == getid).toList();
        }

        if (results.isNotEmpty) {
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
          //debugPrint("Get.to idmovie ${getItem.id}");
          c.setItemPass(getItem, true, null);
          Future.delayed(const Duration(seconds: 2), () {
            Get.to(DetailScreen(item: getItem!));
          });
        }
      }
    } catch (e) {
      debugPrint("[PushNotificationsManager] gotoScreenByIdMovie .. error $e");
    }
  }
}
