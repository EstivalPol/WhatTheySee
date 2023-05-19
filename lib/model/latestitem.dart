import 'package:whattheysee/model/mediaitem.dart';
import 'package:whattheysee/util/utils.dart';

class LatestItem {
  MediaType? type;
  int id;
  bool adult;

  double voteAverage;
  int voteCount;
  int runtime;

  int budget;
  String belongs;
  String title;
  String homepage;

  String posterPath;
  String backdropPath;
  String overview;
  String? releaseDate;
  List<dynamic> genres;

  String getBackDropUrl() => getLargePictureUrl(backdropPath);

  String getPosterUrl() => getMediumPictureUrl(posterPath);

  int getReleaseYear() {
    return releaseDate == null || releaseDate == ""
        ? 0
        : DateTime.parse(releaseDate!).year;
  }

  factory LatestItem(dynamic jsonMap, MediaType typeMedia) =>
      LatestItem._internalFromJson(jsonMap, typeMedia: typeMedia);

  /*
  {adult: true, backdrop_path: null, belongs_to_collection: null, 
  budget: 0, genres: [], homepage: , id: 936563, imdb_id: null, original_language: en, 
  original_title: Adventures in Cosplay 3, 
  overview: Riley Reid - This nurse will give you all the TLC you could ever need!  Allie Addison - This sexy maid knows how to clean a cock!  Vanna Bardot - Guaranteed, she sell all her cookies!  Charma Kelly - The yellow brick road leads you between her legs!, 
  popularity: 0.0, poster_path: /uZJ6wq0mLR6VDiWJIN0CzgrXuZz.jpg, 
  production_companies: [{id: 45960, logo_path: /ab1pk47XVGPuNzw94ECZQgq9BIj.png, 
  name: Porn Pros, origin_country: US}], 
  production_countries: [{iso_3166_1: US, name: United States of America}], 
  release_date: 2022-02-01, revenue: 0, runtime: 120, 
  spoken_languages: [{english_name: English, iso_639_1: en, name: English}], 
  status: Released, tagline: , title: Adventures in Cosplay 3, video: false, 
  vote_average: 0.0, vote_count: 0}
   */

  LatestItem._internalFromJson(Map jsonMap,
      {MediaType typeMedia = MediaType.movie})
      : type = typeMedia,
        id = jsonMap["id"].toInt(),
        budget = jsonMap["budget"].toInt(),
        belongs = jsonMap["belongs_to_collection"] ?? "",
        title = jsonMap["title"] != null
            ? jsonMap[(typeMedia == MediaType.movie ? "title" : "name")]
            : null,
        adult = jsonMap["adult"],
        voteAverage = jsonMap["vote_average"].toDouble(),
        voteCount = jsonMap["vote_count"].toInt(),
        runtime = jsonMap["runtime"].toInt(),
        homepage = jsonMap["homepage"] ?? "",
        posterPath = jsonMap["poster_path"] ?? "",
        backdropPath = jsonMap["backdrop_path"] ?? "",
        overview = jsonMap["overview"],
        releaseDate = jsonMap[
            (typeMedia == MediaType.movie ? "release_date" : "first_air_date")],
        genres =
            (jsonMap["genres"] as List<dynamic>).map((value) => value).toList();

  Map toJson() => {
        'type': type == MediaType.movie ? 1 : 0,
        'id': id,
        'adult': adult,
        'vote_average': voteAverage,
        'vote_count': voteCount,
        'runtime': runtime,
        'budget': budget,
        'title': title,
        'homepage': homepage,
        'poster_path': posterPath,
        'backdrop_path': backdropPath,
        'overview': overview,
        'release_date': releaseDate,
        'genres': genres
      };

  factory LatestItem.fromPrefsJson(Map jsonMap) {
    //print(jsonMap);

    return LatestItem._internalFromJson(jsonMap,
        typeMedia:
            (jsonMap['type'].toInt() == 1) ? MediaType.movie : MediaType.show);
  }
}
