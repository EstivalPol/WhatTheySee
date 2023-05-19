import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whattheysee/components/fade_up.dart';
import 'package:whattheysee/components/ob_homecontroller.dart';
import 'package:whattheysee/model/mediaitem.dart';
import 'package:whattheysee/screens/favorite_screen.dart';
import 'package:whattheysee/util/mediaproviders.dart';
import 'package:whattheysee/widgets/media_list/media_list.dart';
import 'package:whattheysee/widgets/search/search_page.dart';

class TVShowPage extends StatefulWidget {
  const TVShowPage({Key? key}) : super(key: key);

  @override
  State createState() => TVShowPageState();
}

class TVShowPageState extends State<TVShowPage> {
  PageController? _pageController;
  MediaType mediaType = MediaType.show;

  //final MediaProvider movieProvider = MovieProvider();
  final MediaProvider showProvider = ShowProvider();

  goToSearch(context) {
    Get.to(const SearchScreen());
  }

  goToFavorites(context) {
    Get.to(const FavoriteScreen());
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          systemOverlayStyle: Get.theme.appBarTheme.systemOverlayStyle,
          backgroundColor: Get.isDarkMode
              ? Get.theme.colorScheme.background
              : mainColor.withOpacity(.9),
          title: const Text("TV Show", style: TextStyle(color: Colors.white)),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Get.theme.colorScheme.secondary,
            tabs: const [
              Tab(
                icon: Icon(Icons.thumb_up),
                text: 'Popular',
              ),
              Tab(icon: Icon(Icons.live_tv), text: 'On The Air'),
              Tab(icon: Icon(Icons.star), text: 'Top Rated'),
            ],
          ),
        ),
        body: TabBarView(
          children: _getMediaList(),
        ),
      ),
    );
  }

  List<Widget> _getMediaList() {
    return <Widget>[
      FadeUp(
          0.6,
          MediaList(showProvider, "popular", null,
              key: const Key("shows-popular"))),
      FadeUp(
          0.6,
          MediaList(showProvider, "on_the_air", null,
              key: const Key("shows-on_the_air"))),
      FadeUp(
          0.6,
          MediaList(showProvider, "top_rated", null,
              key: const Key("shows-top_rated"))),
    ];
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController!.dispose();
  }
}
