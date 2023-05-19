import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:get/get.dart';
import 'package:whattheysee/components/ob_homecontroller.dart';
import 'package:whattheysee/components/photo_hero.dart';
import 'package:whattheysee/components/youtube_page.dart';
import 'package:whattheysee/model/mediaitem.dart';
import 'package:whattheysee/util/utils.dart';

class DetailPlay extends StatelessWidget {
  const DetailPlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ObHomeController c = ObHomeController.to;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          bottom: 0,
        ),
        child: Obx(
          () => c.itemScreen.value.orientation == Orientation.landscape
              ? backdropImage(
                  c, c.itemSubPlay.value.item, c.itemSubPlay.value.trailer)
              : SizedBox(
                  height: Get.height,
                  width: Get.width,
                  child: Column(
                    children: [
                      Stack(
                        children: <Widget>[
                          backdropImage(c, c.itemSubPlay.value.item,
                              c.itemSubPlay.value.trailer),
                          c.itemScreen.value.orientation ==
                                  Orientation.landscape
                              ? Positioned(left: 0, top: 0, child: Container())
                              : _buildWidgetAppBar(Get.mediaQuery, context),
                        ],
                      ),
                      Expanded(
                        child: Container(
                          height: Get.height + 50,
                          width: Get.width,
                          margin: const EdgeInsets.only(top: 16),
                          child: MediaQuery.removePadding(
                            removeTop: true,
                            context: Get.context!,
                            child: ListView(
                              shrinkWrap: true,
                              children: <Widget>[
                                c.itemSubPlay.value.trailer == null
                                    ? Container(child: PhotoHero.loading())
                                    : _buildWidgetTitleTrailerMovie(
                                        context,
                                        c.itemSubPlay.value.trailer['name']
                                            .toString(),
                                      ),
                                const SizedBox(height: 16.0),
                                Divider(color: Get.theme.colorScheme.secondary),
                                c.itemSubPlay.value.trailers == null
                                    ? Container()
                                    : Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: Text(
                                          c.itemSubPlay.value.trailers!
                                                      .length ==
                                                  1
                                              ? '-'
                                              : 'Other Trailers',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                Container(
                                  child: c.itemSubPlay.value.trailers == null
                                      ? Container(child: PhotoHero.loading())
                                      : _buildWidgetScreenshots(
                                          context,
                                          c.itemSubPlay.value.item!,
                                          c.itemSubPlay.value.trailers!,
                                          c.itemSubPlay.value.trailer),
                                ),
                                const SizedBox(height: 30.0),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildWidgetAppBar(MediaQueryData mediaQuery, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16.0,
        top: mediaQuery.padding.top == 0 ? 16.0 : mediaQuery.padding.top + 8.0,
        right: 16.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Container(),
          ),
        ],
      ),
    );
  }

  Widget _buildWidgetTitleTrailerMovie(BuildContext context, String name) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Center(
        child: Text(
          name,
          style: Get.theme.textTheme.headlineSmall,
          maxLines: 2,
        ),
      ),
    );
  }

  Widget _buildWidgetScreenshots(BuildContext context, MediaItem movie,
      List<dynamic> trailers, dynamic trailer) {
    List<dynamic> listVideos = trailers;

    var listScreenshotsMovie = [];
    for (var e in listVideos) {
      if (trailer != null && e['key'] != trailer['key']) {
        listScreenshotsMovie.add(e);
      }
    }

    //print(listScreenshotsMovie);

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int index) {
        var trailer = listScreenshotsMovie[index];
        debugPrint(trailer.toString());
        return InkWell(
          onTap: () async {
            await ObHomeController.to.setItemPlay(movie, trailer, trailers);
          },
          child: Padding(
            padding:
                const EdgeInsets.only(left: 8.0, right: 8, top: 10, bottom: 10),
            child: Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Hero(
                    tag: "Movie-Play-${trailer['id']}",
                    child: FadeInImage.assetNetwork(
                      placeholder: "assets/placeholder.jpg",
                      image: getThumbnailYoutubeUrl(trailer['key'].toString()),
                      fit: BoxFit.cover,
                      imageErrorBuilder: (context, url, error) =>
                          const Icon(Icons.error),
                      height: 180.0,
                      width: Get.width,
                      fadeInDuration: const Duration(
                        milliseconds: 50,
                      ),
                    ),
                  ),
                ),
                const Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: InkWell(
                    child: Icon(
                      Feather.play_circle,
                      size: 44,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      itemCount: listScreenshotsMovie.length,
    );
  }
}

Widget backdropImage(
    final ObHomeController c, final MediaItem? item, final dynamic trailer) {
  if (c.itemScreen.value.orientation == Orientation.portrait) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
  } else {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
  }
  return ClipPath(
    child: SizedBox(
      width: Get.width,
      height: c.itemScreen.value.orientation == Orientation.portrait
          ? Get.height / 3
          : Get.height,
      child: trailer == null || item == null
          ? Container(child: PhotoHero.loading())
          : YoutubePage(
              movie: item,
              youtubeId: trailer['key'],
              callback: () {
                //setPortrait();
                c.toggleOrientation(Orientation.portrait);
              },
              setHeight: () {
                //setLandscape();
                c.toggleOrientation(Orientation.landscape);
              },
            ),
    ),
  );
}
