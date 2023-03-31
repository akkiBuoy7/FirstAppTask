import 'package:first_app/ui/bottom_nav_screens/bottom_nav_detail_screens/video_player/complete_video_palyer_widget.dart';
import 'package:first_app/ui/bottom_nav_screens/bottom_nav_detail_screens/video_player/video_player_fullscreen_widget.dart';
import 'package:first_app/ui/bottom_nav_screens/bottom_nav_detail_screens/video_player/video_player_orientation_widget.dart';
import 'package:first_app/ui/bottom_nav_screens/bottom_nav_detail_screens/video_player/basic_video_player_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';

import '../../../model/movie_items.dart';

class MyPlayerScreen extends StatefulWidget {

  @override
  State<MyPlayerScreen> createState() => _MyPlayerScreenState();
}

class _MyPlayerScreenState extends State<MyPlayerScreen> {

  late VideoPlayerController _videoPlayerController;



  String url =
      "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4";

  void _playVideo() {
    _videoPlayerController = VideoPlayerController.network(url)
      ..addListener(() => setState(() {}))
      // ..setLooping(true)
      ..initialize().then((value) => _videoPlayerController.play());
  }

  String _videoDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes);
    final seconds = twoDigits(duration.inSeconds);

    return [if (duration.inHours > 0) hours, minutes, seconds].join(":");
  }

  @override
  void initState() {
    _playVideo();
    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //return VideoPlayerOrientationWidget(videoPlayerController: _videoPlayerController);
    // return VideoPlayerWidget(videoPlayerController: _videoPlayerController);
    return CompleteVideoPlayerWidget(videoPlayerController: _videoPlayerController);
  }
}
