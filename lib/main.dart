import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:whattheysee/components/ob_homecontroller.dart';
import 'package:whattheysee/home.dart';
import 'package:whattheysee/intro_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init(ObHomeController.nAMEStorage);

  Get.lazyPut<ObHomeController>(
      () => ObHomeController(GetStorage(ObHomeController.nAMEStorage)));

  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then(
    (_) {
      final ObHomeController controller = ObHomeController.to;
      int currTheme =
          controller.sharedPrefs.read(ObHomeController.tHEMEKEY) ?? 0;

      return runApp(GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light().copyWith(
          primaryColor: primaryLight,
          primaryColorDark: primaryDarkLight,
          visualDensity: VisualDensity.adaptivePlatformDensity, //.orangeSoft,
          indicatorColor: const Color(0xFFF3FBD8),
          canvasColor: whiteColor,
          appBarTheme: AppBarTheme(backgroundColor: primaryLight),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Colors.white,
          ),
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(secondary: colorAccentLight)
              .copyWith(background: Colors.grey[500]!.withOpacity(.8)),
        ),
        darkTheme: ThemeData.dark().copyWith(
          primaryColor: primary,
          primaryColorDark: primaryDark,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          indicatorColor: const Color(0xFFF4D72E),
          iconTheme: const IconThemeData(color: Colors.white70),
          canvasColor: blackColor,
          dialogBackgroundColor: Colors.grey[600],
          appBarTheme: AppBarTheme(backgroundColor: primary),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Colors.black12,
          ),
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(secondary: colorAccent)
              .copyWith(background: Colors.grey[900]!.withOpacity(0.8)),
        ),
        themeMode: currTheme == 0 ? ThemeMode.dark : ThemeMode.light,
        home: const Splash(),
        builder: (BuildContext? context, Widget? child) {
          return FlutterEasyLoading(child: child);
        },
      ));
    },
  );
}

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _Splash();
  }
}

class _Splash extends State<Splash> {
  @override
  void initState() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.dark
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..successWidget = const Icon(Feather.check_circle, color: Colors.white)
      ..backgroundColor = Get.theme.colorScheme.background
      ..indicatorColor = Get.theme.colorScheme.secondary
      //..textColor = Colors.yellow
      ..maskColor = Colors.blue.withOpacity(0.5)
      ..userInteractions = true;

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    super.initState();

    if (!mounted) return;

    final ObHomeController c = ObHomeController.to;
    c.fetchHome(true);

    Timer(const Duration(milliseconds: 2200), () {
      c.changeTheme(false);

      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: SystemUiOverlay.values);
      Get.off(c.getFirst() == 1 ? const HomePage() : const OnBoardingPage());
    });

    // 60 detik == 1 x 15 == 15min
    Timer.periodic(const Duration(seconds: 60 * 10), (timer) async {
      c.secondCall();
      c.fetchHome(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: secondaryColor,
        body: SizedBox(
          height: Get.height,
          width: Get.width,
          child: Stack(
            children: [
              Container(
                width: Get.width,
                height: Get.height,
                alignment: FractionalOffset.center,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "assets/icon1.png",
                        width: 90,
                        height: 90,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: '${ObHomeController.aPPNAME}\n',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            TextSpan(
                              text: ObHomeController.aPPVERSION,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 50,
                left: 0,
                right: 0,
                child: Container(
                    margin: const EdgeInsets.only(top: 20),
                    width: 20,
                    height: 20,
                    child: Column(
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            backgroundColor: Get.theme.primaryColor,
                          ),
                        ),
                      ],
                    )),
              )
            ],
          ),
        ));
  }
}

// --------------------------------------------
