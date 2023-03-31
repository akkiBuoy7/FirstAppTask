import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class AdvanceOverlayWidget extends StatelessWidget {
  final VideoPlayerController videoPlayerController;
  final VoidCallback onClickedFullScreen;
  static var allSpeed = [0.25, 0.5, 1, 1.5, 2, 3];

  AdvanceOverlayWidget(
      {Key? key,
      required this.videoPlayerController,
      required this.onClickedFullScreen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMuted = videoPlayerController.value.volume == 0;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          videoPlayerController.value.isPlaying
              ? videoPlayerController.pause()
              : videoPlayerController.play();
        },
        child: Stack(
          children: [
            buildPlay(),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Row(
                  children: [
                    SizedBox(
                      width: 5,
                    ),
                    ValueListenableBuilder(
                        valueListenable: videoPlayerController,
                        builder: (context, VideoPlayerValue value, child) {
                          return Text(
                            _videoDuration(value.position),
                            style: TextStyle(fontSize: 10, color: Colors.white),
                          );
                        }),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(child: buildIndicator()),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      _videoDuration(videoPlayerController.value.duration),
                      style: TextStyle(fontSize: 10, color: Colors.white),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                  ],
                )),
            Positioned(
                top: 5,
                right: 5,
                child: GestureDetector(
                    onTap: onClickedFullScreen,
                    child: Icon(
                      Icons.fullscreen,
                      color: Colors.white,
                    ))),
            Positioned(
                left: 5,
                child: Row(
                  children: [
                    buildSpeed(),
                    SizedBox(),
                    buildVolume(isMuted),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget buildIndicator() {
    return SizedBox(
        height: 10,
        child: VideoProgressIndicator(videoPlayerController,
            allowScrubbing: true));
  }

  Widget buildVolume(isMuted) {
    return IconButton(
      color: Colors.white,
      onPressed: () {
        videoPlayerController.setVolume(isMuted ? 1 : 0);
      },
      icon: Icon(isMuted ? Icons.volume_mute : Icons.volume_up),
    );
  }

  Widget buildPlay() {
    return videoPlayerController.value.isPlaying
        ? Container()
        : Container(
            alignment: Alignment.center,
            child: Icon(
              Icons.play_circle,
              color: Colors.white,
              size: 70,
            ),
            color: Colors.black26,
          );
  }

  String _videoDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes);
    final seconds = twoDigits(duration.inSeconds);

    return [if (duration.inHours > 0) hours, minutes, seconds].join(":");
  }

  Widget buildSpeed() {
    return PopupMenuButton(
      color: Colors.black,
      initialValue: videoPlayerController.value.playbackSpeed,
      tooltip: "speed",
      onSelected: (value) {
        videoPlayerController.setPlaybackSpeed(value.toDouble());
      },
      itemBuilder: (context) => allSpeed
          .map((speed) => PopupMenuItem(
              value: speed,
              child: Text(
                "$speed",
                style: TextStyle(color: Colors.white),
              )))
          .toList(),
      child: Row(
        children: [
          Icon(
            Icons.shutter_speed,
            color: Colors.white,
          ),
          Text(
            "${videoPlayerController.value.playbackSpeed}",
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }
}
