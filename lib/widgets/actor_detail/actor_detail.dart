import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:whattheysee/components/fade_up.dart';
import 'package:whattheysee/model/cast.dart';
import 'package:whattheysee/model/mediaitem.dart';
import 'package:whattheysee/util/api_client.dart';
import 'package:whattheysee/components/ob_homecontroller.dart';
import 'package:whattheysee/widgets/media_list/media_list_item.dart';
import 'package:whattheysee/widgets/utilviews/fitted_circle_avatar.dart';

class ActorDetailScreen extends StatelessWidget {
  final Actor _actor;
  final ApiClient _apiClient = ApiClient();

  ActorDetailScreen(this._actor, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var movieFuture = _apiClient.getMoviesForActor(_actor.id);
    var showFuture = _apiClient.getShowsForActor(_actor.id);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: primary,
        body: NestedScrollView(
          body: TabBarView(
            children: <Widget>[
              _buildMoviesSection(movieFuture),
              _buildMoviesSection(showFuture),
            ],
          ),
          headerSliverBuilder:
              (BuildContext context, bool innerBoxIsScrolled) =>
                  [_buildAppBar(context, _actor)],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, Actor actor) {
    return SliverAppBar(
      systemOverlayStyle: Get.theme.appBarTheme.systemOverlayStyle,
      backgroundColor: Get.isDarkMode
          ? Get.theme.colorScheme.background
          : mainColor.withOpacity(.5),
      expandedHeight: 300.0,
      bottom: TabBar(
        indicatorColor: Get.theme.colorScheme.secondary,
        tabs: const <Widget>[
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
      pinned:
          true, // Get.isDarkMode ? Color(0xff2b5876) :  Get.isDarkMode ? Color(0xff4e4376) :
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            mainColor.withOpacity(.5),
            mainColor.withOpacity(.9),
          ])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).padding.top,
              ),
              Hero(
                tag: 'Cast-Hero-${actor.id}',
                child: SizedBox(
                  width: 122.0,
                  height: 122.0,
                  child: FittedCircleAvatar(
                    backgroundImage: NetworkImage(actor.profilePictureUrl),
                  ),
                ),
              ),
              Container(
                height: 8.0,
              ),
              Text(
                actor.name,
                style: whiteBody.copyWith(fontSize: 22.0),
              ),
              Container(
                height: 16.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoviesSection(Future<List<MediaItem>> future) {
    return FutureBuilder(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<List<MediaItem>> snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemBuilder: (BuildContext context, int index) => FadeUp(
                  0.6,
                  MediaListItem(snapshot.data![index], false),
                ),
                itemCount: snapshot.data!.length,
              )
            : const Padding(
                padding: EdgeInsets.all(32.0),
                child: Center(child: CircularProgressIndicator()),
              );
      },
    );
  }
}
