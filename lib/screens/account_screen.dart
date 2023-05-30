import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:get/get.dart';
import 'package:whattheysee/components/ob_homecontroller.dart';
import 'package:whattheysee/components/photo_hero.dart';
import 'package:whattheysee/screens/login_screen.dart';
import 'ui/chat/chat.dart';

class AccountScreen extends StatelessWidget {
  AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ObHomeController c = ObHomeController.to;

    return Obx(
      () => c.itemLogin.value.isLogin
          ? alreadyLogin(c)
          : LoginScreen(
              onLogin: (dynamic data) {
                pushLogin(data);
              },
            ),
    );
  }

  pushLogin(dynamic arrayPush) async {
    try {
      EasyLoading.show(status: 'Loading...');
      await Future.delayed(const Duration(milliseconds: 500), () {
        ObHomeController.to.insertUpdateMember(arrayPush, true);
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (ObHomeController.to.itemLogin.value.message != null) {
            EasyLoading.showError(ObHomeController.to.itemLogin.value.message!);
          } else {
            EasyLoading.showSuccess('Process Success!');
          }
        });
      });
    } catch (e) {
      debugPrint("Error $e");
    }
  }

  Widget alreadyLogin(final ObHomeController c) {
    dynamic member = c.itemLogin.value.member;
    final resultList = [
      {
        "name": 'Website',
        "sub": ObHomeController.wEBURL,
        "icon": const Icon(Feather.globe),
      },
      {
        "name": 'Registered Date',
        "sub": PhotoHero.convertDateFull(member['date_created'], true),
        "icon": const Icon(Feather.user),
      },
      {
        "name": 'Change Password',
        "sub": 'Update Password',
        "icon": const Icon(Feather.lock),
      },
      {
        "name": 'Change Name',
        "sub": 'Update Name',
        "icon": const Icon(Feather.edit_3),
      },
      {
        "name": 'Logout',
        "sub": 'Confirmation Logout',
        "icon": const Icon(Feather.log_out)
      },
      {
        "name": 'Chat',
        "sub": 'Chat with friends',
        "icon": const Icon(Feather.message_circle)
      },
    ];

    return Scaffold(
      body: ListView.builder(
          itemCount: resultList.length,
          itemBuilder: (BuildContext ctxt, int index) {
            dynamic item = resultList[index];
            if (index == 0) {
              return Container(
                color: tertiaryColor,
                width: Get.width,
                height: Get.height / 6,
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "assets/icon.png",
                        fit: BoxFit.contain,
                        width: 50,
                        height: 50,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(member['nm_member'],
                              style: Get.theme.textTheme.headlineSmall!
                                  .copyWith(color: Colors.black)),
                          Text(member['email'],
                              style: Get.theme.textTheme.bodyLarge!
                                  .copyWith(color: Colors.black)),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }
            return Container(
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      clickIndex(index, c);
                    },
                    contentPadding: const EdgeInsets.all(0),
                    title: Text(item['name']),
                    subtitle: Text(item['sub']),
                    leading: item['icon'],
                    trailing: const Icon(Feather.chevron_right),
                  ),
                  const Divider(),
                ],
              ),
            );
          }),
    );
  }

  clickIndex(index, ObHomeController c) {
    if (index == 4) {
      showLogout(c);
    } else if (index == 2) {
      changePassword();
    } else if (index == 3) {
      changeName();
    } else if (index == 5) {
      chatRecap();
    } else {
      //PhotoHero.comingSoon2();
    }
  }

  showLogout(final ObHomeController c) {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Dialog(
          elevation: 0.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Container(
            color: Get.theme.colorScheme.background,
            height: 130.0,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "Are you sure logout?",
                  style: TextStyle(
                    //fontFamily: 'Mukta',
                    fontSize: 21.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Get.back();
                        //pushLogout(c.itemLogin.value.result['id_member']);
                      },
                      child: Container(
                        width: (Get.width / 3.5),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[600],
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        Get.back();
                        await Future.delayed(const Duration(milliseconds: 500));
                        EasyLoading.show(status: 'Loading...');

                        await Future.delayed(const Duration(milliseconds: 500),
                            () async {
                          await c.logoutMember();
                          await c.toggleLogin(false, null);
                        });

                        await Future.delayed(const Duration(milliseconds: 2000),
                            () async {
                          await c.toggleLogin(false, null);
                          EasyLoading.dismiss();
                        });
                      },
                      child: Container(
                        width: (Get.width / 3.5),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: mainColor,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: const Text(
                          'Log out',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  final TextEditingController _nmController = TextEditingController();
  final TextEditingController _psController = TextEditingController();
  final TextEditingController _rpController = TextEditingController();
  final TextEditingController _cpController = TextEditingController();

  changeName() {
    final ObHomeController c = ObHomeController.to;
    final userLogin = c.itemLogin.value.member;
    String nm = userLogin['nm_member'];
    _nmController.text = nm;

    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Dialog(
          elevation: 0.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Container(
            color: Get.theme.colorScheme.background,
            height: Get.height / 3,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "Update Name",
                  style: TextStyle(
                    fontSize: 21.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: _nmController,
                    maxLength: 50,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'New Name',
                      hintStyle: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        //fontFamily: 'Mukta',
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        width: (Get.width / 3.5),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[600],
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            //fontFamily: 'Mukta',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        Get.back();
                        pushUpdate(false);
                      },
                      child: Container(
                        width: (Get.width / 3.5),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: mainColor,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: const Text(
                          'Submit',
                          style: TextStyle(
                            //fontFamily: 'Mukta',
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  changePassword() {
    final ObHomeController c = ObHomeController.to;
    final userLogin = c.itemLogin.value.member;
    String nm = userLogin['nm_member'];
    _nmController.text = nm;

    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Dialog(
          elevation: 0.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Container(
            color: Get.theme.colorScheme.background,
            height: Get.height / 1.6,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "Change Password",
                  style: TextStyle(
                    fontSize: 21.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: _psController,
                    obscureText: true,
                    maxLength: 15,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Password Lama (Old)',
                      hintStyle: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: _rpController,
                    maxLength: 15,
                    obscureText: true,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Password Baru (New)',
                      hintStyle: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: _cpController,
                    maxLength: 15,
                    obscureText: true,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Ulangi Password Baru (New)',
                      hintStyle: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        width: (Get.width / 3.5),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[600],
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        Get.back();
                        pushUpdate(true);
                      },
                      child: Container(
                        width: (Get.width / 3.5),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: mainColor,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: const Text(
                          'Submit',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  chatRecap() {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Dialog(
          elevation: 0.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Container(
            color: Get.theme.colorScheme.background,
            height: Get.height / 3,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "Chat",
                  style: TextStyle(
                    fontSize: 21.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 15.0)),
                const Text(
                  'You have new notifications!',
                  style: TextStyle(color: Colors.red),
                ),
                Padding(padding: EdgeInsets.only(top: 15.0)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        width: (Get.width / 3.5),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[600],
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            //fontFamily: 'Mukta',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        Get.to(() => UserSelectionPage());
                        pushToGo();
                      },
                      child: Container(
                        width: (Get.width / 3.5),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: mainColor,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: const Text(
                          'Open chat',
                          style: TextStyle(
                            //fontFamily: 'Mukta',
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  pushToGo() {}

  pushUpdate(bool isPassword) async {
    debugPrint("[AccountScreen] pushUpdate...");
    final ObHomeController c = ObHomeController.to;
    final userLogin = c.itemLogin.value.member;
    String em = userLogin['email'];

    try {
      String nm = _nmController.text;
      String ps = _psController.text;
      String rp = _rpController.text;
      String cp = _cpController.text;

      debugPrint("[AccountScreen] name $nm");

      //EasyLoading.show(status: 'Loading...');

      if (isPassword) {
        nm = userLogin['nm_member'];
        if (ps.trim().length < 6) {
          EasyLoading.showToast("Password required... Min 6 character");
          return;
        }

        if (rp.trim().length < 6) {
          EasyLoading.showToast("New password required... Min 6 character");
          return;
        }

        if (cp.trim().length < 6) {
          EasyLoading.showToast("Confirm password required... Min 6 character");
          return;
        }

        if (cp.trim() != rp.trim()) {
          EasyLoading.showToast("New Password invalid...");
          return;
        }

        if (ps.trim() != userLogin['real_passwd']) {
          EasyLoading.showToast("Old Password invalid...");
          return;
        }

        ps = cp;
      } else {
        ps = userLogin['real_passwd'];
        if (nm.trim().isEmpty) {
          EasyLoading.showToast("Name required...");
          return;
        }
      }

      EasyLoading.show(status: 'Loading...');
      await Future.delayed(const Duration(milliseconds: 500), () {
        var arrayPush = {
          "nm": nm,
          "em": em,
          "ps": ps,
        };

        ObHomeController.to.insertUpdateMember(arrayPush, false);

        Future.delayed(const Duration(milliseconds: 1500), () {
          if (ObHomeController.to.itemLogin.value.message != null) {
            EasyLoading.showError(ObHomeController.to.itemLogin.value.message!);
          } else {
            try {
              _nmController.clear();
              _cpController.clear();
              _rpController.clear();
              _psController.clear();
            } catch (e) {
              debugPrint("");
            }
            EasyLoading.showSuccess('Process Success!');
          }
        });
      });
    } catch (e) {
      debugPrint("[AccountScreen] errror $e");
    }
  }
}
