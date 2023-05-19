import 'package:flutter/material.dart';
import 'package:whattheysee/model/episode.dart';
import 'package:whattheysee/model/mediaitem.dart';
import 'package:whattheysee/model/tvseason.dart';
import 'package:whattheysee/util/api_client.dart';
import 'package:whattheysee/components/ob_homecontroller.dart';
import 'package:whattheysee/widgets/season_detail/episode_card.dart';

class SeasonDetailScreen extends StatelessWidget {
  final MediaItem show;
  final TvSeason season;
  final ApiClient _apiClient = ApiClient();
  SeasonDetailScreen(this.show, this.season, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primary,
        body: CustomScrollView(
          slivers: <Widget>[_buildAppBar(), _buildEpisodesList()],
        ));
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 300.0,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: <Widget>[
            Column(
              children: <Widget>[
                FadeInImage.assetNetwork(
                    fit: BoxFit.cover,
                    height: 230.0,
                    width: double.infinity,
                    placeholder: "assets/placeholder.jpg",
                    image: show.getBackDropUrl()),
                Expanded(
                  child: Container(
                    color: primaryDark,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            show.title ?? "",
                            style: captionStyle,
                          ),
                          Container(
                            height: 4.0,
                          ),
                          Text("Season ${season.seasonNumber}",
                              style: whiteBody.copyWith(fontSize: 18.0)),
                          Container(
                            height: 4.0,
                          ),
                          Text(
                            "${season.getReleaseYear()} - ${season.episodeCount} Episodes",
                            style: captionStyle,
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Hero(
                tag: 'Season-Hero-${season.id}',
                child: FadeInImage.assetNetwork(
                    width: 100.0,
                    placeholder: "assets/placeholder.jpg",
                    image: season.getPosterUrl()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEpisodesList() {
    return SliverList(
        delegate: SliverChildListDelegate(<Widget>[
      FutureBuilder(
          future: _apiClient.fetchEpisodes(show.id, season.seasonNumber),
          builder:
              (BuildContext context, AsyncSnapshot<List<Episode>> snapshot) =>
                  snapshot.connectionState != ConnectionState.done
                      ? const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Column(
                          children: snapshot.data!
                              .map((Episode episode) => EpisodeCard(episode))
                              .toList(),
                        ))
    ]));
  }
}
