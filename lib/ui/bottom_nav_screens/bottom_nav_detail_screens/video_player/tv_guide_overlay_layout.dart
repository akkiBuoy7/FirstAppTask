import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/*
Video Controller Overlay
 */

class TvGuideOverlayWidget extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final VoidCallback onClickedFullScreen; // for clicking FullScreen
  static var allSpeed = [0.25, 0.5, 1, 1.5, 2, 3]; // controlling video speed

  TvGuideOverlayWidget(
      {Key? key,
        required this.videoPlayerController,
        required this.onClickedFullScreen})
      : super(key: key);

  @override
  State<TvGuideOverlayWidget> createState() => _TvGuideOverlayWidgetState();
}

class _TvGuideOverlayWidgetState extends State<TvGuideOverlayWidget> {
  // boolean to toggle overlay
  bool showOvelay = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        // behavior is important for the click
          behavior: HitTestBehavior.opaque,
          onTap: () {
            setState(() {
              // on clicking anywhere in the overlay change the toggle
              showOvelay = !showOvelay;
            });
          },
          /*
          if showOvelay = true return the stack
          else
          return empty transparent container
           */
          child: showHideOverlay(showOvelay)),
    );
  }

  Widget showHideOverlay(bool showOverlay) {
    // if volume is 0 then Mute is true
    final isMuted = widget.videoPlayerController.value.volume == 0;
    /*
    If showOverlay = true(on tapping Gesture detector) => show the whole overlay stack
    else:
    Show empty container
     */
    if (showOvelay) {
      return Stack(
        children: [
          mainContainer(), // pseudo transparent parent container for overlay
          // row => rewind | play | forward
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // REWIND
              // Padding(
              //   padding: const EdgeInsets.all(10.0),
              //   child: buildRewind(),
              // ),
              // PLAY / PAUSE
              buildPlay(),
              // FORWARD
              // Padding(
              //     padding: const EdgeInsets.all(10.0), child: buildForward())
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
                  // REMAINING TIME
                  ValueListenableBuilder(
                    // helps in getting value from any widget
                      valueListenable: widget.videoPlayerController,
                      // here we are using for VideoPlayerValue
                      builder: (context, VideoPlayerValue value, child) {
                        return Text(
                          // get current left position of the video
                          _videoDuration(value.position),
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        );
                      }),
                  SizedBox(
                    width: 10,
                  ),
                  // PROGRESS INDICATOR
                  Expanded(child: buildIndicator()),
                  SizedBox(
                    width: 10,
                  ),
                  // TOTAL TIME
                  Text(
                    _videoDuration(widget.videoPlayerController.value.duration),
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                ],
              )),
          // FULL SCREEN
          // Positioned(
          //     top: 5,
          //     right: 5,
          //     child: GestureDetector(
          //         onTap: widget.onClickedFullScreen,
          //         child: Icon(
          //           Icons.fullscreen,
          //           color: Colors.white,
          //         ))),
          // SPEED VOLUME
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
    // if showOverlay is false return empty transparent container
    return Container();
  }

  /*
  Method to show video progress indicator
   */
  Widget buildIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: SizedBox(
          height: 12,
          child: VideoProgressIndicator(widget.videoPlayerController,
              allowScrubbing: true)),
    );
  }

  /*
  Method to mute
   */
  Widget buildVolume(isMuted) {
    return IconButton(
      color: Colors.white,
      onPressed: () {
        /*
        if isMute true already the give volume = 1 on clicking
        else set volume to 0
         */
        widget.videoPlayerController.setVolume(isMuted ? 1 : 0);
      },
      icon: Icon(isMuted ? Icons.volume_mute : Icons.volume_up),
    );
  }

  /*
  Method to toggle play and pause button
   */
  Widget buildPlay() {
    return widget.videoPlayerController.value.isPlaying
        ?
    // if playing then show pause icon
    GestureDetector(
      onTap: () {
        // on clicking pause icon pause
        if (widget.videoPlayerController.value.isPlaying) {
          widget.videoPlayerController.pause();
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
        :
    // if not playing then show play icon
    GestureDetector(
      onTap: () {
        // on clicking play icon play
        if (!widget.videoPlayerController.value.isPlaying) {
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

  /*
  Main pseudo parent container in the stack
   */
  Widget mainContainer() {
    return widget.videoPlayerController.value.isPlaying
        ? Container(
      alignment: Alignment.center,
      color: Colors.black26,
    )
        : Container(
      alignment: Alignment.center,
      color: Colors.black26,
    );
  }

  /*
  Method to format duration into 00:00
   */
  String _videoDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes);
    final seconds = twoDigits(duration.inSeconds);

    return [if (duration.inHours > 0) hours, minutes, seconds].join(":");
  }

  /*
  Method to control speed
   */
  Widget buildSpeed() {
    return PopupMenuButton(
      color: Colors.black,
      initialValue: widget.videoPlayerController.value.playbackSpeed,
      tooltip: "speed",
      onSelected: (value) {
        // set the selected speed into the controller
        widget.videoPlayerController.setPlaybackSpeed(value.toDouble());
      },
      itemBuilder: (context) => TvGuideOverlayWidget.allSpeed
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

  /*
  Widget to rewind
   */
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

  /*
  Widget to forward
   */
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

  /*
  Method to get the current video pos and return it in a callback
   */
  Future goToPosition(
      Duration Function(Duration currentPosition) builder) async {
    final currentPosition = await widget.videoPlayerController.position;
    // pass current pos in the callback and get the new pos upon callback triggered
    final newPosition = builder(currentPosition!);
    // pass the new skipped pos into the controller
    await widget.videoPlayerController.seekTo(newPosition);
  }

  // forward by 2 sec by adding to current pos
  Future forward2Sec() async =>
      goToPosition((currentPosition) => currentPosition + Duration(seconds: 2));

  // backward by 2 sec by subtracting from current pos
  Future backward2Sec() async =>
      goToPosition((currentPosition) => currentPosition - Duration(seconds: 2));
}
