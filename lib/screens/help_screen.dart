import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:get/route_manager.dart';
import 'package:whattheysee/components/ob_homecontroller.dart';
import 'package:whattheysee/pages/webview_page.dart';

class HelpScreen extends StatelessWidget {
  final resultList = [
    {
      "name": 'Website',
      "sub": ObHomeController.wEBURL,
      "icon": Icon(Feather.globe, color: Get.theme.colorScheme.secondary),
    },
    {
      "name": 'Website',
      "sub": ObHomeController.wEBURL,
      "icon": Icon(Feather.globe, color: Get.theme.colorScheme.secondary),
    },
    {
      "name": ObHomeController.aPPNAME,
      "sub": ObHomeController.aPPVERSION,
      "icon": Icon(Feather.activity, color: Get.theme.colorScheme.secondary)
    },
  ];

  HelpScreen({Key? key}) : super(key: key);

  clickIndex(index) {
    if (index == 1) {
      Get.to(WebViewPage(url: ObHomeController.wEBURL, title: "Website"));
    }
  }

  @override
  Widget build(context) {
    // Access the updated count variable
    return Scaffold(
      body: ListView.builder(
          itemCount: resultList.length,
          itemBuilder: (BuildContext ctxt, int index) {
            dynamic item = resultList[index];
            if (index == 0) {
              return Container(
                color: tertiaryColor,
                width: Get.width,
                height: Get.height / 3,
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "assets/wts002.PNG",
                        fit: BoxFit.contain,
                        width: 170,
                        height: 170,
                      )
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
                      clickIndex(index);
                    },
                    contentPadding: const EdgeInsets.all(0),
                    title: Text(item['name']),
                    subtitle: Text(item['sub']),
                    leading: item['icon'],
                    trailing: Icon(Feather.chevron_right,
                        color: Get.theme.colorScheme.secondary),
                  ),
                  const Divider(),
                ],
              ),
            );
          }),
    );
  }
}
