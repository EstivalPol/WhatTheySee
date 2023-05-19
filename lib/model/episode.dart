import 'package:whattheysee/util/utils.dart';

class Episode {
  String title;
  String overview;
  String stillPath;
  double voteAverage;
  int episodeNumber;
  String airDate;

  String get stillUrl => getMediumPictureUrl(stillPath);

  Episode.fromJson(Map jsonMap)
      : title = jsonMap['name'],
        overview = jsonMap['overview'],
        stillPath = jsonMap['still_path'] ?? "",
        voteAverage = jsonMap['vote_average'] as double,
        episodeNumber = jsonMap['episode_number'],
        airDate = jsonMap['air_date'];
}
