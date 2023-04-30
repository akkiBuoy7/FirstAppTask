import 'package:first_app/bloc/watchlist_bloc/tvguide_bloc.dart';
import 'package:first_app/model/tv_guide_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/internet_bloc/internet_bloc.dart';
import 'package:video_player/video_player.dart';

import 'bottom_nav_detail_screens/video_factory/video_factory_method.dart';
import 'bottom_nav_detail_screens/video_player/complete_video_palyer_widget.dart';

class WatchlistScreen extends StatefulWidget {
  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  List<TvGuideDetails> tvGuideItemList = [];
  int _selectedTilePrev = -1;
  bool clickExpanded = false;
  late VideoPlayerController videoPlayerController;
  late Future<void> videoPlayerFuture;

  @override
  void initState() {
    context.read<InternetBloc>().getConnectivity();
    videoPlayerController = VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Watch List", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: _usingMultiBlocListener(),
    );
  }

  Widget _usingMultiBlocListener() {
    return Container(
      child: MultiBlocListener(
          listeners: [
            BlocListener<InternetBloc, InternetState>(
              listener: (context, state) {
                if (state is InternetConnectedState) {
                  context.read<TvGuideBloc>().add(TvGuideLoadedEvent());
                } else if (state is InternetLostState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("No internet"),
                    ),
                  );
                }
              },
            ),
            BlocListener<TvGuideBloc, TvGuideState>(listener: (context, state) {
              if (state is TvGuideErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                  ),
                );
              }
            })
          ],
          child: BlocBuilder<TvGuideBloc, TvGuideState>(
            builder: (context, state) {
              if (state is TvGuideLoadingState) {
                return _buildLoading();
              } else if (state is TvGuideLoadedState) {
                tvGuideItemList = state.tvGuideItemList;
                return _buildListViewUi(
                  context,
                );
              } else {
                return Container();
              }
            },
          )),
    );
  }

  Widget _buildLoading() => Center(child: CircularProgressIndicator());

  Widget _buildListViewUi(
    BuildContext context,
  ) {
    return ListView.builder(
      key: Key(_selectedTilePrev.toString()),
      itemBuilder: (context, index) {
        return _buildCustomContainer(index);
      },
      itemCount: tvGuideItemList.length,
    );
  }

  Widget _buildListContainer(int indexMain) {
    //print("tvGuideItemList LENGTH ########### ${tvGuideItemList.length}");

    return ExpansionPanelList.radio(
      expansionCallback: (index, isExpanded) {
        setState(() {
          print("EXPANSION INDEX ${indexMain}");
          tvGuideItemList[indexMain].isExpanded = !isExpanded;
        });
      },
      animationDuration: Duration(milliseconds: 1000),
      children: [
        ExpansionPanelRadio(
          canTapOnHeader: true,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(tvGuideItemList[indexMain].movieName!),
            );
          },
          body: ListTile(
            title: Text(tvGuideItemList[indexMain].description!),
          ),
          value: Key(tvGuideItemList[indexMain].movieName.toString()),
        )
      ],
    );
  }

  Widget _buildCustomContainer(int index) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {

              videoPlayerController = VideoPlayerController.network( tvGuideItemList[index].video?.url??"")
                ..addListener(() => setState(() {}))
                ..setLooping(true)
                ..initialize().then((value) => videoPlayerController.play());

              tvGuideItemList[index].isExpanded =
                  !tvGuideItemList[index].isExpanded;
              if (_selectedTilePrev != -1 && _selectedTilePrev != index) {
                tvGuideItemList[_selectedTilePrev].isExpanded =
                    !tvGuideItemList[_selectedTilePrev].isExpanded;
              }
            });
            _selectedTilePrev = index;
          },
          child: Container(
            height: 50,
            color: Colors.grey,
            child: Align(
              child: Text(tvGuideItemList[index].movieName!),
              alignment: Alignment.centerLeft,
            ),
          ),
        ),
        Visibility(
          visible: tvGuideItemList[index].isExpanded,
          child: _buildAdvancedPlayer(index),
        )
      ],
    );
  }

  Widget _buildDummyContainer(int index) {
    return Container(
      child: Text(tvGuideItemList[index].description!),
    );
  }

  Widget _buildVideoPlayer(int index) {
    return videoPlayerController.value.isInitialized
        ? AspectRatio(
            aspectRatio: videoPlayerController.value.aspectRatio,
            child: VideoPlayer(videoPlayerController),
          )
        : Container();
  }

  Widget _buildAdvancedPlayer(int index){
    return VideoPlayerFactory(
        VideoPlayerType.ADVANCE_VIDEO_PLAYER, videoPlayerController)
        .build(context);
  }
}
