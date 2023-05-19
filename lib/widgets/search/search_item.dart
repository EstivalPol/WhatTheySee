import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:whattheysee/model/mediaitem.dart';
import 'package:whattheysee/model/searchresult.dart';
//import 'package:whattheysee/util/navigator.dart';
import 'package:whattheysee/components/ob_homecontroller.dart';
import 'package:whattheysee/screens/ui/detail/detail_screen.dart';

class SearchItemCard extends StatelessWidget {
  final SearchResult item;
  const SearchItemCard(this.item, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => _handleTap(context),
        child: Row(
          children: <Widget>[
            FadeInImage.assetNetwork(
                fit: BoxFit.cover,
                width: 100.0,
                height: 150.0,
                placeholder: "assets/placeholder.jpg",
                image: item.imageUrl),
            Container(
              width: 8.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    decoration: const BoxDecoration(
                        color: mainColor,
                        borderRadius: BorderRadius.all(Radius.circular(4.0))),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        item.mediaType.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 4.0,
                  ),
                  Text(
                    item.title,
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  Container(
                    height: 4.0,
                  ),
                  Text(item.subtitle, style: captionStyle)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _handleTap(BuildContext context) {
    debugPrint("_handleTap isRunning...");

    MediaItem? mediaItem;

    switch (item.mediaType) {
      case "movie":
        mediaItem = item.asMovie;
        break;
      case "tv":
        mediaItem = item.asShow;
        break;
      case "person":
        return;
    }

    if (mediaItem != null) {
      ObHomeController.to.setItemPass(mediaItem, true, null);
      Get.to(DetailScreen(item: mediaItem));
    }
  }
}
