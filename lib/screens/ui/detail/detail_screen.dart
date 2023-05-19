import 'dart:async';
import 'dart:io';

import 'package:carousel_pro_nullsafety/carousel_pro_nullsafety.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:whattheysee/components/fade_up.dart';
import 'package:whattheysee/components/ob_homecontroller.dart';
import 'package:whattheysee/components/photo_hero.dart';
import 'package:whattheysee/model/mediaitem.dart';
import 'package:whattheysee/screens/ui/detail/detail_play.dart';
import 'package:whattheysee/util/utils.dart';
import 'package:whattheysee/widgets/media_detail/cast_section.dart';
import 'package:whattheysee/widgets/media_detail/meta_section.dart';
import 'package:whattheysee/widgets/media_detail/similar_section.dart';

const double ratioHeight = 2.2;

class DetailScreen extends StatelessWidget {
  final MediaItem item;
  DetailScreen({required this.item, Key? key}) : super(key: key) {
    ObHomeController.to.setNullFavs();
  }

  Widget createLoading() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Center(
        child: PhotoHero.loading(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ObHomeController c = ObHomeController.to;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          bottom: 0,
        ),
        child: SizedBox(
          width: Get.width,
          height: Get.height,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Obx(
                  () => c.itemSub.value.item == null
                      ? createTopContainer(
                          c, item, c.itemFavs.value.item ?? item, null, null)
                      : createTopContainer(
                          c,
                          c.itemSub.value.item!,
                          c.itemFavs.value.item ?? item,
                          c.itemSub.value.images,
                          c.itemSub.value.videos),
                ),
                Obx(
                  () => c.itemSub.value.item == null
                      ? _buildWidgetTitleMovie(context, item)
                      : _buildWidgetTitleMovie(context, c.itemSub.value.item!),
                ),
                const SizedBox(height: 4.0),
                Obx(
                  () => c.itemSub.value.item == null
                      ? _buildWidgetGenreMovie(context, item)
                      : _buildWidgetGenreMovie(context, c.itemSub.value.item!),
                ),
                const SizedBox(height: 16.0),
                Obx(
                  () => c.itemSub.value.item == null
                      ? _buildWidgetRating(item)
                      : _buildWidgetRating(c.itemSub.value.item!),
                ),
                const SizedBox(height: 16.0),
                Obx(
                  () => c.itemSub.value.result == null
                      ? createLoading()
                      : _buildWidgetShortDescriptionMovie(
                          c,
                          c.itemSub.value.result,
                          c.itemSub.value.item!,
                        ),
                ),
                const SizedBox(height: 16.0),
                Obx(
                  () => c.itemSub.value.item == null
                      ? _buildWidgetSynopsisMovie(context, item)
                      : _buildWidgetSynopsisMovie(
                          context, c.itemSub.value.item!),
                ),
                const SizedBox(height: 16.0),
                Obx(
                  () => c.itemSub.value.result == null
                      ? createLoading()
                      : Container(
                          decoration:
                              BoxDecoration(color: Get.theme.primaryColor),
                          child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: CastSection(c.itemSub.value.cast!)),
                        ),
                ),
                const SizedBox(height: 16.0),
                Obx(
                  () => c.itemSub.value.result == null
                      ? createLoading()
                      : Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: MetaSection(c.itemSub.value.result),
                        ),
                ),
                const SizedBox(height: 16.0),
                Obx(
                  () => c.itemSub.value.result == null
                      ? createLoading()
                      : Container(
                          child: _buildWidgetScreenshots(
                              Get.mediaQuery,
                              context,
                              c.itemSub.value.videos,
                              c.itemSub.value.item!),
                        ),
                ),
                Obx(
                  () => c.itemSub.value.result == null
                      ? createLoading()
                      : Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SimilarSection(c.itemSub.value.similar!),
                        ),
                ),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget createTopContainer(ObHomeController c, MediaItem item,
      MediaItem itemFav, dynamic images, dynamic videos) {
    return Stack(
      children: <Widget>[
        BackdropImage(item.getBackDropUrl(), images),
        _buildWidgetAppBar(
          c,
          Get.mediaQuery,
          Get.context!,
          item,
          ObHomeController.to.isItemFavorite(itemFav),
        ),
        _buildWidgetFloatingActionButton(Get.mediaQuery, videos, item),
        _buildWidgetIconBuyAndShare(Get.mediaQuery),
      ],
    );
  }

  Widget _buildWidgetAppBar(ObHomeController model, MediaQueryData mediaQuery,
      BuildContext context, MediaItem mediaItem, bool isFavorite) {
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
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35.0),
                color: Get.isDarkMode
                    ? Get.theme.colorScheme.background.withOpacity(0.9)
                    : Colors.white70,
                boxShadow: [
                  BoxShadow(
                      color: Get.theme.textTheme.labelLarge!.color!
                          .withOpacity(0.2),
                      blurRadius: 9.0,
                      offset: const Offset(0.0, 6))
                ],
              ),
              child: Icon(Feather.chevron_left,
                  color: Get.isDarkMode ? Colors.white : Colors.black,
                  size: 28),
            ),
          ),
          Expanded(
            child: Container(),
          ),
          GestureDetector(
            onTap: () {
              model.toggleFavorites(mediaItem);
              Get.snackbar(
                "Information",
                !isFavorite ? "You like this..." : "You dislike...",
                backgroundColor: mainColor,
                colorText: Colors.white,
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35.0),
                color: Get.isDarkMode
                    ? Get.theme.colorScheme.background.withOpacity(0.9)
                    : Colors.white70,
                boxShadow: [
                  BoxShadow(
                      color: Get.theme.textTheme.labelLarge!.color!
                          .withOpacity(0.2),
                      blurRadius: 9.0,
                      offset: const Offset(0.0, 6))
                ],
              ),
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite
                    ? mainColor
                    : Get.isDarkMode
                        ? Colors.white
                        : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWidgetFloatingActionButton(
      MediaQueryData mediaQuery, dynamic videos, MediaItem movie) {
    List<dynamic> listScreenshotsMovie = [];
    if (videos != null && videos['results'] != null) {
      listScreenshotsMovie = videos['results'];
    }

    return Column(
      children: <Widget>[
        SizedBox(height: (mediaQuery.size.height / ratioHeight) - 60),
        Center(
          child: FloatingActionButton(
            onPressed: () {
              clickToPlay(movie, listScreenshotsMovie[0], listScreenshotsMovie);
            },
            backgroundColor: Colors.white,
            child: Icon(
              Icons.play_arrow,
              color: Get.theme.primaryColorDark,
              size: 32.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWidgetIconBuyAndShare(MediaQueryData mediaQuery) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: (mediaQuery.size.height / ratioHeight) - 40,
          ),
          Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () {
                    Get.snackbar(
                      "Information",
                      "Rating action, coming soon...",
                      backgroundColor: mainColor,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    child: const Icon(Feather.star),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {
                    actionShare(item);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    child: const Icon(Feather.share_2),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWidgetTitleMovie(BuildContext context, MediaItem item) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      child: Center(
        child: Text(
          item.title ?? "",
          style: Get.theme.textTheme.titleLarge,
          maxLines: 2,
        ),
      ),
    );
  }

  Widget _buildWidgetGenreMovie(BuildContext context, MediaItem item) {
    return Center(
      child: Text(
        getGenreString(item.genreIds),
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }

  Widget _buildWidgetRating(MediaItem item) {
    return Center(
      child: Container(
        width: 80,
        decoration: BoxDecoration(
          color: mainColor,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 1.0,
              ),
              Text(
                item.voteAverage.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              Container(
                width: 1.0,
              ),
              const Icon(Icons.star, size: 16.0, color: Colors.white)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWidgetShortDescriptionMovie(
      final ObHomeController c, dynamic itemMovie, MediaItem item) {
    var runTime = 0;
    if (itemMovie != null && itemMovie['runtime'] != null) {
      runTime = itemMovie['runtime'];
    }

    debugPrint("check Get.isDarkMode ${Get.isDarkMode.toString()}");

    var textColor = c.currentTheme == 0 ? Colors.white70 : Colors.black87;
    var country = " - ";
    if (itemMovie != null &&
        itemMovie['production_countries'] != null &&
        itemMovie['production_countries'].length > 0) {
      country = itemMovie['production_countries'][0]['name'];
      if (itemMovie['production_countries'][0]['iso_3166_1'] == 'US') {
        country = "USA";
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Country\n',
                  style: TextStyle(
                    color: textColor,
                  ),
                ),
                TextSpan(
                  text: country,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Year\n',
                  style: TextStyle(
                    color: textColor,
                  ),
                ),
                TextSpan(
                  text: item.getReleaseYear().toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Length\n',
                  style: TextStyle(
                    color: textColor,
                  ),
                ),
                TextSpan(
                  text: '$runTime min',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWidgetSynopsisMovie(BuildContext context, MediaItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          const Text(
            "Synopsis",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            item.overview,
            textAlign: TextAlign.justify,
          )
        ],
      ),
    );
  }

  clickToPlay(dynamic movie, dynamic trailer, List<dynamic> trailers) async {
    if (trailers.isEmpty) {
      PhotoHero.showSnackbar("No Trailer...");
      return;
    }

    await ObHomeController.to.setItemPlay(movie, trailer, trailers);
    await Get.to(
      const DetailPlay(),
      transition: Transition.downToUp,
    );
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    ObHomeController.to.toggleOrientation(Orientation.portrait);
  }

  Widget _buildWidgetScreenshots(MediaQueryData mediaQuery,
      BuildContext context, dynamic videos, MediaItem movie) {
    var listScreenshotsMovie = videos['results'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Divider(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: const Text(
            'Trailers',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        SizedBox(
          width: mediaQuery.size.width,
          height: 100.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              var item = listScreenshotsMovie[index];
              return FadeUp(
                0.6,
                Padding(
                  padding: EdgeInsets.only(
                    left: 16.0,
                    right:
                        index == listScreenshotsMovie.length - 1 ? 16.0 : 0.0,
                  ),
                  child: Stack(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Hero(
                          tag: "Movie-SS-${item['id']}",
                          child: FadeInImage.assetNetwork(
                            placeholder: "assets/placeholder.jpg",
                            image:
                                getThumbnailYoutubeUrl(item['key'].toString()),
                            fit: BoxFit.cover,
                            imageErrorBuilder: (context, url, error) =>
                                const Icon(Icons.error),
                            height: 100.0,
                            fadeInDuration: const Duration(
                              milliseconds: 50,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: InkWell(
                          onTap: () {
                            clickToPlay(movie, item, listScreenshotsMovie);
                          },
                          child: const Icon(
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
          ),
        ),
      ],
    );
  }

  actionShare(MediaItem item) {
    debugPrint(item.getBackDropUrl());

    String? url = item.getBackDropUrl();
    if (url.length < 5) {
      EasyLoading.showToast("File Download invalid...");
      return;
    }

    GetFileSave getFileSave = GetFileSave(url);
    getFileSave.checkUrlFirst();
    String? getpath;
    Timer(const Duration(microseconds: 500), () async {
      final file = await getFileSave._localFile;
      if (!file.existsSync()) {
        EasyLoading.showToast("Downloading...");
        final dataWrite = await getFileSave.fetchPost();
        await Future.delayed(const Duration(milliseconds: 700));

        await getFileSave.writeCounter(dataWrite);
        await getFileSave.existsFile();

        await Future.delayed(const Duration(milliseconds: 700));
        final file = await getFileSave._localFile;
        getpath = file.path;
      } else {
        getpath = file.path;
      }

      Future.delayed(const Duration(milliseconds: 500), () {
        String descShare =
            'Trailer Movie ${item.title} - ${item.getReleaseYear()} - whattheysee.ID';
        debugPrint(descShare);

        String subject =
            'Website https://www.whattheysee.id, \n\nDownload link Android https://bit.ly/whattheysee2020, \n\nDownload link iOS https://apple.co/33mHuKf \n\n\nRegards, whattheysee.ID';

        if (getpath != null && getpath!.length > 5) {
          Share.shareFiles(
            [getpath!],
            text: "$descShare\n$subject",
            subject: descShare,
          );
        } else {
          Share.share(
            subject,
            subject: descShare,
          );
        }
      });
    });
  }
}

class BackdropImage extends StatelessWidget {
  final String backdropPath;
  final dynamic images;

  const BackdropImage(this.backdropPath, this.images, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return ClipPath(
      clipper: BottomWaveClipper(),
      child: images == null
          ? Image.network(
              backdropPath,
              height: mediaQuery.size.height / ratioHeight,
              width: mediaQuery.size.width,
              fit: BoxFit.cover,
            )
          : createSlider(mediaQuery, images['backdrops']),
    );
  }

  Widget createSlider(MediaQueryData mediaQuery, List<dynamic> datas) {
    List<dynamic> images = [];
    int counter = 1;
    for (var e in datas) {
      if (counter < 10) {
        images.add(e);
      }
      counter = counter + 1;
    }

    return SizedBox(
      height: mediaQuery.size.height / ratioHeight,
      width: mediaQuery.size.width,
      child: Carousel(
        autoplayDuration: const Duration(seconds: 22),
        images: images.map((item) {
          //debugPrint(item.toString());
          final String? imageFile = item['filegetpath'] ?? item['file_path'];

          return InkWell(
            onTap: () {
              if (imageFile != null) {
                Get.to(PhotoHero.photoView(getLargePictureUrl(imageFile)));
              }
            },
            child: imageFile == null
                ? const SizedBox(
                    child: Center(child: CircularProgressIndicator()))
                : Hero(
                    tag: "Image-Tag-$imageFile",
                    child: FadeInImage.assetNetwork(
                      placeholder: "assets/placeholder.jpg",
                      image: getLargePictureUrl(imageFile),
                      fit: BoxFit.cover,
                      imageErrorBuilder: (context, url, error) =>
                          const Icon(Icons.error),
                      height: 100.0,
                      fadeInDuration: const Duration(
                        milliseconds: 50,
                      ),
                    ),
                  ),
          );
        }).toList(),
        dotSize: 5.0,
        dotSpacing: 10.0,
        dotPosition: DotPosition.bottomCenter,
        dotColor: Colors.white70,
        dotIncreasedColor: mainColor,
        //dotIncreaseSize: 16,
        dotHorizontalPadding: 10,
        dotVerticalPadding: 60,
        indicatorBgPadding: 5.0,
        dotBgColor: Colors.transparent,
        borderRadius: false,
      ),
    );
  }
}

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 70.0);

    var firstControlPoint = Offset(size.width / 2, size.height);
    var firstEndPoint = Offset(size.width, size.height - 70.0);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    path.lineTo(size.width, size.height - 70.0);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class GetFileSave {
  String thisUrl = "";

  GetFileSave(String url) {
    thisUrl = url;
  }

  String filename = "";
  checkUrlFirst() async {
    debugPrint(thisUrl);
    filename = thisUrl.substring(thisUrl.lastIndexOf("/") + 1);
    debugPrint(filename);
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    String fl = "$path/$filename";

    return File(fl);
  }

  Future<File> writeCounter(Uint8List stream) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsBytes(stream);
  }

  Future<Uint8List> fetchPost() async {
    final response = await http.get(Uri.parse(thisUrl));
    final responseJson = response.bodyBytes;

    return responseJson;
  }

  Future<bool> existsFile() async {
    final file = await _localFile;
    return file.exists();
  }
}
