import 'package:badges/badges.dart' as badges;
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:get/get.dart';
import 'package:whattheysee/components/ob_homecontroller.dart';
import 'package:whattheysee/pages/tvshow_page.dart';
import 'package:whattheysee/screens/account_screen.dart';
import 'package:whattheysee/screens/favorite_screen.dart';
import 'package:whattheysee/screens/help_screen.dart';
import 'package:whattheysee/screens/ui/home/home_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(context) {
    final ObHomeController c = ObHomeController.to;

    return Scaffold(
      bottomNavigationBar: Obx(
        () => ConvexAppBar(
          height: 50,
          top: -18, // -30
          curveSize: 80, // 100
          style: TabStyle.flip,
          elevation: 0.9,
          items: [
            const TabItem(title: 'Home', icon: Feather.home),
            TabItem(
              title: 'Favorite',
              icon: c.itemFavs.value.allFavs.isNotEmpty
                  ? badges.Badge(
                      badgeContent: Text(
                        '${c.itemFavs.value.allFavs.length}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      badgeStyle: badges.BadgeStyle(
                        badgeColor:
                            Get.isDarkMode ? Colors.red : Colors.deepOrange,
                      ),
                      child: c.idxTap.value.index == 1
                          ? const Icon(
                              Feather.heart,
                              size: 38,
                              color: mainColor,
                            )
                          : const Icon(
                              Feather.heart,
                            ),
                    )
                  : const Icon(Feather.heart),
            ),
            const TabItem(title: "Account", icon: Feather.user),
            const TabItem(title: 'TVShow', icon: Feather.tv),
            const TabItem(title: 'Setting', icon: Feather.settings),
          ],
          backgroundColor:
              c.itemTheme.value.currentTheme == 1 ? whiteColor : blackColor,
          activeColor: mainColor,
          color: c.itemTheme.value.currentTheme == 0 ? whiteColor : blackColor,
          cornerRadius: 0,
          onTap: (index) {
            c.setIndex(index);
          },
        ),
      ),
      body: Obx(() => switchScreen(c.idxTap.value.index)),
    );
  }

  Color swicthColor(index) {
    return blackColor;
  }

  Widget switchScreen(index) {
    switch (index) {
      case 0:
        return HomeScreen();
      case 1:
        return const FavoriteScreen();
      case 2:
        return AccountScreen();
      case 3:
        return const TVShowPage();
      case 4:
        return HelpScreen();
      default:
    }

    return HomeScreen();
  }
}
