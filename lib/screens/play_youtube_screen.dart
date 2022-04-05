import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../data/constants.dart';
import '../data/image_paths.dart';

class PlayYTVideo extends StatefulWidget {
  String url;

  PlayYTVideo({required this.url,Key? key}) : super(key: key);

  @override
  _PlayYTVideoState createState() => _PlayYTVideoState();
}

class _PlayYTVideoState extends State<PlayYTVideo> {
  late YoutubePlayerController _controller;
  late YoutubeMetaData _videoMetaData;

  bool _isPlayerReady = false;
  late PlayerState _playerState;

  var videoId;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: videoId =
          YoutubePlayer.convertUrlToId(widget.url).toString(),
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        loop: false,
        isLive: false,
        forceHD: false,
      ),
    );
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Container(
              color: Colors.black,
              child: Center(
                child: YoutubePlayer(
                  controller: _controller,
                  aspectRatio: 100 / 100,
                  showVideoProgressIndicator: true,
                  progressColors: ProgressBarColors(
                    playedColor: Colors.white,
                    handleColor: Colors.white,
                  ),
                  onReady: () {
                    _controller.addListener(listener);
                  },
                ),
              ),
            ),
          ),
          Positioned(
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                    margin:
                    const EdgeInsets.symmetric(vertical: 40, horizontal: 15),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: kPrimaryColorLight,
                      borderRadius: BorderRadius.circular(200),
                    ),
                    child: const Icon(
                      Icons.arrow_back_outlined,
                      color: Colors.white,
                    )),
              )
          ),
        ],
      ),
    );
  }
}

