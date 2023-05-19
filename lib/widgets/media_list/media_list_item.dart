import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whattheysee/components/ob_homecontroller.dart';
import 'package:whattheysee/model/mediaitem.dart';
import 'package:whattheysee/screens/ui/detail/detail_screen.dart';
import 'package:whattheysee/util/utils.dart';

class MediaListItem extends StatelessWidget {
  const MediaListItem(this.movie, this.isFavorite, {Key? key})
      : super(key: key);

  final MediaItem movie;
  final bool isFavorite;

  Widget _getTitleSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title ?? "",
                  style: Get.theme.textTheme.titleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    getGenreString(movie.genreIds),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Get.theme.textTheme.bodyLarge,
                  ),
                )
              ],
            ),
          ),
          Container(
            width: 12.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    movie.voteAverage.toString(),
                    style: Get.theme.textTheme.bodyLarge,
                  ),
                  Container(
                    width: 4.0,
                  ),
                  const Icon(
                    Icons.star,
                    size: 16.0,
                  )
                ],
              ),
              Container(
                height: 4.0,
              ),
              Row(
                children: <Widget>[
                  Text(
                    movie.getReleaseYear().toString(),
                    style: Get.theme.textTheme.bodyLarge,
                  ),
                  Container(
                    width: 4.0,
                  ),
                  const Icon(
                    Icons.date_range,
                    size: 16.0,
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          //goToMovieDetails(context, movie);
          ObHomeController.to.setItemPass(movie, true, null);
          Get.to(DetailScreen(item: movie));
        },
        child: Column(
          children: <Widget>[
            Hero(
              tag:
                  isFavorite ? "Favs-Tag-${movie.id}" : "Movie-Tag-${movie.id}",
              child: FadeInImage.assetNetwork(
                placeholder: "assets/placeholder.jpg",
                image: movie.getBackDropUrl(),
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200.0,
                fadeInDuration: const Duration(milliseconds: 50),
              ),
            ),
            _getTitleSection(context),
          ],
        ),
      ),
    );
  }
}
