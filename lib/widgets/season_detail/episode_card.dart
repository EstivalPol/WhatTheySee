import 'package:flutter/material.dart';
import 'package:whattheysee/model/episode.dart';
import 'package:whattheysee/components/ob_homecontroller.dart';
import 'package:whattheysee/util/utils.dart';

class EpisodeCard extends StatelessWidget {
  final Episode episode;

  const EpisodeCard(this.episode, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => {},
        child: Column(
          children: <Widget>[
            FadeInImage.assetNetwork(
                fit: BoxFit.cover,
                height: 220.0,
                width: double.infinity,
                placeholder: "assets/placeholder.jpg",
                image: episode.stillUrl),
            ListTile(
              title: Text(episode.title),
              subtitle: Text(formatDate(episode.airDate)),
              leading:
                  CircleAvatar(child: Text(episode.episodeNumber.toString())),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
              child: Text(episode.overview, style: captionStyle),
            )
          ],
        ),
      ),
    );
  }
}
