import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whattheysee/model/cast.dart';
import 'package:whattheysee/components/ob_homecontroller.dart';
import 'package:whattheysee/widgets/actor_detail/actor_detail.dart';
import 'package:whattheysee/widgets/utilviews/bottom_gradient.dart';

class CastCard extends StatelessWidget {
  final double height;
  final double width;
  final Actor actor;

  const CastCard(this.actor,
      {Key? key, this.height = 140.0, this.width = 100.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(ActorDetailScreen(actor));
      },
      child: SizedBox(
        height: height,
        width: width,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Hero(
              tag: 'Cast-Hero-${actor.id}',
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/placeholder.jpg',
                image: actor.profilePictureUrl,
                fit: BoxFit.cover,
                height: height,
                width: width,
                imageErrorBuilder: (context, error, stackTrace) => Container(
                  padding: EdgeInsets.zero,
                  height: height,
                  width: width,
                  child: Image.asset(
                    'assets/placeholder.jpg',
                    height: height,
                    width: width,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const BottomGradient.noOffset(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    actor.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 10.0,
                    ),
                  ),
                  Container(
                    height: 4.0,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: Icon(
                        Icons.person,
                        color: salmon,
                        size: 10.0,
                      )),
                      Container(
                        width: 4.0,
                      ),
                      Expanded(
                        flex: 8,
                        child: Text(actor.character,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 8.0)),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
