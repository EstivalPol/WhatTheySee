import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/// Homepage
class YoutubePage extends StatefulWidget {
  const YoutubePage(
      {this.movie, this.callback, this.setHeight, this.youtubeId, Key? key})
      : super(key: key);
  final dynamic movie;
  final VoidCallback? callback;
  final VoidCallback? setHeight;
  final String? youtubeId;

  @override
  YoutubePageState createState() => YoutubePageState();
}

class YoutubePageState extends State<YoutubePage> {
  YoutubePlayerController? _controller;
  bool _isPlayerReady = false;

  String vidYoutube = 'fN_xDcvJaE8';

  @override
  void initState() {
    super.initState();

    if (widget.youtubeId != null && widget.youtubeId != '') {
      vidYoutube = widget.youtubeId!;
    }

    debugPrint("[YoutubePage] vidYoutube $vidYoutube");

    _controller = YoutubePlayerController(
      initialVideoId: vidYoutube,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: false, // true
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller!.value.isFullScreen) {
      setState(() {
        //_playerState = _controller.value.playerState;
        //_videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void deactivate() {
    try {
      _controller!.pause();
    } catch (e) {
      debugPrint("");
    }
    super.deactivate();
  }

  @override
  void dispose() {
    try {
      _controller!.dispose();
    } catch (e) {
      debugPrint("");
    }

    super.dispose();
  }

  List<DeviceOrientation> oriens = <DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        widget.callback!();
      },
      onEnterFullScreen: () {
        widget.setHeight!();
      },
      player: YoutubePlayer(
        controller: _controller!,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Get.theme.colorScheme.secondary,
        onReady: () {
          _isPlayerReady = true;
        },
        onEnded: (data) {
          _controller!.load(vidYoutube);
        },
      ),
      builder: (context, player) => Scaffold(
        key: _scaffoldKey,
        body: Container(
          child: player,
        ),
      ),
    );
  }
}
