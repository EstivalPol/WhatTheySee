import 'package:flutter/material.dart';

class BottomGradient extends StatelessWidget {
  final double offset;

  const BottomGradient({Key? key, this.offset = 0.95}) : super(key: key);
  const BottomGradient.noOffset({Key? key})
      : offset = 1.0,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        end: const FractionalOffset(0.0, 0.0),
        begin: FractionalOffset(0.0, offset),
        colors: const <Color>[
          Color(0xff222128),
          Color(0x442C2B33),
          Color(0x002C2B33)
        ],
      )),
    );
  }
}
