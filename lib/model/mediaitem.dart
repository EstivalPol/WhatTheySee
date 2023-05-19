import 'package:whattheysee/util/utils.dart';

class MediaItem {
  MediaType type;
  int id;
  double voteAverage;
  String? title;
  String posterPath;
  String backdropPath;
  String overview;
  String? releaseDate;
  List<int> genreIds;

  String getBackDropUrl() => getLargePictureUrl(backdropPath);

  String getPosterUrl() => getMediumPictureUrl(posterPath);

  int getReleaseYear() {
    return releaseDate == null || releaseDate == ""
        ? 0
        : DateTime.parse(releaseDate!).year;
  }

  factory MediaItem(dynamic jsonMap, MediaType typeMovie) =>
      MediaItem._internalFromJson(jsonMap, typeMovie: typeMovie);

  MediaItem._internalFromJson(Map jsonMap,
      {MediaType typeMovie = MediaType.movie})
      : type = typeMovie,
        id = jsonMap["id"].toInt(),
        voteAverage = jsonMap["vote_average"].toDouble(),
        title = jsonMap["title"] ??
            jsonMap[(typeMovie == MediaType.movie ? "title" : "name")],
        posterPath = jsonMap["poster_path"] ?? "",
        backdropPath = jsonMap["backdrop_path"] ?? "",
        overview = jsonMap["overview"],
        releaseDate = jsonMap[
            (typeMovie == MediaType.movie ? "release_date" : "first_air_date")],
        genreIds = (jsonMap["genre_ids"] as List<dynamic>)
            .map<int>((value) => value.toInt())
            .toList();

  Map toJson() => {
        'type': type == MediaType.movie ? 1 : 0,
        'id': id,
        'vote_average': voteAverage,
        'title': title,
        'poster_path': posterPath,
        'backdrop_path': backdropPath,
        'overview': overview,
        'release_date': releaseDate,
        'genre_ids': genreIds
      };

  factory MediaItem.fromPrefsJson(Map jsonMap) {
    return MediaItem._internalFromJson(jsonMap,
        typeMovie:
            (jsonMap['type'].toInt() == 1) ? MediaType.movie : MediaType.show);
  }
}

enum MediaType { movie, show }
