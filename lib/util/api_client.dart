import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:whattheysee/model/cast.dart';
import 'package:whattheysee/model/episode.dart';
import 'package:whattheysee/model/mediaitem.dart';
import 'package:whattheysee/model/searchresult.dart';
import 'package:whattheysee/model/tvseason.dart';

const String aPIKEY = "669e883f477ef0edffafb422af5e7da5";

class ApiClient {
  static final _client = ApiClient._internal();
  final _http = HttpClient();

  ApiClient._internal();

  final String baseUrl = 'api.themoviedb.org';

  factory ApiClient() => _client;

  Future<dynamic> _getJson(Uri uri) async {
    var response = await (await _http.getUrl(uri)).close();
    var transformedResponse = await response.transform(utf8.decoder).join();
    return json.decode(transformedResponse);
  }

  Future<List<MediaItem>> fetchMovies(
      {int page = 1, String category = "popular"}) async {
    String param = '3/movie/$category';
    if (category == "trending") {
      param = '3/trending/movie/day';
    } else if (category == "discover") {
      param = '3/discover/movie';
    }

    var url =
        Uri.https(baseUrl, param, {'api_key': aPIKEY, 'page': page.toString()});

    return _getJson(url).then((json) => json['results']).then((dynamic data) =>
        data
            .map<MediaItem>((item) => MediaItem(item, MediaType.movie))
            .toList());
  }

  Future<dynamic> fetchMoviesLatest() async {
    String param = '3/movie/latest';
    var url = Uri.https(baseUrl, param, {'api_key': aPIKEY});

    return _getJson(url).then((json) => json).then((item) => item);
  }

  Future<List<MediaItem>> getSimilarMedia(int mediaId,
      {String type = "movie"}) async {
    var url = Uri.https(baseUrl, '3/$type/$mediaId/similar', {
      'api_key': aPIKEY,
    });

    return _getJson(url).then((json) => json['results']).then((data) => data
        .map<MediaItem>((item) => MediaItem(
            item, (type == "movie") ? MediaType.movie : MediaType.show))
        .toList());
  }

  Future<List<MediaItem>> getMoviesForActor(int actorId) async {
    var url = Uri.https(baseUrl, '3/discover/movie', {
      'api_key': aPIKEY,
      'with_cast': actorId.toString(),
      'sort_by': 'popularity.desc'
    });

    return _getJson(url).then((json) => json['results']).then((data) => data
        .map<MediaItem>((item) => MediaItem(item, MediaType.movie))
        .toList());
  }

  Future<List<MediaItem>> getShowsForActor(int actorId) async {
    var url = Uri.https(baseUrl, '3/person/$actorId/tv_credits', {
      'api_key': aPIKEY,
    });

    return _getJson(url).then((json) => json['cast']).then((data) => data
        .map<MediaItem>((item) => MediaItem(item, MediaType.show))
        .toList());
  }

  Future<List<Actor>> getMediaCredits(int mediaId,
      {String type = "movie"}) async {
    var url =
        Uri.https(baseUrl, '3/$type/$mediaId/credits', {'api_key': aPIKEY});

    return _getJson(url).then((json) =>
        json['cast'].map<Actor>((item) => Actor.fromJson(item)).toList());
  }

  Future<dynamic> getMediaDetails(int mediaId, {String type = "movie"}) async {
    var url = Uri.https(baseUrl, '3/$type/$mediaId', {'api_key': aPIKEY});

    return _getJson(url);
  }

  Future<dynamic> getMediaVideos(int mediaId, {String type = "movie"}) async {
    var url =
        Uri.https(baseUrl, '3/$type/$mediaId/videos', {'api_key': aPIKEY});

    return _getJson(url);
  }

  Future<dynamic> getMediaImages(int mediaId, {String type = "movie"}) async {
    var url =
        Uri.https(baseUrl, '3/$type/$mediaId/images', {'api_key': aPIKEY});

    return _getJson(url);
  }

  Future<dynamic> getItemLatest({String type = "movie"}) async {
    var url = Uri.https(baseUrl, '3/$type/latest', {'api_key': aPIKEY});

    return _getJson(url);
  }

  Future<List<TvSeason>> getShowSeasons(int showId) async {
    var detailJson = await getMediaDetails(showId, type: 'tv');
    return detailJson['seasons']
        .map<TvSeason>((item) => TvSeason.fromMap(item))
        .toList();
  }

  Future<List<SearchResult>> getSearchResults(String query) {
    var url = Uri.https(
        baseUrl, '3/search/multi', {'api_key': aPIKEY, 'query': query});

    return _getJson(url).then((json) => json['results']
        .map<SearchResult>((item) => SearchResult.fromJson(item))
        .toList());
  }

  Future<List<MediaItem>> fetchShows(
      {int page = 1, String category = "popular"}) async {
    var url = Uri.https(baseUrl, '3/tv/$category',
        {'api_key': aPIKEY, 'page': page.toString()});

    return _getJson(url).then((json) => json['results']).then((data) => data
        .map<MediaItem>((item) => MediaItem(item, MediaType.show))
        .toList());
  }

  Future<List<Episode>> fetchEpisodes(int showId, int seasonNumber) {
    var url = Uri.https(baseUrl, '3/tv/$showId/season/$seasonNumber', {
      'api_key': aPIKEY,
    });

    return _getJson(url).then((json) => json['episodes']).then(
        (data) => data.map<Episode>((item) => Episode.fromJson(item)).toList());
  }
}
