import 'package:first_app/ui/bottom_nav_screens/bottom_nav_detail_screens/video_factory/video_factory_method.dart';
import 'package:first_app/ui/bottom_nav_screens/bottom_nav_detail_screens/video_player/basic_overlay_layout.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidgetFactory extends StatelessWidget
    implements VideoPlayerFactory {
  final VideoPlayerController videoPlayerController;

  const VideoPlayerWidgetFactory(
      {Key? key, required this.videoPlayerController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return videoPlayerController != null &&
            videoPlayerController.value.isInitialized
        ? Container(
            alignment: Alignment.center,
            child: buildVideo(),
          )
        : Container(
            height: 200,
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          );
  }

  Widget buildVideo() => OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
          var isPotrait = orientation == Orientation.portrait;

          print("############ispotrait ${isPotrait}");

          return Stack(
            fit: isPotrait ? StackFit.loose : StackFit.expand,
            children: [
              buildVideoPlayer(),
              Positioned.fill(
                  child: BasicOverlayWidget(
                      videoPlayerController: videoPlayerController))
            ],
          );
        },
      );

  Widget buildVideoPlayer() => AspectRatio(
      aspectRatio: videoPlayerController.value.aspectRatio,
      child: VideoPlayer(videoPlayerController));
}
