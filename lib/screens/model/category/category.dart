import 'package:json_annotation/json_annotation.dart';
part 'category.g.dart';

@JsonSerializable()
class Category {
  String title;
  String backdropPath;
  String link;

  Category(
      {required this.title, required this.backdropPath, required this.link});

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);

  @override
  String toString() {
    return 'Category{title: $title, backdropPath: $backdropPath}';
  }
}
