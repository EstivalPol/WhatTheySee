import 'package:flutter/material.dart';
import 'package:whattheysee/components/fade_up.dart';
import 'package:whattheysee/components/ob_homecontroller.dart';
import 'package:whattheysee/model/mediaitem.dart';

class SimilarSection extends StatelessWidget {
  final List<MediaItem> _similarMovies;

  const SimilarSection(this._similarMovies, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Divider(),
        const Text(
          "Similar",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          height: 8.0,
        ),
        SizedBox(
          height: 300.0,
          child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            scrollDirection: Axis.horizontal,
            children: _similarMovies
                .map(
                  (MediaItem movie) => FadeUp(
                    0.6,
                    GestureDetector(
                      onTap: () {
                        ObHomeController.to.setItemPass(movie, true, null);
                      },
                      child: FadeInImage.assetNetwork(
                        image: movie.getPosterUrl(),
                        placeholder: 'assets/placeholder.jpg',
                        height: 150.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        )
      ],
    );
  }
}
