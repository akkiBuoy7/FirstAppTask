import 'package:first_app/ui/bottom_nav_screens/bottom_nav_detail_screens/video_player/complete_video_palyer_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';

import '../../../model/movie_items.dart';

/*
Main Player Screen :
  Receives the Url and loads it into VideoPlayerController
  Passes then VideoPlayerController to VideoPlayer Widget
 */

class AdvancePlayerScreen extends StatefulWidget {

  Video? videoModel;


  AdvancePlayerScreen(this.videoModel);

  @override
  State<AdvancePlayerScreen> createState() => _AdvancePlayerScreenState();
}

class _AdvancePlayerScreenState extends State<AdvancePlayerScreen> {

  late VideoPlayerController _videoPlayerController;
  String url = "";



  // String url =
  //     "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4";

  void _playVideo() {

    //url = _getVideoUrl();

    _videoPlayerController = VideoPlayerController.network(widget.videoModel?.url??"")
      ..addListener(() => setState(() {})) // on any click listen set the state
      // ..setLooping(true)
      ..initialize().then((value) => _videoPlayerController.play());
  }

  String _getVideoUrl(){


    final routeArgs1 = ModalRoute.of(context as BuildContext)
        ?.settings
        .arguments as Map<String, MovieDetail?>;
    url = routeArgs1['data']?.video.url??"";

    return url;
  }

  @override
  void initState() {

    super.initState();
    _playVideo();
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
