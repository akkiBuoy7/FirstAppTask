import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';

import '../video_player/basic_video_player_widget.dart';
import '../video_player/complete_video_palyer_widget.dart';
import 'advance_video_player.dart';
import 'basic_video_player.dart';

enum VideoPlayerType {
  BASIC_VIDEO_PLAYER,
  ADVANCE_VIDEO_PLAYER
}

abstract class VideoPlayerFactory {
  Widget build(BuildContext context);


  factory VideoPlayerFactory(VideoPlayerType type,VideoPlayerController _videoPlayerController){
    switch (type) {
      case VideoPlayerType.BASIC_VIDEO_PLAYER:
        return VideoPlayerWidgetFactory(videoPlayerController: _videoPlayerController);
      case VideoPlayerType.ADVANCE_VIDEO_PLAYER:
        return CompleteVideoPlayerWidgetFactory(
            videoPlayerController: _videoPlayerController);
      default:
        return VideoPlayerWidgetFactory(videoPlayerController: _videoPlayerController);
    }
  }
}