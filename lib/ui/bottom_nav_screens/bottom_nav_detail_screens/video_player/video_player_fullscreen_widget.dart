import 'package:first_app/ui/bottom_nav_screens/bottom_nav_detail_screens/video_player/basic_overlay_layout.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerFullScreenWidget extends StatelessWidget {
  final VideoPlayerController videoPlayerController;

  const VideoPlayerFullScreenWidget(
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

  Widget buildVideo() => Stack(
    fit: StackFit.expand,
      children: [
        buildVideoPlayer(),
        Positioned.fill(
            child: BasicOverlayWidget(
                videoPlayerController: videoPlayerController))
      ]);

  Widget buildVideoPlayer() => buildFullScreen(
    child: AspectRatio(
        aspectRatio: videoPlayerController.value.aspectRatio,
        child: VideoPlayer(videoPlayerController)),
  );

  Widget buildFullScreen({required AspectRatio child}) {

    final size = videoPlayerController.value.size;
    final width = size.width;
    final height = size.height;
    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(child: child,width: width,height: height,),
    );
  }
}
