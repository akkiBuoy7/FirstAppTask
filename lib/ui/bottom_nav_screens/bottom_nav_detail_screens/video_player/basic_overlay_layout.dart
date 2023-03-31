import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class BasicOverlayWidget extends StatelessWidget {
  final VideoPlayerController videoPlayerController;

  const BasicOverlayWidget({Key? key, required this.videoPlayerController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(behavior: HitTestBehavior.opaque,
      onTap: (){
        videoPlayerController.value.isPlaying? videoPlayerController.pause():
            videoPlayerController.play();
      },
      child: Stack(children: [
        buildPlay(),
        Positioned(
          bottom: 0,
            left: 0,
            right: 0,
            child: buildIndicator())
      ],),
    );
  }
  
  Widget buildIndicator(){
    return VideoProgressIndicator(videoPlayerController, allowScrubbing: true);
  }

  Widget buildPlay(){
    return videoPlayerController.value.isPlaying?
        Container():
        Container(
          alignment: Alignment.center,
          child: Icon(Icons.play_circle,color: Colors.white,size: 70,),
        color: Colors.black26,);
  }

}
