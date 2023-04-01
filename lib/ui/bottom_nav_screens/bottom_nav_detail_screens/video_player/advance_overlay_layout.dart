import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class AdvanceOverlayWidget extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final VoidCallback onClickedFullScreen;
  static var allSpeed = [0.25, 0.5, 1, 1.5, 2, 3];

  AdvanceOverlayWidget(
      {Key? key,
      required this.videoPlayerController,
      required this.onClickedFullScreen})
      : super(key: key);

  @override
  State<AdvanceOverlayWidget> createState() => _AdvanceOverlayWidgetState();
}

class _AdvanceOverlayWidgetState extends State<AdvanceOverlayWidget> {
  bool showOvelay = true;

  @override
  Widget build(BuildContext context) {
    final isMuted = widget.videoPlayerController.value.volume == 0;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            setState(() {
              showOvelay = !showOvelay;
              print("##############Show Overlay${showOvelay}");
            });
          },
          child: showHideOverlay(showOvelay, isMuted)),
    );
  }

  Widget showHideOverlay(bool showOverlay, bool isMuted) {
    if (showOvelay) {
      return Stack(
        children: [
          mainContainer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: buildRewind(),
              ),
              buildPlay(),
              Padding(
                  padding: const EdgeInsets.all(10.0), child: buildForward())
            ],
          ),
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
                      valueListenable: widget.videoPlayerController,
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
                    _videoDuration(widget.videoPlayerController.value.duration),
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
                  onTap: widget.onClickedFullScreen,
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
      );
    }
    return Container();
  }

  Widget buildIndicator() {
    return SizedBox(
        height: 10,
        child: VideoProgressIndicator(widget.videoPlayerController,
            allowScrubbing: true));
  }

  Widget buildVolume(isMuted) {
    return IconButton(
      color: Colors.white,
      onPressed: () {
        widget.videoPlayerController.setVolume(isMuted ? 1 : 0);
      },
      icon: Icon(isMuted ? Icons.volume_mute : Icons.volume_up),
    );
  }

  Widget buildPlay() {
    return widget.videoPlayerController.value.isPlaying
        ? GestureDetector(
            onTap: () {
              if (widget.videoPlayerController.value.isPlaying) {
                widget.videoPlayerController.pause();
              } else {
                widget.videoPlayerController.play();
              }
            },
            child: Center(
              child: Icon(
                Icons.pause_circle,
                color: Colors.white,
                size: 70,
              ),
            ),
          )
        : GestureDetector(
            onTap: () {
              if (widget.videoPlayerController.value.isPlaying) {
                widget.videoPlayerController.pause();
              } else {
                widget.videoPlayerController.play();
              }
            },
            child: Center(
              child: Icon(
                Icons.play_circle,
                color: Colors.white,
                size: 70,
              ),
            ),
          );
  }

  Widget mainContainer() {
    return widget.videoPlayerController.value.isPlaying
        ? Container(
            alignment: Alignment.center,
          )
        : Container(
            alignment: Alignment.center,
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
      initialValue: widget.videoPlayerController.value.playbackSpeed,
      tooltip: "speed",
      onSelected: (value) {
        widget.videoPlayerController.setPlaybackSpeed(value.toDouble());
      },
      itemBuilder: (context) => AdvanceOverlayWidget.allSpeed
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
            "${widget.videoPlayerController.value.playbackSpeed}",
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }

  Widget buildRewind() {
    return GestureDetector(
        onTap: () {
          backward2Sec();
        },
        child: Icon(
          Icons.replay_5,
          color: Colors.white,
        ));
  }

  Widget buildForward() {
    return GestureDetector(
        onTap: () {
          forward2Sec();
        },
        child: Icon(
          Icons.forward_5,
          color: Colors.white,
        ));
  }

  Future goToPosition(
      Duration Function(Duration currentPosition) builder) async {
    final currentPosition = await widget.videoPlayerController.position;
    final newPosition = builder(currentPosition!);
    await widget.videoPlayerController.seekTo(newPosition);
  }

  Future forward2Sec() async =>
      goToPosition((currentPosition) => currentPosition + Duration(seconds: 2));

  Future backward2Sec() async =>
      goToPosition((currentPosition) => currentPosition - Duration(seconds: 2));
}
