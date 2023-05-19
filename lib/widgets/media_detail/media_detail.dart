import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:whattheysee/model/cast.dart';
import 'package:whattheysee/model/mediaitem.dart';
import 'package:whattheysee/model/tvseason.dart';
import 'package:whattheysee/util/api_client.dart';
import 'package:whattheysee/util/mediaproviders.dart';
import 'package:whattheysee/components/ob_homecontroller.dart';
import 'package:whattheysee/util/utils.dart';
import 'package:whattheysee/widgets/media_detail/cast_section.dart';
import 'package:whattheysee/widgets/media_detail/meta_section.dart';
import 'package:whattheysee/widgets/media_detail/season_section.dart';
import 'package:whattheysee/widgets/media_detail/similar_section.dart';
import 'package:whattheysee/widgets/utilviews/text_bubble.dart';

class MediaDetailScreen extends StatefulWidget {
  final MediaItem _mediaItem;
  final MediaProvider provider;
  final ApiClient _apiClient = ApiClient();

  MediaDetailScreen(this._mediaItem, this.provider, {Key? key})
      : super(key: key);

  @override
  MediaDetailScreenState createState() {
    return MediaDetailScreenState();
  }
}

class MediaDetailScreenState extends State<MediaDetailScreen> {
  List<Actor>? _actorList;
  List<TvSeason>? _seasonList;
  List<MediaItem>? _similarMedia;
  dynamic _mediaDetails;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    _loadCast();
    _loadDetails();
    _loadSimilar();
    if (widget._mediaItem.type == MediaType.show) _loadSeasons();

    Timer(const Duration(milliseconds: 100),
        () => setState(() => _visible = true));
  }

  void _loadCast() async {
    try {
      List<Actor> cast = await widget.provider.loadCast(widget._mediaItem.id);
      setState(() => _actorList = cast);
    } catch (e) {
      debugPrint("");
    }
  }

  void _loadDetails() async {
    try {
      dynamic details = await widget.provider.getDetails(widget._mediaItem.id);
      setState(() => _mediaDetails = details);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _loadSeasons() async {
    try {
      List<TvSeason> seasons =
          await widget._apiClient.getShowSeasons(widget._mediaItem.id);
      setState(() => _seasonList = seasons);
    } catch (e) {
      debugPrint("");
    }
  }

  void _loadSimilar() async {
    try {
      List<MediaItem> similar =
          await widget.provider.getSimilar(widget._mediaItem.id);
      setState(() => _similarMedia = similar);
    } catch (e) {
      debugPrint("");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.primaryColor,
      body: CustomScrollView(
        slivers: <Widget>[
          _buildAppBar(widget._mediaItem),
          _buildContentSection(widget._mediaItem),
        ],
      ),
    );
  }

  Widget _buildAppBar(MediaItem movie) {
    return SliverAppBar(
      expandedHeight: 240.0,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Hero(
              tag: "MovieDetail-Tag-${widget._mediaItem.id}",
              child: FadeInImage.assetNetwork(
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: "assets/placeholder.jpg",
                  image: widget._mediaItem.getBackDropUrl()),
            ),
            _buildMetaSection(movie)
          ],
        ),
      ),
    );
  }

  Widget _buildMetaSection(MediaItem mediaItem) {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 500),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                TextBubble(
                  mediaItem.getReleaseYear().toString(),
                  backgroundColor: const Color(0xffF47663),
                ),
                Container(
                  width: 8.0,
                ),
                TextBubble(mediaItem.voteAverage.toString(),
                    backgroundColor: const Color(0xffF47663)),
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(mediaItem.title ?? "",
                  style: const TextStyle(
                      color: Color(0xFFEEEEEE), fontSize: 20.0)),
            ),
            Row(
              children: getGenresForIds(mediaItem.genreIds)
                  .sublist(0, min(5, mediaItem.genreIds.length))
                  .map((genre) => Row(
                        children: <Widget>[
                          TextBubble(genre!),
                          Container(
                            width: 8.0,
                          )
                        ],
                      ))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildContentSection(MediaItem media) {
    return SliverList(
      delegate: SliverChildListDelegate(<Widget>[
        Container(
          decoration: const BoxDecoration(color: Color(0xff222128)),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  "SYNOPSIS",
                  style: TextStyle(color: Colors.white),
                ),
                Container(
                  height: 8.0,
                ),
                Text(media.overview,
                    style:
                        const TextStyle(color: Colors.white, fontSize: 12.0)),
                Container(
                  height: 8.0,
                ),
              ],
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(color: primary),
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _actorList == null
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : CastSection(_actorList!)),
        ),
        Container(
          decoration: BoxDecoration(color: primaryDark),
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _mediaDetails == null
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : MetaSection(_mediaDetails)),
        ),
        (widget._mediaItem.type == MediaType.show)
            ? Container(
                decoration: BoxDecoration(color: primary),
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _seasonList == null
                        ? Container()
                        : SeasonSection(widget._mediaItem, _seasonList!)),
              )
            : Container(),
        Container(
            decoration: BoxDecoration(
                color: (widget._mediaItem.type == MediaType.movie
                    ? primary
                    : primaryDark)),
            child: _similarMedia == null
                ? Container()
                : SimilarSection(_similarMedia!))
      ]),
    );
  }
}
