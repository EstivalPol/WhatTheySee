import 'package:json_annotation/json_annotation.dart';
import 'package:whattheysee/model/mediaitem.dart';
part 'banner_movie.g.dart';

@JsonSerializable()
class BannerMovie {
  String title;
  String backdropPath;
  MediaItem item;

  BannerMovie(
      {required this.title, required this.backdropPath, required this.item});

  factory BannerMovie.fromJson(Map<String, dynamic> json) =>
      _$BannerMovieFromJson(json);

  Map<String, dynamic> toJson() => _$BannerMovieToJson(this);

  @override
  String toString() {
    return 'BannerMovie{title: $title, backdropPath: $backdropPath}';
  }
}
