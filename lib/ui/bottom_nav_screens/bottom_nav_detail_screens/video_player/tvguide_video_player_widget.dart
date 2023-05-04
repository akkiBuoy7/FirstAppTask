import 'package:first_app/ui/bottom_nav_screens/bottom_nav_detail_screens/video_player/basic_overlay_layout.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../video_factory/video_factory_method.dart';

class TvGuideVideoPlayerWidget extends StatelessWidget
    implements VideoPlayerFactory {
  final VideoPlayerController videoPlayerController;

  const TvGuideVideoPlayerWidget(
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
                color: Colors.blue,
              ),
            ),
          );
  }

  Widget buildVideo() => OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
          var isPotrait = orientation == Orientation.portrait;

          print("############ispotrait ${isPotrait}");

          return Container(
            color: Colors.black,
            child: Column(
              children: [
                Stack(children: [
                  buildVideoPlayer(),
                  Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: buildIndicator())
                ]),
                buildControlButtons()
              ],
            ),
          );

          Stack(
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

  Widget buildIndicator() {
    return VideoProgressIndicator(
      videoPlayerController,
      allowScrubbing: true,
      colors: VideoProgressColors(
          backgroundColor: Colors.grey.shade50, playedColor: Colors.white),
    );
  }

  Widget buildControlButtons() {
    return Container(
      height: 50,
      color: Colors.blueGrey,
      child: Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
                onTap: () {
                  videoPlayerController.value.isPlaying
                      ? videoPlayerController.pause()
                      : videoPlayerController.play();
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: videoPlayerController.value.isPlaying
                      ? Icon(
                          Icons.pause_circle,
                          color: Colors.white,
                          size: 30,
                        )
                      : Icon(
                          Icons.play_circle,
                          color: Colors.white,
                          size: 30,
                        ),
                )),
            Container(
              width: 50,
              height: 25,
              child: Center(
                  child: Text(
                "Now",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              )),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  shape: BoxShape.rectangle,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
