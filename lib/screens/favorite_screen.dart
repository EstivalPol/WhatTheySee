import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whattheysee/components/fade_up.dart';
import 'package:whattheysee/components/ob_homecontroller.dart';
import 'package:whattheysee/widgets/media_list/media_list_item.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final ObHomeController c = Get.find();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Get.theme.primaryColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          systemOverlayStyle: Get.theme.appBarTheme.systemOverlayStyle,
          backgroundColor: Get.isDarkMode
              ? Get.theme.colorScheme.background
              : mainColor.withOpacity(.9),
          title: const Text("Favorites", style: TextStyle(color: Colors.white)),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Get.theme.colorScheme.secondary,
            tabs: const [
              Tab(
                icon: Icon(Icons.movie),
                text: 'Movie',
              ),
              Tab(
                icon: Icon(Icons.tv),
                text: 'TV Show',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            _FavoriteList(0),
            _FavoriteList(1),
          ],
        ),
      ),
    );
  }
}

class _FavoriteList extends StatelessWidget {
  final int type;
  const _FavoriteList(this.type, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ObHomeController c = Get.find();

    return Obx(
      () => type == 0
          ? c.itemFavs.value.movieFavs.isEmpty
              ? const Center(
                  child: Text("You have no favorites yet!"),
                )
              : Container(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: ListView.builder(
                    itemCount: c.itemFavs.value.movieFavs.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == c.itemFavs.value.movieFavs.length) {
                        return const SizedBox(
                          height: 50,
                        );
                      }
                      var item =
                          c.itemFavs.value.movieFavs.reversed.toList()[index];
                      return FadeUp(
                        0.6,
                        MediaListItem(item, true),
                      );
                    },
                  ),
                )
          : c.itemFavs.value.showFavs.isEmpty
              ? const Center(
                  child: Text("You have no favorites yet!"),
                )
              : Container(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: ListView.builder(
                    itemCount: c.itemFavs.value.showFavs.length,
                    itemBuilder: (BuildContext context, int index) {
                      var item =
                          c.itemFavs.value.showFavs.reversed.toList()[index];
                      return MediaListItem(item, true);
                    },
                  ),
                ),
    );
  }
}
