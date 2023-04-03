import 'package:auto_orientation/auto_orientation.dart';
import 'package:first_app/ui/bottom_nav_screens/bottom_nav_detail_screens/video_factory/video_factory_method.dart';
import 'package:first_app/ui/bottom_nav_screens/bottom_nav_detail_screens/video_player/advance_overlay_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:native_device_orientation/native_device_orientation.dart';
import 'package:video_player/video_player.dart';

class CompleteVideoPlayerWidgetFactory extends StatefulWidget
    implements VideoPlayerFactory {
   VideoPlayerController videoPlayerController;

   CompleteVideoPlayerWidgetFactory(
      {Key? key, required this.videoPlayerController})
      : super(key: key);

  @override
  State<CompleteVideoPlayerWidgetFactory> createState() =>
      _CompleteVideoPlayerWidgetState(videoPlayerController);

  @override
  Widget build(BuildContext? context) {

    return _CompleteVideoPlayerWidgetState(videoPlayerController).build(context!);
  }
}

class _CompleteVideoPlayerWidgetState
    extends State<CompleteVideoPlayerWidgetFactory> {
  // orientation of the player
  late Orientation? target;
  VideoPlayerController videoPlayerController;

  _CompleteVideoPlayerWidgetState(this.videoPlayerController);

  @override
  void initState() {
    super.initState();

    setOrientationWhenRotated();
  }

  @override
  void dispose() {
    widget.videoPlayerController.dispose();
    setAllOrientation();

    super.dispose();
  }

  /*
  Method to reset device orientation when exiting
   */
  Future setAllOrientation() async {
    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  }

  /*
  Method to setup orientation when device is rotated
   */
  void setOrientationWhenRotated() {
    NativeDeviceOrientationCommunicator()
        .onOrientationChanged(useSensor: true)
        .listen((event) {
      final isPotrait = event == NativeDeviceOrientation.portraitUp;
      final isLandscape = event == NativeDeviceOrientation.landscapeRight ||
          event == NativeDeviceOrientation.landscapeLeft;

      final isTargetPotrait = target == Orientation.portrait;
      final isTargetLandscape = target == Orientation.landscape;

      /*
      If player and device both in potrait reset the device orientation
      or
      If player and device both in landscape reset the device orientation
       */
      if (isPotrait && isTargetPotrait || isLandscape && isTargetLandscape) {
        target = null;

        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return videoPlayerController != null &&
            videoPlayerController.value.isInitialized
        ? Container(
            alignment: Alignment.center,
            child: buildVideo(),
          )
        : Container(
            // if url not received show progress indicator
            height: 200,
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          );
  }

  /*
  OrientationBuilder : Provides the device orientation object
   */

  Widget buildVideo() => OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
          var isPotrait = orientation == Orientation.portrait;

          return Stack(
            // if in landscape then expand to acquire whole width
            fit: isPotrait ? StackFit.loose : StackFit.expand,
            children: [
              buildVideoPlayer(),
              Positioned.fill(
                  /*
                AdvanceOverlayWidget : place the overlay screen on top of
                video player
                onClickedFullScreen:
                Call back method when fullscreen is clicked
                so that video player can be rotated
                 */
                  child: AdvanceOverlayWidget(
                      videoPlayerController: videoPlayerController,
                      onClickedFullScreen: () {
                        _changeOrientation(isPotrait);
                      }))
            ],
          );
        },
      );

  /*
  Main method to show the video player acc to aspect ratio of the video
   */
  Widget buildVideoPlayer() => AspectRatio(
      aspectRatio: videoPlayerController.value.aspectRatio,
      child: VideoPlayer(videoPlayerController));

  void _changeOrientation(bool isPotrait) {
    /*
     if videoPlayer is in Portrait then on clicking
     change to landscape
     and vice versa
     */

    if (isPotrait) {
      // remove overlay status bar when in landscape
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
      AutoOrientation.landscapeRightMode();
    } else {
      AutoOrientation.portraitUpMode();
    }
  }
}
