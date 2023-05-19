import 'package:carousel_pro_nullsafety/carousel_pro_nullsafety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:whattheysee/components/fade_up.dart';
import 'package:whattheysee/components/ob_homecontroller.dart';
import 'package:whattheysee/model/mediaitem.dart';
import 'package:whattheysee/screens/model/category/category.dart';
import 'package:whattheysee/screens/ui/detail/detail_screen.dart';
import 'package:whattheysee/util/mediaproviders.dart';
import 'package:whattheysee/util/utils.dart';
import 'package:whattheysee/widgets/media_list/media_list.dart';
import 'package:whattheysee/widgets/search/search_page.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  toDetailScreen(final ObHomeController c, final MediaItem movie) {
    c.setItemPass(movie, true, null);
    Get.to(DetailScreen(item: movie));
  }

  @override
  Widget build(BuildContext context) {
    final ObHomeController c = ObHomeController.to;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: Get.mediaQuery.padding.top == 0 ? 16.0 : 16.0,
            bottom: 0, //Get.mediaQuery.padding.bottom == 0 ? 16.0 : 0,
          ),
          child: Column(
            children: <Widget>[
              _buildWidgetAppBar(c),
              const SizedBox(height: 16.0),
              Expanded(
                child: ListView(
                  children: [
                    _buildWidgetBanner(c),
                    const SizedBox(height: 14.0),
                    _buildWidgetCategories(),
                    const SizedBox(height: 24.0),
                    _buildWidgetMyList(c, context, "Trending", "trending"),
                    const SizedBox(height: 24.0),
                    _buildWidgetMyList(c, context, "Upcoming", "upcoming"),
                    const SizedBox(height: 24.0),
                    _buildWidgetMyList(c, context, "Popular", "popular"),
                    const SizedBox(height: 24.0),
                    _buildWidgetMyList(c, context, "Top Rated", "top_rated"),
                    const SizedBox(height: 50.0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWidgetAppBar(final ObHomeController c) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InkWell(
            onTap: () {
              c.changeTheme(true);
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              child: const Icon(Icons.color_lens),
            ),
          ),
          Expanded(
            child: Image.asset(
              'assets/wts_text.png',
              height: 20.0,
            ),
          ),
          InkWell(
            onTap: () async {
              await Get.to(const SearchScreen());
              ObHomeController.to.changeTheme(false);
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              child: const Icon(Icons.search),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildWidgetBanner(final ObHomeController c) {
    var itemHeight = Get.height / 3.9;

    return SizedBox(
      width: Get.mediaQuery.size.width,
      height: itemHeight + 30,
      child: Obx(
        () => c.itemResp.value.result == null
            ? const Center(
                child: SizedBox(
                  width: 25,
                  height: 25,
                  child: CircularProgressIndicator(),
                ),
              )
            : createSlide(c, itemHeight),
      ),
    );
  }

  Widget pageBuilder(ObHomeController c, int maxRows) {
    return PageView.builder(
      controller: PageController(
        viewportFraction: 0.90,
        initialPage: 0,
      ),
      itemBuilder: (BuildContext context, int index) {
        MediaItem movie = c.itemResp.value.result![index];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: GestureDetector(
            onTap: () {
              toDetailScreen(c, movie);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Stack(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Hero(
                      tag: "Movie-Banner-${movie.id}",
                      child: FadeInImage.assetNetwork(
                        placeholder: "assets/placeholder.jpg",
                        image: movie.getBackDropUrl(),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 200.0,
                        fadeInDuration: const Duration(milliseconds: 50),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      bottom: 16.0,
                    ),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: SizedBox(
                        height: 70,
                        child: _getTitleSection(context, movie),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
      itemCount: maxRows,
    );
  }

  final idxSlider = 0.obs;

  Widget createSlide(final ObHomeController c, final double itemHeight) {
    List<dynamic> sliders = c.itemResp.value.result ?? [];
    List<dynamic> temps = [];

    int counter = 0;
    for (var e in sliders) {
      counter++;
      if (counter < 16) {
        temps.add(e);
      }
    }

    if (temps.isNotEmpty) {
      sliders = temps;
    }

    return Column(
      children: [
        SizedBox(
          height: itemHeight,
          width: Get.width - 10,
          child: Carousel(
              onImageChange: (prev, current) {
                idxSlider.value = current;
              },
              boxFit: BoxFit.cover,
              autoplay: true,
              autoplayDuration: const Duration(milliseconds: 1000 * 16),
              animationCurve: Curves.fastOutSlowIn,
              animationDuration: const Duration(milliseconds: 1000),
              showIndicator: false,
              images: sliders.map((e) {
                MediaItem movie = e;
                return Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 5, bottom: 0),
                  child: GestureDetector(
                    onTap: () {
                      toDetailScreen(c, movie);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Stack(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: Hero(
                              tag: "Movie-Banner-${movie.id}",
                              child: FadeInImage.assetNetwork(
                                placeholder: "assets/placeholder.jpg",
                                image: movie.getBackDropUrl(),
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 210.0,
                                fadeInDuration:
                                    const Duration(milliseconds: 50),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 16.0,
                              right: 16.0,
                              bottom: 16.0,
                            ),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: SizedBox(
                                height: 70,
                                child: _getTitleSection(Get.context!, movie),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }).toList()),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 0, right: 5),
          child: Obx(() => Container(
                margin: const EdgeInsets.only(top: 10),
                child: AnimatedSmoothIndicator(
                  activeIndex: idxSlider.value,
                  count: sliders.length,
                  curve: Curves.easeInOut,
                  duration: const Duration(milliseconds: 800),
                  effect: const WormEffect(
                    offset: 15,
                    strokeWidth: 1.5,
                    spacing: 5,
                    dotWidth: 8,
                    dotHeight: 8,
                    activeDotColor: mainColor,
                  ),
                ),
              )),
        ),
      ],
    );
  }

  Widget _getTitleSection(BuildContext context, MediaItem movie) {
    return Container(
      padding: const EdgeInsets.all(2.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  movie.title ?? "",
                  maxLines: 2,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    getGenreString(movie.genreIds),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            width: 12.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: mainColor,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(12.0)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 6.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        movie.voteAverage.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                      Container(
                        width: 4.0,
                      ),
                      const Icon(Icons.star, size: 16.0, color: Colors.white)
                    ],
                  ),
                ),
              ),
              Container(
                height: 4.0,
              ),
              Container(
                decoration: BoxDecoration(
                    color: mainColor,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(12.0)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 6.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        movie.getReleaseYear().toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                      Container(
                        width: 4.0,
                      ),
                      const Icon(
                        Icons.date_range,
                        size: 16.0,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildWidgetCategories() {
    var listCategories = [
      Category(
        title: 'Now Playing',
        backdropPath: 'assets/images/now_playing_backdrop_path.jpeg',
        link: 'now_playing',
      ),
      Category(
        title: 'Trending',
        backdropPath: 'assets/images/upcoming_backdrop_path.jpeg',
        link: 'trending',
      ),
      Category(
        title: 'Top Rated',
        backdropPath: 'assets/images/top_rated_backdrop_path.jpeg',
        link: 'top_rated',
      ),
      Category(
        title: 'Upcoming',
        backdropPath: 'assets/images/upcoming_backdrop_path.jpeg',
        link: 'upcoming',
      ),
      Category(
        title: 'Popular',
        backdropPath: 'assets/images/popular_backdrop_path.jpeg',
        link: 'popular',
      ),
    ];
    return SizedBox(
      width: Get.width,
      height: 60.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          var category = listCategories[index];
          return Padding(
            padding: EdgeInsets.only(
              left: 16.0,
              right: index == listCategories.length - 1 ? 16.0 : 0.0,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  debugPrint("clicked item...");
                  Get.to(
                    MediaList(
                      MovieProvider(),
                      category.link,
                      category.title,
                      key: Key("movies-${category.link}"),
                    ),
                  );
                },
                child: Container(
                  width: 120,
                  height: 60,
                  padding: const EdgeInsets.all(0),
                  margin: const EdgeInsets.only(
                      top: 5, bottom: 5, right: 0, left: 0),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    image: DecorationImage(
                      image: AssetImage(
                        category.backdropPath,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: <Widget>[
                      Opacity(
                        opacity: 0.8,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            color: Get.theme.primaryColorDark,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          category.title.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        itemCount: listCategories.length,
      ),
    );
  }

  List<dynamic> listGetX(final ObHomeController c, String type) {
    List<dynamic> lists = [];
    if (type == "Trending") {
      if (c.itemResp.value.trending != null) {
        lists = c.itemResp.value.trending;
      }
    } else if (type == "Popular") {
      if (c.itemResp.value.popular != null) {
        lists = c.itemResp.value.popular;
      }
    } else if (type == "Upcoming") {
      if (c.itemResp.value.upcoming != null) {
        lists = c.itemResp.value.upcoming;
      }
    } else if (type == "Top Rated") {
      if (c.itemResp.value.toprated != null) {
        lists = c.itemResp.value.toprated;
      }
    } else if (type == "Now Playing") {
      if (c.itemResp.value.result != null) {
        lists = c.itemResp.value.result ?? [];
      }
    } else if (type == "Latest") {
      if (c.itemResp.value.latest != null) {
        lists = c.itemResp.value.latest;
      }
    }

    return lists;
  }

  Widget _buildWidgetMyList(final ObHomeController c, BuildContext context,
      String type, String link) {
    int maxRows = 20;

    return SizedBox(
      width: Get.width,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Text(
                    type,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.to(
                      MediaList(
                        MovieProvider(),
                        link,
                        type,
                        key: Key("movies-sub$link"),
                      ),
                    );
                  },
                  child: const Icon(
                    Feather.chevron_right,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10.0),
          SizedBox(
            height: 200.0,
            child: Obx(
              () => listGetX(c, type).isEmpty
                  ? const Center(
                      child: SizedBox(
                        width: 25,
                        height: 25,
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        MediaItem movie = listGetX(c, type)[index % maxRows];
                        return FadeUp(
                          0.6,
                          InkWell(
                            onTap: () async {
                              toDetailScreen(c, movie);
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: 16.0,
                                right: index == listGetX(c, type).length - 1
                                    ? 16.0
                                    : 0.0,
                              ),
                              child: SizedBox(
                                width: Get.width / 2.8,
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Hero(
                                        tag: "Movie-$type-${movie.id}",
                                        child: FadeInImage.assetNetwork(
                                          placeholder: "assets/placeholder.jpg",
                                          image: movie.getPosterUrl(),
                                          fit: BoxFit.cover,
                                          width: Get.width / 2.8,
                                          height: 200.0,
                                          fadeInDuration:
                                              const Duration(milliseconds: 50),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 5,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          Container(
                                            decoration: BoxDecoration(
                                              color: mainColor,
                                              shape: BoxShape.rectangle,
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 4.0,
                                                      horizontal: 2.0),
                                              child: Row(
                                                children: <Widget>[
                                                  Text(
                                                    movie.voteAverage
                                                        .toString(),
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                      fontSize: 11,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 1.0,
                                                  ),
                                                  const Icon(Icons.star,
                                                      size: 14.0,
                                                      color: Colors.white)
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 1.0,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                color: mainColor,
                                                shape: BoxShape.rectangle,
                                                borderRadius:
                                                    BorderRadius.circular(8.0)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 2.0,
                                                      horizontal: 4.0),
                                              child: Row(
                                                children: <Widget>[
                                                  Text(
                                                    movie
                                                        .getReleaseYear()
                                                        .toString(),
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                      fontSize: 11,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 1.0,
                                                  ),
                                                  const Icon(
                                                    Icons.date_range,
                                                    size: 16.0,
                                                    color: Colors.white,
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: maxRows * 2,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
