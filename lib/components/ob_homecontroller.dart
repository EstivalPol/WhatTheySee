import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whattheysee/components/local_notications_helper.dart';
import 'package:whattheysee/components/push_notification_manager.dart';
import 'package:whattheysee/model/cast.dart';
import 'package:whattheysee/model/latestitem.dart';
import 'package:whattheysee/model/mediaitem.dart';
import 'package:whattheysee/util/mediaproviders.dart';
import 'package:uuid/uuid.dart';

// ignore: constant_identifier_names
enum RequestType { GET, POST, DELETE }

class Result {
  Result();
  dynamic json;
}

class IndexTap {
  IndexTap({this.index = 0, this.currentTheme = 0});
  int index;
  int currentTheme;
}

class ItemTheme {
  ItemTheme({this.currentTheme = 0});
  int currentTheme;
}

class ItemFavs {
  ItemFavs({this.item});
  MediaItem? item;
  List<MediaItem> allFavs = [];
  List<MediaItem> movieFavs = [];
  List<MediaItem> showFavs = [];
}

class PassingItem {
  PassingItem({this.item});
  MediaItem? item;
  dynamic result;
  List<Actor>? cast;
  List<MediaItem>? similar;
  dynamic videos;
  dynamic images;
}

class ResponseItem {
  ResponseItem({this.item, this.result, this.trending});
  dynamic item;
  List<MediaItem>? result;
  dynamic trending;
  dynamic popular;
  dynamic upcoming;
  dynamic toprated;
  dynamic latest;
}

class ResponseItemTV {
  ResponseItemTV();
  dynamic item;
  dynamic result;
  dynamic trending;
  dynamic popular;
  dynamic upcoming;
  dynamic toprated;
  dynamic latest;
}

class OrientationItem {
  OrientationItem({this.orientation = Orientation.portrait, this.height = 0});
  Orientation orientation;
  double height;
}

class LoginItem {
  LoginItem({this.isLogin = false});
  bool isLogin;
  dynamic member;
  String? message;
}

class MoviePlay {
  MoviePlay({this.item});
  MediaItem? item;
  dynamic trailer;
  List<dynamic>? trailers;
}

Color primary = const Color(0xFF2C2B33);
Color primaryDark = const Color(0xFF222128);
Color colorAccent = const Color(0xFFB73443); // Color(0xFF65BFA6);
Color salmon = const Color(0xFFF47663);

Color primaryLight = const Color(0xFFFAFAFA);
Color primaryDarkLight = const Color(0xFF4F7CB0);
Color colorAccentLight = const Color(0xFFDBAE00); // Color(0xFF65BFA6);
Color salmonLight = const Color(0xFFB7303D);

const Color mainColor = Color(0xFF448F79);
const Color secondaryColor = Color(0xFF031009);
const Color tertiaryColor = Color(0xFFC2D1A1);
Color whiteColor = const Color(0xFFF3f3f3);
Color blackColor = const Color(0xFF201F2B);

final TextStyle captionStyle = TextStyle(color: Colors.grey[400]);
const TextStyle whiteBody = TextStyle(color: Colors.white);

class ObHomeController extends GetxController {
  static const mAINCOLOR = mainColor;
  static const nAMEStorage = "whattheyseeBox";

  static const tHEMEKEY = "theme_prefs_key";
  static const aPPNAME = "WhatTheySee";
  static const aPPVERSION = "v. 1.0.6";
  static const wEBURL = "https://wts.id";
  static const eMAILADDRESS = "info@whattheysee.id";

  static const sENDERID = "49303957470";

  /*static GetStorage _sharedPrefs() {
    return GetStorage(tHEMEKEY);
  }*/

  late GetStorage _sharedPrefs;
  GetStorage get sharedPrefs => _sharedPrefs;

  // key for sharedpref
  static const fIRST = "first_prefs_key";
  static const tOKEN = "token_prefs_key";
  static const mEMBER = "member_prefs_key";

  static const lATEST = "latestnew_prefs_key";
  static const nOWPLAYING = "nowplaying_prefs_key";
  static const tRENDING = "trending_prefs_key";
  static const pOPULAR = "popular_prefs_key";
  static const uPCOMING = "upcoming_prefs_key";
  static const tOPRATE = "toprated_prefs_key";

  //static const lATESTTV = "latesttvnew_prefs_key";
  static const nOWPLAYINGTV = "nowplayingtv_prefs_key";
  static const tRENDINGTV = "trendingtv_prefs_key";
  static const pOPULARTV = "populartv_prefs_key";
  static const uPCOMINGTV = "upcomingtv_prefs_key";
  static const tOPRATETV = "topratedtv_prefs_key";

  Set<MediaItem> _favorites = {};
  Set<LatestItem> _getLatest = {};
  static const fAVORITESKEY = "media_favorites_key";
  // key for sharedpref

  ObHomeController(final GetStorage pref) {
    _sharedPrefs = pref;
    idxcurrentTheme = _sharedPrefs.read(tHEMEKEY) ?? 0;
    _sharedPrefs.write(tHEMEKEY, idxcurrentTheme);

    setItemTheme(idxcurrentTheme);

    _thisUuid = _sharedPrefs.read('uuid') ?? const Uuid().v1();
    _sharedPrefs.write('uuid', _thisUuid);

    getMember();
  }

  var itemLogin = LoginItem().obs;
  toggleLogin(bool isLogin, String? message) async {
    try {
      var stringLogin = sharedPrefs.read(mEMBER) ?? "";
      if (stringLogin != null && stringLogin != '') {
        _member = jsonDecode(stringLogin);
      }

      itemLogin.update((val) {
        val!.isLogin = isLogin;
        val.member = _member;
        val.message = message;
      });
    } catch (e) {
      debugPrint("[ObHomeController] toggleLogin error ${e.toString()}");
    }
  }

  saveFirst(int first) {
    debugPrint("ObHomeController saveFirst saved...$first");
    sharedPrefs.write(fIRST, first);
  }

  getFirst() {
    return sharedPrefs.read(fIRST) ?? 0;
  }

  saveToken(String token) {
    //debugPrint("ObHomeController saveToken... $token");
    try {
      sharedPrefs.write(tOKEN, token);
    } catch (e) {
      debugPrint("ObHomeController error ${e.toString()}");
    }
  }

  getToken() {
    return sharedPrefs.read(tOKEN) ?? "";
  }

  saveMember(String member) {
    debugPrint("ObHomeController saveMember...");
    try {
      sharedPrefs.write(mEMBER, member);
    } catch (e) {
      debugPrint("ObHomeController error ${e.toString()}");
    }
  }

  getMember() {
    var stringLogin = sharedPrefs.read(mEMBER) ?? "";
    //debugPrint("getMember $stringLogin");

    if (stringLogin != null && stringLogin != '') {
      _member = jsonDecode(stringLogin);
      //debugPrint(_member);

      if (_member['nm_member'] != null && _member['nm_member'].length > 1) {
        var tipe = _member['tipe'] ?? "";
        itemLogin.update((val) {
          val!.isLogin = tipe == '2' ? false : true;
          val.member = _member;
          val.message = null;
        });
      }
    } else {
      itemLogin.update((val) {
        val!.isLogin = false;
        val.member = null;
        val.message = null;
      });
    }
    return stringLogin;
  }

  saveTrendingOthers(String trending, int type) {
    //debugPrint(trending);

    if (type == 1) {
      sharedPrefs.write(tRENDING, trending);
    } else if (type == 2) {
      sharedPrefs.write(pOPULAR, trending);
    } else if (type == 3) {
      sharedPrefs.write(uPCOMING, trending);
    } else if (type == 4) {
      sharedPrefs.write(tOPRATE, trending);
    } else if (type == 5) {
      sharedPrefs.write(nOWPLAYING, trending);
    } else if (type == 6) {
      //sharedPrefs.write(lATEST, trending);
      sharedPrefs.write(
          lATEST,
          _getLatest
              .map((LatestItem latestItem) => jsonEncode(latestItem.toJson()))
              .toList());
    }
  }

  List<MediaItem>? getTrendingOthers(int type) {
    String res = "";
    if (type == 1) {
      res = sharedPrefs.read(tRENDING) ?? "";
    } else if (type == 2) {
      res = sharedPrefs.read(pOPULAR) ?? "";
    } else if (type == 3) {
      res = sharedPrefs.read(uPCOMING) ?? "";
    } else if (type == 4) {
      res = sharedPrefs.read(tOPRATE) ?? "";
    } else if (type == 5) {
      res = sharedPrefs.read(nOWPLAYING) ?? "";
    }
    /*else if (type == 6) {
      res = sharedPrefs.read(lATEST) ?? "";
    }*/

    if (res == "") {
      return null;
    }
    return jsonDecode(res)
        .map<MediaItem>((item) => MediaItem(item, MediaType.movie))
        .toList();
  }

  saveTrendingOthersTV(String trending, int type) {
    //debugPrint(trending);

    if (type == 1) {
      sharedPrefs.write(tRENDINGTV, trending);
    } else if (type == 2) {
      sharedPrefs.write(pOPULARTV, trending);
    } else if (type == 3) {
      sharedPrefs.write(uPCOMINGTV, trending);
    } else if (type == 4) {
      sharedPrefs.write(tOPRATETV, trending);
    } else if (type == 5) {
      sharedPrefs.write(nOWPLAYINGTV, trending);
    }
    /*else if (type == 6) {
      sharedPrefs.write(lATESTTV, trending);
    }*/
  }

  List<MediaItem>? getTrendingOthersTV(int type) {
    String res = "";
    if (type == 1) {
      res = sharedPrefs.read(tRENDINGTV) ?? "";
    } else if (type == 2) {
      res = sharedPrefs.read(pOPULARTV) ?? "";
    } else if (type == 3) {
      res = sharedPrefs.read(uPCOMINGTV) ?? "";
    } else if (type == 4) {
      res = sharedPrefs.read(tOPRATETV) ?? "";
    } else if (type == 5) {
      res = sharedPrefs.read(nOWPLAYINGTV) ?? "";
    }
    /*else if (type == 6) {
      res = sharedPrefs.read(lATESTTV) ?? "";
    }*/

    if (res == "") {
      return null;
    }
    return jsonDecode(res)
        .map<MediaItem>((item) => MediaItem(item, MediaType.movie))
        .toList();
  }

  static ObHomeController get to => Get.find();

  static List<ThemeData> themes = [
    ThemeData.dark().copyWith(
      primaryColor: primary,
      primaryColorDark: primaryDark,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      indicatorColor: const Color(0xFFF4D72E),
      iconTheme: const IconThemeData(color: Colors.white70),
      canvasColor: blackColor,
      dialogBackgroundColor: Colors.grey[600],
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.black12,
      ),
      textTheme:
          GoogleFonts.latoTextTheme(Theme.of(Get.context!).textTheme).apply(
        bodyColor: Colors.white70,
        displayColor: Colors.grey[300],
      ),
      appBarTheme: AppBarTheme(
        toolbarTextStyle:
            GoogleFonts.latoTextTheme(Theme.of(Get.context!).textTheme)
                .apply(
                  bodyColor: Colors.white70,
                )
                .bodyMedium,
        titleTextStyle:
            GoogleFonts.latoTextTheme(Theme.of(Get.context!).textTheme)
                .apply(
                  bodyColor: Colors.white70,
                )
                .titleLarge,
      ),
      colorScheme: ColorScheme.fromSwatch()
          .copyWith(secondary: colorAccent)
          .copyWith(background: Colors.grey[900]!.withOpacity(0.8)),
    ),
    ThemeData.light().copyWith(
      primaryColor: primaryLight,
      primaryColorDark: primaryDarkLight,
      visualDensity: VisualDensity.adaptivePlatformDensity, //.orangeSoft,
      indicatorColor: const Color(0xFFF3FBD8),
      canvasColor: whiteColor,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
      ),
      textTheme:
          GoogleFonts.latoTextTheme(Theme.of(Get.context!).textTheme).apply(
        bodyColor: Colors.black87,
        displayColor: Colors.grey[700],
        decorationColor: Colors.black87,
      ),
      appBarTheme: AppBarTheme(
        iconTheme: const IconThemeData(color: Colors.black54),
        toolbarTextStyle:
            GoogleFonts.latoTextTheme(Theme.of(Get.context!).textTheme)
                .apply(
                  bodyColor: Colors.black54,
                  displayColor: Colors.black54,
                  decorationColor: Colors.black54,
                )
                .bodyMedium,
        titleTextStyle:
            GoogleFonts.latoTextTheme(Theme.of(Get.context!).textTheme)
                .apply(
                  bodyColor: Colors.black54,
                  displayColor: Colors.black54,
                  decorationColor: Colors.black54,
                )
                .titleLarge,
      ),
      colorScheme: ColorScheme.fromSwatch()
          .copyWith(secondary: colorAccentLight)
          .copyWith(background: Colors.grey[500]!.withOpacity(.8)),
    ),
  ];

  int idxcurrentTheme = 0;
  ThemeData get theme => themes[idxcurrentTheme];
  int get currentTheme => idxcurrentTheme;

  changeTheme(bool isUpdate) {
    if (isUpdate) {
      idxcurrentTheme = (idxcurrentTheme == 0) ? 1 : 0;
      _sharedPrefs.write(tHEMEKEY, idxcurrentTheme);
      setItemTheme(idxcurrentTheme);
    }

    Get.changeTheme(theme);
    Get.changeThemeMode(
        idxcurrentTheme == 0 ? ThemeMode.dark : ThemeMode.light);

    //print(Get.isDarkMode);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarIconBrightness:
            idxcurrentTheme == 0 ? Brightness.dark : Brightness.light,
        statusBarBrightness:
            idxcurrentTheme == 0 ? Brightness.dark : Brightness.light,

        systemNavigationBarColor: idxcurrentTheme == 0
            ? Colors.black45
            : const Color(0xffd0d0d0), // navigation bar color
        statusBarColor: idxcurrentTheme == 0
            ? Colors.black87.withOpacity(0.5)
            : Colors.grey[600]!.withOpacity(0.5),
      ),
    );

    debugPrint("[ObHomeController] idxcurrentTheme $idxcurrentTheme");
    //update();
  }

  final NotificationHelper _notificationHelper = NotificationHelper.instance;
  NotificationHelper get notificationHelper => _notificationHelper;

  createNotif(String titleNotif, String descNotif, int id, dynamic payload) {
    notificationHelper.scheduleNotification(
      titleNotif,
      descNotif,
      const Duration(milliseconds: 1200),
      id,
      payload,
    );
  }

  final PushNotificationsManager _pushNotificationsManager =
      PushNotificationsManager();

  PushNotificationsManager get pushNotificationsManager =>
      _pushNotificationsManager;

  String _thisUuid = "";
  String get thisUuid => _thisUuid;

  firstCall() async {
    //Future.delayed((Duration.zero), () async {
    _sharedPrefs = GetStorage(nAMEStorage);
    idxcurrentTheme = _sharedPrefs.read(tHEMEKEY) ?? 0;

    _thisUuid = _sharedPrefs.read('uuid') ?? const Uuid().v1();
    _sharedPrefs.write('uuid', _thisUuid);

    debugPrint(
        "[ObHomeController] set theme $idxcurrentTheme, _thisUuid: $_thisUuid");

    // trying registration member
    //if (getFirst() == 0) {
    await _pushNotificationsManager.init();

    secondCall();
    //}

    _favorites = {};
    List<dynamic> dataFavs = _sharedPrefs.read(fAVORITESKEY);
    try {
      if (dataFavs.isNotEmpty) {
        _favorites.addAll(dataFavs.map(
            (dynamic value) => MediaItem.fromPrefsJson(json.decode(value))));
      }
    } catch (_) {}

    _getLatest = {};
    List<dynamic> dataLatest = _sharedPrefs.read(lATEST);
    try {
      if (dataLatest.isNotEmpty) {
        _getLatest.addAll(dataLatest.map(
            (dynamic value) => LatestItem.fromPrefsJson(json.decode(value))));
      }
    } catch (_) {}

    debugPrint("[ObHomeController] _getLatest.length ${_getLatest.length}");

    itemFavs.update((value) {
      value!.item = null;
      value.allFavs = favoriteAll;
      value.movieFavs = favoriteMovies;
      value.showFavs = favoriteShows;
    });
  }

  dynamic _member;
  dynamic get member => _member;
  bool isProcessAsync = false;
  secondCall() async {
    debugPrint(
        "[ObHomeController] secondCall.. running...isProcessAsync $isProcessAsync pushProccess: $pushProccess");

    if (isProcessAsync) return;

    if (pushProccess) return;

    try {
      isProcessAsync = true;
      String dataMember = getMember();
      String idmember = "";
      String nmmember = "";
      String emmember = "";
      String tpmember = "1";
      String stmember = "1";
      String passwd = "${Random().nextInt(99999)}";
      String dataCreated = "";
      if (dataMember != '') {
        _member = jsonDecode(dataMember);
        idmember = _member['id_member'];
        nmmember = _member['nm_member'];
        emmember = _member['email'];
        tpmember = _member['tipe'] ?? "1";
        stmember = _member['status'] ?? "1";
        passwd = member['real_passwd'];
        dataCreated = member['date_created'];
      }

      // push auto insert member
      // "eUmUVFw_TbGKp_4DGhzWKQ:APA91bGFSLbKKXYRI2TvEECnmUE7BlfMQGMpqKJ4rNSnWfqPF0pUMpkKIkeEsym5l_CQSAZ7lh7iC9p7CEJYNciK69uB3AaQzYbM9XI6yO5VPNQyrGYqBNE6v4mTzlfyDWjs1IJhWxIS"
      var dataPush = {
        "id": idmember,
        "nm": nmmember,
        "em": emmember,
        "dc": dataCreated,
        "ps": passwd,
        "tp": tpmember,
        "st": stmember,
        "is_from": aPPNAME,
        "is_os": GetPlatform.isAndroid ? "Android" : "iOS",
        "uuid": thisUuid,
        "fb_token": getToken(),
      };

      debugPrint(jsonEncode(dataPush));

      final response = await pushResponse("member/insert_update/", dataPush);
      //debugPrint(response.bodyString!);

      if (response != null && response.statusCode == 200) {
        dynamic dtresultPush = jsonDecode(response.bodyString!);
        //print(dtresultPush);

        if (dtresultPush['code'] == '200') {
          if (dtresultPush['result'][0] != null) {
            String respMember = jsonEncode(dtresultPush['result'][0]);
            saveMember(respMember);
          }
        }
      }
    } catch (e) {
      debugPrint("[ObHomeController] secondCall error ${e.toString()}");
    }

    Future.delayed(const Duration(seconds: 10), () {
      isProcessAsync = false;
    });
  }

  bool isProcessInsertUpdate = false;
  insertUpdateMember(dynamic arrayPush, bool isLogin) async {
    debugPrint(
        "[ObHomeController] insertUpdateMember.. running...isProcessInsertUpdate: $isProcessInsertUpdate");

    if (isProcessInsertUpdate) return;

    try {
      isProcessInsertUpdate = true;
      String dataMember = getMember();
      String idmember = "";
      String dataCreated = "";
      String tpmember = "1";
      String stmember = "1";
      if (dataMember != '') {
        _member = jsonDecode(dataMember);
        idmember = _member['id_member'];
        tpmember = _member['tipe'];
        stmember = _member['status'];
        dataCreated = member['date_created'];
      }

      // push auto insert member
      // "eUmUVFw_TbGKp_4DGhzWKQ:APA91bGFSLbKKXYRI2TvEECnmUE7BlfMQGMpqKJ4rNSnWfqPF0pUMpkKIkeEsym5l_CQSAZ7lh7iC9p7CEJYNciK69uB3AaQzYbM9XI6yO5VPNQyrGYqBNE6v4mTzlfyDWjs1IJhWxIS"
      var dataPush = {
        "id": idmember,
        "nm": arrayPush['nm'],
        "em": arrayPush['em'],
        "dc": dataCreated,
        "ps": arrayPush['ps'],
        "tp": arrayPush['tp'] ?? tpmember,
        "st": stmember,
        "reg": arrayPush['reg'] ?? "",
        "is_from": aPPNAME,
        "is_os": GetPlatform.isAndroid ? "Android" : "iOS",
        "uuid": thisUuid,
        "fb_token": getToken(),
      };

      //debugPrint(dataPush);

      final response = await pushResponse(
          isLogin ? "member/login/" : "member/insert_update/", dataPush);
      //debugPrint(response.bodyString!);
      var checkError = isLogin ? false : true;

      if (response != null && response.statusCode == 200) {
        dynamic dtresultPush = jsonDecode(response.bodyString!);
        //debugPrint(dtresultPush);
        if (dtresultPush['code'] == '200' || dtresultPush['code'] == '201') {
          if (dtresultPush['result'][0] != null) {
            String respMember = jsonEncode(dtresultPush['result'][0]);
            //debugPrint(respMember);
            saveMember(respMember);
            toggleLogin(true, null);
          }
        } else {
          toggleLogin(checkError,
              "Error:\nTry again later...${dtresultPush['message']}");
        }
      } else {
        toggleLogin(checkError, "Error:\nTry again later...");
      }
    } catch (e) {
      debugPrint("[ObHomeController] insertUpdateMember error ${e.toString()}");
    }

    Future.delayed(const Duration(seconds: 5), () {
      isProcessInsertUpdate = false;
    });
  }

  logoutMember() async {
    //debugPrint(
    //    "[ObHomeController] insertUpdateMember.. running...isProcessInsertUpdate: $isProcessInsertUpdate");

    if (isProcessInsertUpdate) return;

    try {
      isProcessInsertUpdate = true;
      String dataMember = getMember();
      String idmember = "";
      if (dataMember != '') {
        _member = jsonDecode(dataMember);
        idmember = _member['id_member'];
      }

      // push auto insert member
      // "eUmUVFw_TbGKp_4DGhzWKQ:APA91bGFSLbKKXYRI2TvEECnmUE7BlfMQGMpqKJ4rNSnWfqPF0pUMpkKIkeEsym5l_CQSAZ7lh7iC9p7CEJYNciK69uB3AaQzYbM9XI6yO5VPNQyrGYqBNE6v4mTzlfyDWjs1IJhWxIS"
      var dataPush = {
        "id": idmember,
        "uuid": thisUuid,
        "fb_token": getToken(),
      };

      //debugPrint(dataPush);

      final response = await pushResponse("member/logout/", dataPush);
      //debugPrint(response.bodyString!);

      if (response != null && response.statusCode == 200) {
        dynamic dtresultPush = jsonDecode(response.bodyString!);
        //debugPrint(dtresultPush);
        if (dtresultPush['code'] == '200' || dtresultPush['code'] == '201') {
          if (dtresultPush['result'][0] != null) {
            String respMember = jsonEncode(dtresultPush['result'][0]);
            //debugPrint(respMember);
            saveMember(respMember);
            toggleLogin(false, null);
          }
        } else {
          toggleLogin(false, "Error:\nTry again later...");
        }
      } else {
        toggleLogin(false, "Error:\nTry again later...");
      }
    } catch (e) {
      debugPrint("[ObHomeController] insertUpdateMember error ${e.toString()}");
    }

    Future.delayed(const Duration(seconds: 30), () {
      isProcessInsertUpdate = false;
    });
  }

  @override
  void onInit() {
    super.onInit();
    firstCall();

    debugPrint("[ObHomeController] onInit");
    //fetchHome(true);
  }

  bool isToggle = false;
  var itemScreen = OrientationItem().obs;
  toggleOrientation(Orientation dtorientation) {
    //debugPrint("toggleOrientation checking isToggle $isToggle");

    if (isToggle) return;
    //debugPrint("toggleOrientation $dtorientation");

    SystemChrome.setPreferredOrientations(dtorientation == Orientation.landscape
            ? <DeviceOrientation>[
                DeviceOrientation.landscapeLeft,
                DeviceOrientation.landscapeRight,
              ]
            : <DeviceOrientation>[
                DeviceOrientation.portraitUp,
                DeviceOrientation.portraitDown,
              ])
        .then((value) => isToggle = true);

    itemScreen.update((value) {
      value!.orientation = dtorientation;
      value.height =
          dtorientation == Orientation.landscape ? Get.height : Get.height / 3;

      Future.delayed(const Duration(milliseconds: 400 * 2), () {
        //isToggle = true;
      });
    });

    Future.delayed(const Duration(milliseconds: 1000 * 2), () {
      isToggle = false;
    });
    //update();
  }

  var count = 0.obs;
  increment() => count + 1;

  var idxTap = IndexTap().obs;
  setIndex(int tabIdx) {
    idxTap.update((value) {
      value!.index = tabIdx;
      value.currentTheme = currentTheme;
    });
  }

  var itemTheme = ItemTheme().obs;
  setItemTheme(int idxcurrentTheme) {
    itemTheme.update((value) {
      value!.currentTheme = currentTheme;
    });
  }

  var itemSubPlay = MoviePlay().obs;
  setItemPlay(final MediaItem item, final dynamic trailer,
      final List<dynamic> trailers) async {
    itemSubPlay.update((value) {
      value!.item = item;
      value.trailer = null;
      value.trailers = [];
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      itemSubPlay.update((value) {
        value!.item = item;
        value.trailer = trailer;
        value.trailers = trailers;
      });
    });
  }

  bool pushProccess = false;
  var itemSub = PassingItem().obs;
  setItemPass(MediaItem item, bool isPush, link) async {
    if (isPush) {
      pushProccess = true;

      Future.delayed(const Duration(seconds: 10), () {
        pushProccess = false;
      });
    }

    dynamic result;
    itemSub.update((value) {
      value!.item = item;
      value.result = result;
      value.cast = [];
      value.similar = [];
      value.videos = result;
      value.images = result;
    });

    if (isPush) {
      try {
        var detailMovies = (item.type == MediaType.movie)
            ? await movieProvider.getDetails(item.id)
            : await showProvider.getDetails(item.id);

        List<Actor> cast = (item.type == MediaType.movie)
            ? await movieProvider.loadCast(item.id)
            : await showProvider.loadCast(item.id);

        List<MediaItem> similar = (item.type == MediaType.movie)
            ? await movieProvider.getSimilar(item.id)
            : await showProvider.getSimilar(item.id);

        var videos = (item.type == MediaType.movie)
            ? await movieProvider.getVideos(item.id)
            : await showProvider.getVideos(item.id);

        var images = (item.type == MediaType.movie)
            ? await movieProvider.getImages(item.id)
            : await showProvider.getImages(item.id);

        //debugPrint(similar);

        if (detailMovies != null && detailMovies.length > 0) {
          itemSub.update((value) {
            value!.item = item;
            value.result = detailMovies;
            value.cast = cast;
            value.similar = similar;
            value.videos = videos;
            value.images = images;
          });
        } else {
          debugPrint("[ObHomeController] enter thiss");
        }
      } catch (e) {
        debugPrint("[ObHomeController] error22222 ${e.toString()}");
      }
    }
  }

  //TVShow ResponseItem
  final ShowProvider showProvider = ShowProvider();
  var itemRespTV = ResponseItemTV().obs;
  setItemRespTV(dynamic item, dynamic param, String link) async {
    debugPrint("[ObHomeController] setItemRespTV running.. ");

    dynamic result;
    itemRespTV.update((value) {
      value!.item = item;
      value.result = result;
      value.trending = result;
      value.popular = result;
      value.upcoming = result;
      value.toprated = result;
      value.latest = result;
    });

    debugPrint(jsonEncode(param));

    try {
      var nowplaying =
          await showProvider.loadMedia(param['category'], page: param['page']);
      var trending = await showProvider.loadMedia("trending", page: 1);
      var popular = await showProvider.loadMedia("popular", page: 1);
      var upcoming = await showProvider.loadMedia("upcoming", page: 1);
      var toprated = await showProvider.loadMedia("top_rated", page: 1);
      var latest = await showProvider.getLatest();
      //debugPrint(latest);

      if (nowplaying.isNotEmpty) {
        itemRespTV.update((value) {
          value!.item = item;
          value.result = nowplaying;
          value.trending = trending;
          value.popular = popular;
          value.upcoming = upcoming;
          value.toprated = toprated;
          value.latest = latest;
        });

        saveTrendingOthersTV(jsonEncode(nowplaying), 1);
        saveTrendingOthersTV(jsonEncode(popular), 2);
        saveTrendingOthersTV(jsonEncode(upcoming), 3);
        saveTrendingOthersTV(jsonEncode(toprated), 4);
        saveTrendingOthersTV(jsonEncode(trending), 5);
        saveTrendingOthersTV(jsonEncode(latest), 6);
      } else {
        loadLocalDataMediaTV(item);
      }
    } catch (e) {
      debugPrint("[ObHomeController] error ${e.toString()}");
      loadLocalDataMediaTV(item);
    }
  }

  loadLocalDataMediaTV(item) {
    var nowplaying = getTrendingOthersTV(1);
    //debugPrint(trending);
    var popular = getTrendingOthersTV(2);
    var upcoming = getTrendingOthersTV(3);
    var toprated = getTrendingOthersTV(4);
    var trending = getTrendingOthersTV(5);
    var latest = {};
    //getTrendingOthersTV(6);

    itemRespTV.update((value) {
      value!.item = item;
      value.result = nowplaying;
      value.trending = trending;
      value.popular = popular;
      value.upcoming = upcoming;
      value.toprated = toprated;
      value.latest = latest;
    });
  }
  // TV Show ResponseItem

  // ResponseItem
  final MediaProvider movieProvider = MovieProvider();
  var itemResp = ResponseItem().obs;
  setItemResp(dynamic item, dynamic param) async {
    debugPrint("[ObHomeController] setItemResp running.. ");

    dynamic result;
    itemResp.update((value) {
      value!.item = item;
      value.result = result;
      value.trending = result;
      value.popular = result;
      value.upcoming = result;
      value.toprated = result;
      value.latest = result;
    });

    debugPrint(jsonEncode(param));

    try {
      var nowplaying =
          await movieProvider.loadMedia(param['category'], page: param['page']);
      //print(nowplaying);
      var trending = await movieProvider.loadMedia("trending", page: 1);
      var popular = await movieProvider.loadMedia("popular", page: 1);
      var upcoming = await movieProvider.loadMedia("upcoming", page: 1);
      var toprated = await movieProvider.loadMedia("top_rated", page: 1);
      var latest = await movieProvider.getLatest();
      //print(latest);

      if (latest != null) {
        debugPrint("[ObHomeController] check000 latest...");
        LatestItem itemLatest = LatestItem(latest, MediaType.movie);
        //print(itemLatest.toJson());

        if (itemLatest.id != 0) {
          if (!isItemLatest(itemLatest)) {
            debugPrint("[ObHomeController] add item new latest...");

            if (_getLatest.length > 100) {
              _getLatest = {};
            }
            _getLatest.add(itemLatest);
          }
        }
      }

      debugPrint("[ObHomeController] check111 latest...");

      if (nowplaying.isNotEmpty) {
        itemResp.update((value) {
          value!.item = item;
          value.result = nowplaying;
          value.trending = trending;
          value.popular = popular;
          value.upcoming = upcoming;
          value.toprated = toprated;
          value.latest = _getLatest;
        });

        saveTrendingOthers(jsonEncode(trending), 1);
        saveTrendingOthers(jsonEncode(popular), 2);
        saveTrendingOthers(jsonEncode(upcoming), 3);
        saveTrendingOthers(jsonEncode(toprated), 4);
        saveTrendingOthers(jsonEncode(nowplaying), 5);
        saveTrendingOthers("", 6);
      } else {
        loadLocalDataMedia(item);
      }
    } catch (e) {
      debugPrint("[ObHomeController] error11111 ${e.toString()}");
      loadLocalDataMedia(item);
    }
  }

  nextSetItemResp(dynamic item, dynamic param) async {
    try {
      var nowplaying =
          await movieProvider.loadMedia(param['category'], page: param['page']);
      //debugPrint(nowplaying);
      var trending = await movieProvider.loadMedia("trending", page: 1);
      var popular = await movieProvider.loadMedia("popular", page: 1);
      var upcoming = await movieProvider.loadMedia("upcoming", page: 1);
      var toprated = await movieProvider.loadMedia("top_rated", page: 1);
      //var latest = [];
      var latest = await movieProvider.getLatest();
      if (latest != null) {
        LatestItem itemLatest = LatestItem(latest, MediaType.movie);
        if (!isItemLatest(itemLatest)) {
          debugPrint("[ObHomeController] add item new latest...");
          //debugPrint(itemLatest.toJson());

          if (_getLatest.length > 100) {
            _getLatest = {};
          }

          _getLatest.add(itemLatest);
        }
      }

      //debugPrint(LatestItem(latest, MediaType.movie).toJson());

      if (nowplaying.isNotEmpty) {
        itemResp.update((value) {
          value!.item = item;
          value.result = nowplaying;
          value.trending = trending;
          value.popular = popular;
          value.upcoming = upcoming;
          value.toprated = toprated;
          value.latest = _getLatest;
        });

        saveTrendingOthers(jsonEncode(trending), 1);
        saveTrendingOthers(jsonEncode(popular), 2);
        saveTrendingOthers(jsonEncode(upcoming), 3);
        saveTrendingOthers(jsonEncode(toprated), 4);
        saveTrendingOthers(jsonEncode(nowplaying), 5);
        saveTrendingOthers("", 6);
      } else {
        loadLocalDataMedia(item);
      }
    } catch (e) {
      debugPrint("[ObHomeController] error ${e.toString()}");
      loadLocalDataMedia(item);
    }
  }

  loadLocalDataMedia(item) {
    var trending = getTrendingOthers(1);
    var popular = getTrendingOthers(2);
    var upcoming = getTrendingOthers(3);
    var toprated = getTrendingOthers(4);
    var nowplaying = getTrendingOthers(5);
    var latest = {};
    //getTrendingOthers(6);

    itemResp.update((value) {
      value!.item = item;
      value.result = nowplaying;
      value.trending = trending;
      value.popular = popular;
      value.upcoming = upcoming;
      value.toprated = toprated;
      value.latest = latest;
    });
  }
  // ResponseItem

  var jsonHome = Result().obs;
  fetchHome(bool isFirst) async {
    Future.delayed(const Duration(milliseconds: 400), () {
      debugPrint("[ObHomController] fetchHome is running...isFirst: $isFirst");
      if (pushProccess) return;

      //var dataItem = {};
      if (!isFirst) {
        //loadLocalDataMedia({});
        nextSetItemResp({}, {"category": "now_playing", "page": 1});
      } else {
        setItemResp({}, {"category": "now_playing", "page": 1});
      }
    });
  }

  List<MediaItem> get favoriteMovies => _favorites
      .where((MediaItem item) => item.type == MediaType.movie)
      .toList();

  List<MediaItem> get favoriteShows => _favorites
      .where((MediaItem item) => item.type == MediaType.show)
      .toList();

  List<MediaItem> get favoriteAll => _favorites.toList();

  bool isItemFavorite(MediaItem item) =>
      _favorites.where((MediaItem media) => media.id == item.id).length == 1;

  bool isItemLatest(LatestItem item) =>
      _getLatest.where((LatestItem media) => media.id == item.id).length == 1;

  var itemFavs = ItemFavs().obs;
  setNullFavs() {
    itemFavs.update((value) {
      value!.item = null;
      value.allFavs = favoriteAll;
      value.movieFavs = favoriteMovies;
      value.showFavs = favoriteShows;
    });
  }

  toggleFavorites(MediaItem favoriteItem) {
    !isItemFavorite(favoriteItem)
        ? _favorites.add(favoriteItem)
        : _favorites
            .removeWhere((MediaItem item) => item.id == favoriteItem.id);

    itemFavs.update((value) {
      value!.item = favoriteItem;
      value.allFavs = favoriteAll;
      value.movieFavs = favoriteMovies;
      value.showFavs = favoriteShows;
    });

    sharedPrefs.write(
        fAVORITESKEY,
        favoriteAll
            .map((MediaItem favoriteItem) => jsonEncode(favoriteItem.toJson()))
            .toList());
  }

  // additional push
  static const String _baseUrl = "https://in-news.id/apimember/"; //member/";
  static const Duration _timeout = Duration(seconds: 210);
  static const aUTHAPI = 'dGhlYXRlcmlmeS5pZA==';
  //final Client _client = Client();

  Future<Response?>? pushResponse(String path, dynamic parameter) async {
    return GetConnect().post(
      "$_baseUrl/$path",
      json.encode(parameter),
      contentType: 'application/json; charset=UTF-8',
      headers: {
        "Content-Type": "application/json",
        "Authentication": "Basic $aUTHAPI",
      },
    ).timeout(_timeout);

    /*.post("$_baseUrl/$path",
            headers: {
              "Content-Type": "application/json",
              "Authentication": "Basic $AUTH_API",
            },
            body: json.encode(parameter))
        .timeout(_timeout);*/
  }
}
