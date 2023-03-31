import 'package:auto_orientation/auto_orientation.dart';
import 'package:first_app/ui/bottom_nav_screens/bottom_nav_detail_screens/video_player/advance_overlay_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:native_device_orientation/native_device_orientation.dart';
import 'package:video_player/video_player.dart';

class CompleteVideoPlayerWidget extends StatefulWidget {
  final VideoPlayerController videoPlayerController;

  const CompleteVideoPlayerWidget(
      {Key? key, required this.videoPlayerController})
      : super(key: key);

  @override
  State<CompleteVideoPlayerWidget> createState() =>
      _CompleteVideoPlayerWidgetState();
}

class _CompleteVideoPlayerWidgetState extends State<CompleteVideoPlayerWidget> {
  late Orientation? target;

  @override
  void initState() {
    super.initState();

    NativeDeviceOrientationCommunicator()
        .onOrientationChanged(useSensor: true)
        .listen((event) {
      final isPotrait = event == NativeDeviceOrientation.portraitUp;
      final isLandscape = event == NativeDeviceOrientation.landscapeRight ||
          event == NativeDeviceOrientation.landscapeLeft;

      final isTargetPotrait = target == Orientation.portrait;
      final isTargetLandscape = target == Orientation.landscape;

      if (isPotrait && isTargetPotrait || isLandscape && isTargetLandscape) {
        target = null;

        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      }
    });
  }

  @override
  void dispose() {
    widget.videoPlayerController.dispose();
    setAllOrientation();

    super.dispose();
  }

  Future setAllOrientation() async {
    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  }

  @override
  Widget build(BuildContext context) {
    return widget.videoPlayerController != null &&
            widget.videoPlayerController.value.isInitialized
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
                  child: AdvanceOverlayWidget(
                      videoPlayerController: widget.videoPlayerController,
                      onClickedFullScreen: () {
                        target = isPotrait
                            ? Orientation.landscape
                            : Orientation.portrait;

                        _changeOrientation(isPotrait);

                        // if (isPotrait) {
                        //
                        //   AutoOrientation.landscapeRightMode();
                        // } else {
                        //   AutoOrientation.portraitUpMode();
                        // }
                      }))
            ],
          );
        },
      );

  Widget buildVideoPlayer() => AspectRatio(
      aspectRatio: widget.videoPlayerController.value.aspectRatio,
      child: VideoPlayer(widget.videoPlayerController));

  void _changeOrientation(bool isPotrait){
    if (isPotrait) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
      AutoOrientation.landscapeRightMode();
    } else {
      AutoOrientation.portraitUpMode();
    }
  }
}
