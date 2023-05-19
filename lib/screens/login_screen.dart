import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:get/get.dart';
import 'package:whattheysee/components/custom_sheet.dart';
import 'package:whattheysee/components/ob_homecontroller.dart';
import 'package:whattheysee/components/photo_hero.dart';
import 'package:whattheysee/screens/account_screen.dart';

class LoginScreen extends StatefulWidget {
  final Function(dynamic data) onLogin;
  const LoginScreen({Key? key, required this.onLogin}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  Widget homePage() {
    return Container(
      height: Get.height,
      decoration: BoxDecoration(
        color: Get.theme.primaryColor,
        image: DecorationImage(
          colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.1), BlendMode.dstATop),
          image: const AssetImage('assets/images/mountains.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 60.0),
            child: Center(
              child: Image.asset(
                Get.isDarkMode ? "assets/icon1.png" : "assets/icon1.png",
                width: 60,
                height: 60,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  ObHomeController.aPPNAME,
                  style: TextStyle(
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                    fontSize: 20.0,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: Get.width,
            margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 80.0),
            alignment: Alignment.center,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      backgroundColor: mainColor,
                      //: Colors.grey,
                      //borderSide: const BorderSide(width: 1.0, color: mainColor),
                    ),
                    onPressed: () => gotoSignup(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 20.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              "SIGN UP",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: Get.mediaQuery.size.width,
            margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0),
            alignment: Alignment.center,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () => gotoLogin(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 20.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          Expanded(
                            child: Text(
                              "LOGIN",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: mainColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String textForgotPasswd =
      "Please send email to ${ObHomeController.eMAILADDRESS}, Subject Forgot Password with your registered email. Process within 24 hours. Thank you. ";

  Widget loginPage() {
    _emController.clear();
    _psController.clear();

    return Container(
      height: Get.height,
      decoration: BoxDecoration(
        color: Get.theme.primaryColor,
        image: DecorationImage(
          colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.05), BlendMode.dstATop),
          image: const AssetImage('assets/images/mountains.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Image.asset(
                  Get.isDarkMode ? "assets/icon1.png" : "assets/icon1.png",
                  width: 60,
                  height: 60,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 10.0),
              margin: const EdgeInsets.only(bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    ObHomeController.aPPNAME,
                    style: TextStyle(
                      color: Get.isDarkMode ? Colors.white : Colors.black,
                      fontSize: 20.0,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: const <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 40.0),
                    child: Text(
                      "EMAIL",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: mainColor,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: Get.width,
              margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 0.0),
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 0.0, right: 10.0),
              child: TextField(
                maxLength: 30,
                controller: _emController,
                obscureText: false,
                textAlign: TextAlign.left,
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: mainColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: mainColor),
                  ),
                  hintText: 'Email',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            const Divider(
              height: 10.0,
            ),
            Row(
              children: const <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 40.0),
                    child: Text(
                      "PASSWORD",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: mainColor,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: Get.mediaQuery.size.width,
              margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 0.0),
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 0.0, right: 10.0),
              child: TextField(
                maxLength: 15,
                controller: _psController,
                obscureText: true,
                textAlign: TextAlign.left,
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: mainColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: mainColor),
                  ),
                  hintText: '*********',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            const Divider(
              height: 5.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: TextButton(
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: mainColor,
                        fontSize: 15.0,
                      ),
                      textAlign: TextAlign.end,
                    ),
                    onPressed: () {
                      CustomBottomSheet.showScrollModalBottomSheet(
                        heightPercView: 0.70,
                        context: Get.context!,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  Get.isDarkMode ? Colors.white : Colors.black,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Stack(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Text("\n$textForgotPasswd\n"),
                                ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: InkWell(
                                    onTap: () {
                                      Get.back();
                                    },
                                    child: const Icon(FontAwesome.times),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Container(
              width: Get.mediaQuery.size.width,
              margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
              alignment: Alignment.center,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        backgroundColor: mainColor,
                      ),
                      onPressed: () => {pushLogin()},
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20.0,
                          horizontal: 20.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Expanded(
                              child: Text(
                                "LOGIN",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: Get.mediaQuery.size.width,
              margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
              alignment: Alignment.center,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () => {gotoSignup()},
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20.0,
                          horizontal: 20.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Expanded(
                              child: Text(
                                "SIGN UP with EMAIL",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }

  Widget buttonAppleFacebook() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 8.0),
            alignment: Alignment.center,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      backgroundColor: Colors.black87,
                    ),
                    onPressed: () => {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                              padding: const EdgeInsets.only(
                                top: 20.0,
                                bottom: 20.0,
                              ),
                            ),
                            onPressed: () => {PhotoHero.comingSoon()},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: const <Widget>[
                                Icon(
                                  FontAwesome.apple,
                                  color: Colors.white,
                                  size: 15.0,
                                ),
                                Text(
                                  "APPLE ID",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 8.0),
            alignment: Alignment.center,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      backgroundColor: const Color(0Xff3B5998),
                    ),
                    onPressed: () => {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                              padding: const EdgeInsets.only(
                                top: 20.0,
                                bottom: 20.0,
                              ),
                            ),
                            onPressed: () => PhotoHero.comingSoon(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: const <Widget>[
                                Icon(
                                  FontAwesome.facebook,
                                  color: Colors.white,
                                  size: 15.0,
                                ),
                                Text(
                                  "FACEBOOK",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buttonFacebookGoogle() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 8.0),
            alignment: Alignment.center,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      backgroundColor: const Color(0Xff3B5998),
                    ),
                    onPressed: () => {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                              padding: const EdgeInsets.only(
                                top: 20.0,
                                bottom: 20.0,
                              ),
                            ),
                            onPressed: () => PhotoHero.comingSoon(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: const <Widget>[
                                Icon(
                                  FontAwesome.facebook,
                                  color: Colors.white,
                                  size: 15.0,
                                ),
                                Text(
                                  "FACEBOOK",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 8.0),
            alignment: Alignment.center,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      backgroundColor: const Color(0Xffdb3236),
                    ),
                    onPressed: () => {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                              padding: const EdgeInsets.only(
                                top: 20.0,
                                bottom: 20.0,
                              ),
                            ),
                            onPressed: () => PhotoHero.comingSoon(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: const <Widget>[
                                Icon(
                                  FontAwesome.google,
                                  color: Colors.white,
                                  size: 15.0,
                                ),
                                Text(
                                  "GOOGLE",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  pushSignUp() async {
    debugPrint("[LoginScreen] pushSignUp...");
    try {
      String nm = _nmController.text;
      String em = _emController.text;
      String ps = _psController.text;
      String rp = _rpController.text;

      debugPrint("[LoginScreen] email $em... password: $ps");

      //EasyLoading.show(status: 'Loading...');
      if (nm.trim().isEmpty) {
        EasyLoading.showToast("Name required...");
        return;
      }

      if (em.trim().isEmpty) {
        EasyLoading.showToast("Email required...");
        return;
      }

      if (!PhotoHero.checkValidEmail(em.trim())) {
        EasyLoading.showToast("Email invalid...");
        return;
      }

      if (ps.trim().length < 6) {
        EasyLoading.showToast("Password required... Min 6 character");
        return;
      }

      if (rp.trim().length < 6) {
        EasyLoading.showToast("Confirm password required... Min 6 character");
        return;
      }

      if (ps.trim() != rp.trim()) {
        EasyLoading.showToast("Password invalid...");
        return;
      }

      EasyLoading.show(status: 'Loading...');
      await Future.delayed(const Duration(milliseconds: 500), () {
        var arrayPush = {
          "nm": nm,
          "em": em,
          "ps": ps,
          "reg": "1",
        };

        ObHomeController.to.insertUpdateMember(arrayPush, false);

        Future.delayed(const Duration(milliseconds: 1500), () {
          if (ObHomeController.to.itemLogin.value.message != null) {
            EasyLoading.showError(ObHomeController.to.itemLogin.value.message!);
          } else {
            try {
              _nmController.clear();
              _emController.clear();
              _rpController.clear();
              _psController.clear();
            } catch (e) {
              debugPrint("");
            }

            Future.delayed(const Duration(milliseconds: 1100), () {
              ObHomeController.to.toggleLogin(true, null);
              gotoLoginHome();
            });
            EasyLoading.showSuccess('Process Success!');
          }
        });
      });
    } catch (e) {
      debugPrint("[LoginScreen] errror ${e.toString()}");
    }
  }

  pushLogin() async {
    debugPrint("[LoginScreen] pushLogin...");
    try {
      String em = _emController.text;
      String ps = _psController.text;

      debugPrint("[LoginScreen] email $em... password: $ps");

      if (em.trim().isEmpty) {
        EasyLoading.showToast("Email required...");
        return;
      }

      if (ps.trim().length < 6) {
        EasyLoading.showToast("Password required... Min 6 character");
        return;
      }

      String dataMember = ObHomeController.to.getMember();
      String nmMember = "";
      if (dataMember != '') {
        var dtmember = jsonDecode(dataMember);
        nmMember = dtmember['nmdtmember'];
      }

      var arrayPush = {
        "nm": nmMember,
        "em": em,
        "ps": ps,
        "tp": "1",
      };

      widget.onLogin(arrayPush);

      try {
        _emController.clear();
        _psController.clear();
      } catch (e) {
        debugPrint("");
      }
    } catch (e) {
      debugPrint("[LoginScreen] errror ${e.toString()}");
    }
  }

  final TextEditingController _nmController = TextEditingController();
  final TextEditingController _emController = TextEditingController();
  final TextEditingController _psController = TextEditingController();
  final TextEditingController _rpController = TextEditingController();

  Widget signupPage() {
    _emController.clear();
    _psController.clear();

    return Container(
      height: Get.mediaQuery.size.height,
      decoration: BoxDecoration(
        color: Get.theme.primaryColor,
        image: DecorationImage(
          colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.05), BlendMode.dstATop),
          image: const AssetImage('assets/images/mountains.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Image.asset(
                  Get.isDarkMode ? "assets/icon1.png" : "assets/icon1.png",
                  width: 60,
                  height: 60,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 10.0),
              margin: const EdgeInsets.only(bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    ObHomeController.aPPNAME,
                    style: TextStyle(
                      color: Get.isDarkMode ? Colors.white : Colors.black,
                      fontSize: 20.0,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: const <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 40.0),
                    child: Text(
                      "Name",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: mainColor,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: Get.mediaQuery.size.width,
              margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 0.0),
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 0.0, right: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _nmController,
                      maxLength: 50,
                      textAlign: TextAlign.left,
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: mainColor),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: mainColor),
                        ),
                        hintText: 'Name',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              height: 10.0,
            ),
            Row(
              children: const <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 40.0),
                    child: Text(
                      "EMAIL",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: mainColor,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: Get.mediaQuery.size.width,
              margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 0.0),
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 0.0, right: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _emController,
                      maxLength: 30,
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.left,
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: mainColor),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: mainColor),
                        ),
                        hintText: 'Email',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              height: 10.0,
            ),
            Row(
              children: const <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 40.0),
                    child: Text(
                      "PASSWORD",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: mainColor,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: Get.mediaQuery.size.width,
              margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 0.0),
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 0.0, right: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _psController,
                      obscureText: true,
                      maxLength: 15,
                      textAlign: TextAlign.left,
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: mainColor),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: mainColor),
                        ),
                        hintText: '*********',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              height: 10.0,
            ),
            Row(
              children: const <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 40.0),
                    child: Text(
                      "CONFIRM PASSWORD",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: mainColor,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: Get.mediaQuery.size.width,
              margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 0.0),
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 0.0, right: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _rpController,
                      obscureText: true,
                      maxLength: 15,
                      textAlign: TextAlign.left,
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: mainColor),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: mainColor),
                        ),
                        hintText: '*********',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: TextButton(
                    child: const Text(
                      "Already have an account?",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: mainColor,
                        fontSize: 15.0,
                      ),
                      textAlign: TextAlign.end,
                    ),
                    onPressed: () => {gotoLogin()},
                  ),
                ),
              ],
            ),
            Container(
              width: Get.width,
              margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
              alignment: Alignment.center,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        backgroundColor: mainColor,
                      ),
                      onPressed: () => {pushSignUp()},
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20.0,
                          horizontal: 20.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Expanded(
                              child: Text(
                                "SIGN UP",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }

  gotoLogin() {
    _controller.animateToPage(
      0,
      duration: const Duration(milliseconds: 800),
      curve: Curves.bounceOut,
    );
  }

  gotoSignup() {
    _controller.animateToPage(
      2,
      duration: const Duration(milliseconds: 800),
      curve: Curves.bounceOut,
    );
  }

  gotoLoginHome() {
    _controller.animateToPage(
      0,
      duration: const Duration(milliseconds: 800),
      curve: Curves.bounceOut,
    );
  }

  final PageController _controller =
      PageController(initialPage: 1, viewportFraction: 1.0);

  @override
  Widget build(BuildContext context) {
    final ObHomeController c = ObHomeController.to;

    return Obx(
      () => c.itemLogin.value.isLogin
          ? AccountScreen()
          : SizedBox(
              height: Get.mediaQuery.size.height,
              child: PageView(
                controller: _controller,
                physics: const AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  loginPage(),
                  homePage(),
                  signupPage(),
                ],
              ),
            ),
    );
  }
}
