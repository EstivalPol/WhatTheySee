import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:whattheysee/components/ob_homecontroller.dart';
import 'package:whattheysee/home.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  OnBoardingPageState createState() => OnBoardingPageState();
}

class OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  @override
  void initState() {
    super.initState();
  }

  void _onIntroEnd(context) {
    ObHomeController.to.saveFirst(1);
    ObHomeController.to.secondCall();
    Get.off(const HomePage());
  }

  Widget _buildImage(String assetName) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        children: [
          const SizedBox(
            height: 55,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              'assets/images/$assetName.jpg',
              width: 190.0,
              fit: BoxFit.cover,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);
    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: ObHomeController.mAINCOLOR,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          title: "Movie Lover",
          body:
              "Super Apps for Movie lover, fans, actors, news and trailers revealed. WhatTheySee - Movie Apps.",
          image: _buildImage('img1'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Over 50.000 Movies",
          body:
              "Find your favorite movie, popular, upcoming, top-rated movies. Enjoy your time.",
          image: _buildImage('img2'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Dark & Light Mode",
          body:
              "WhatTheySee have two themes, Dark and Light Mode. Adjust for your convenience and make it comfortable.",
          image: _buildImage('img3'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Made with Flutter",
          body:
              "Design beautiful apps, protable UI Toolkit for building native Apps. Let's Flute the Dart.",
          image: _buildImage('img4'),
          footer: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onPressed: () {
                _onIntroEnd(context);
              },
              child: const Text(
                'Let\'s Started',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      //skipFlex: 0,
      nextFlex: 0,
      skip: Container(
        width: 40,
        decoration: BoxDecoration(
          color: Colors.deepOrange.withOpacity(.9),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
          child: Text(
            "Skip",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
      ),
      next: const Icon(Icons.arrow_forward, color: Colors.white70),
      done: Container(
        width: 45,
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(.9),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
          child: Text(
            "Done",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
      ),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFF3f3f3),
        activeSize: Size(22.0, 10.0),
        activeColor: Colors.deepOrange,
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
