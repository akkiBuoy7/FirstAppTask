import 'package:first_app/model/movie_items.dart';
import 'package:first_app/ui/bottom_nav_screens/bottom_nav_detail_screens/landscape_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PlayerScreen extends StatefulWidget {

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  Video? videoModel;

  late VideoPlayerController _videoPlayerController;

  //String url = "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4";

  String url = "";

  void _playVideo() {

    String url = _getVideoUrl();

    _videoPlayerController = VideoPlayerController.network(url)
      ..addListener(() => setState(() {}))
      ..setLooping(true)
      ..initialize().then((value) => _videoPlayerController.play());
  }

  String _getVideoUrl(){

    final routeArgs1 = ModalRoute.of(context as BuildContext)
        ?.settings
        .arguments as Map<String, MovieDetail?>;
    url = routeArgs1['data']?.video.url??"";

    return url;
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
    // TODO: implement initState
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
    final routeArgs1 = ModalRoute.of(context as BuildContext)
        ?.settings
        .arguments as Map<String, Video?>;
    videoModel = routeArgs1['data'];

    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text("playing"),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Container(
              color: Colors.blue,
              height: 300,
              child: _videoPlayerController.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _videoPlayerController.value.aspectRatio,
                      child: Stack(children: [
                        VideoPlayer(_videoPlayerController),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context)
                              =>LandscapePage(_videoPlayerController)));
                            },
                            icon: Icon(Icons.fullscreen),
                            color: Colors.white,
                          ),
                        )
                      ]))
                  : Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
            ),
            Row(
              children: [
                ValueListenableBuilder(
                    valueListenable: _videoPlayerController,
                    builder: (context, VideoPlayerValue value, child) {
                      return Expanded(
                          flex: 1,
                          child: Text(
                            _videoDuration(value.position),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ));
                    }),
                Expanded(
                  flex: 9,
                  child: Container(
                    width: 200,
                    height: 20,
                    child: VideoProgressIndicator(_videoPlayerController,
                        allowScrubbing: true),
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: Text(
                      _videoDuration(_videoPlayerController.value.duration),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    )),
              ],
            ),
            IconButton(
                onPressed: () {
                  _videoPlayerController.value.isPlaying
                      ? _videoPlayerController.pause()
                      : _videoPlayerController.play();
                },
                icon: Icon(
                  _videoPlayerController.value.isPlaying
                      ? Icons.pause_circle
                      : Icons.play_circle,
                  color: Colors.white,
                ))
          ],
        ));
  }
}
