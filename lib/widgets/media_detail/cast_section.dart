import 'package:flutter/material.dart';
import 'package:whattheysee/components/fade_up.dart';
import 'package:whattheysee/model/cast.dart';
import 'package:whattheysee/widgets/media_detail/cast_card.dart';

class CastSection extends StatelessWidget {
  final List<Actor> _cast;

  const CastSection(this._cast, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Divider(),
        const Text(
          "Cast",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          height: 8.0,
        ),
        SizedBox(
          height: 140.0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: _cast
                .map((Actor actor) => Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FadeUp(
                        0.6,
                        CastCard(actor),
                      ),
                    ))
                .toList(),
          ),
        )
      ],
    );
  }
}
