import 'package:first_app/bloc/watchlist_bloc/tvguide_bloc.dart';
import 'package:first_app/model/tv_guide_item.dart';
import 'package:first_app/ui/bottom_nav_screens/bottom_nav_detail_screens/video_factory/video_factory_method.dart';
import 'package:first_app/utility/common_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

import '../../../bloc/internet_bloc/internet_bloc.dart';
import '../../../bloc/watchlist_bloc/tvguide_options_bloc/tv_guide_options_bloc.dart';
import '../../../custom_widget/modal_bottom_sheet.dart';

class TvGuideScreen extends StatefulWidget {
  @override
  State<TvGuideScreen> createState() => TvGuideScreenState();
}

@visibleForTesting
class TvGuideScreenState extends State<TvGuideScreen> {
  List<TvGuideDetails> tvGuideItemList = [];
  int _selectedTilePrev = -1;
  bool clickExpanded = false;
  late VideoPlayerController videoPlayerController;
  late Future<void> videoPlayerFuture;
  int selectedTile = -1;
  String selectedDropdownItem = "Channel1";
  int _selectedSortValue = 0;
  int _selectedRateValue = 0;

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Channel1"), value: "Channel1"),
      DropdownMenuItem(child: Text("Channel2"), value: "Channel2"),
      DropdownMenuItem(child: Text("Channel3"), value: "Channel3"),
      DropdownMenuItem(child: Text("Channel4"), value: "Channel4"),
      DropdownMenuItem(child: Text("Channel5"), value: "Channel5"),
    ];
    return menuItems;
  }

  @override
  void initState() {
    // Need to fix this. Method not listening to connectivity change
    //context.read<InternetBloc>().getConnectivity();
    context.read<InternetBloc>().add(InternetConnectedEvent());
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
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
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
                print("*****#### LOADING STATE RECEIVED");
                return _buildLoading();
              } else if (state is TvGuideLoadedState) {
                print("######## STATE TvGuideLoadedState UPDATE");
                tvGuideItemList = state.tvGuideItemList;
                return _buildParent(context, state);
              } else if (state is TvGuideExpandNextState) {
                print("######## STATE TvGuideExpandNextState UPDATE");
                return _buildParent(context, state);
              } else {
                return Container();
              }
            },
          )),
    );
  }

  Widget _buildLoading() => const Center(
          child: CircularProgressIndicator(
        color: Colors.white,
      ));

  Widget _buildParent(BuildContext context, TvGuideState state) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildOptionsUi(context),
          ),
        ),
        SliverToBoxAdapter(child: _buildListViewUi(context, state)
            // _buildListViewUi(context, state),
            )
      ],
    );
  }

  Widget _buildOptionsUi(BuildContext context) {
    return BlocBuilder<TvGuideOptionsBloc, TvGuideOptionsState>(
        builder: (context, state) {
      if (state is TvGuideShowSearchState) {
        if (state.showSearchBar) {
          return _buildSearchBar(context);
        } else {
          return _buildMenuOptions();
        }
      } else if (state is TvGuideSelectItemState) {
        selectedDropdownItem = state.value;
        return _buildMenuOptions();
      } else {
        return _buildMenuOptions();
      }
    });
  }

  Widget _buildMenuOptions() {
    return Container(
      height: 70,
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0)),
            width: 150,
            height: 40,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: DropdownButton(
                value: selectedDropdownItem,
                dropdownColor: Colors.grey,
                style: TextStyle(color: Colors.white, fontSize: 15),
                items: dropdownItems,
                onChanged: (String? value) {
                  context
                      .read<TvGuideOptionsBloc>()
                      .add(TvGuideSelectItemEvent(value!));
                },
              ),
            ),
          ),
          Container(
            color: Colors.black,
            width: 200,
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: GestureDetector(
                    onTap: () {
                      context
                          .read<TvGuideOptionsBloc>()
                          .add(TvGuideShowSearchEvent(true));
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      child: Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 20,
                      ),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: GestureDetector(
                    onTap: () {
                      _buildBottomSheet(
                          "Random", "Ascending", "Descending", true);
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      child: Icon(
                        Icons.grid_view,
                        color: Colors.white,
                        size: 20,
                      ),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: GestureDetector(
                    onTap: () {
                      _buildBottomSheet("Random", "High rated first",
                          "Low rated first", false);
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      child: Icon(
                        Icons.filter_alt,
                        color: Colors.white,
                        size: 20,
                      ),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildBottomSheet(
      String first, String second, String third, bool isSortingFilter) {
    return showModalBottomSheet(
        enableDrag: false,
        isDismissible: false,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        context: context,
        builder: (BuildContext context) {
          return CustomBottomSheet(
            selectedValue: isSortingFilter? _selectedSortValue: _selectedRateValue,
            firstOption: first,
            secondOption: second,
            thirdOption: third,
            callback: (value) {

              if (isSortingFilter) {
                _selectedSortValue = value;
                if (value == 0) {
                  context.read<TvGuideBloc>().add(TvGuideLoadedEvent());
                } else {
                  CommonMethods.sorting(value, tvGuideItemList,
                      (List<TvGuideDetails> list) {
                    context.read<TvGuideBloc>().add(TvGuideFilteredEvent(list));
                  });
                }
              } else {
                _selectedRateValue = value;
                if (value == 0) {
                  context.read<TvGuideBloc>().add(TvGuideLoadedEvent());
                } else {
                  CommonMethods.rateFilter(value, tvGuideItemList,
                      (List<TvGuideDetails> list) {
                    context.read<TvGuideBloc>().add(TvGuideFilteredEvent(list));
                  });
                }
              }
              print("######### Selected value is ${value}");
            },
          );
        });
  }

  // void _sorting(int selectedFilter, List<TvGuideDetails> itemList) {
  //   if (selectedFilter == 0) {
  //     context.read<TvGuideBloc>().add(TvGuideLoadedEvent());
  //   } else if (selectedFilter == 1) {
  //     itemList.sort((a, b) {
  //       //sorting in ascending order
  //       return a.movieName!.compareTo(b.movieName!);
  //     });
  //     print("LLLLLLL ${itemList[0].movieName}");
  //     sortFilterList = itemList;
  //     context.read<TvGuideBloc>().add(TvGuideFilteredEvent(sortFilterList));
  //   } else {
  //     itemList.sort((a, b) {
  //       //sorting in descending order
  //       return b.movieName!.toLowerCase().compareTo(a.movieName!.toLowerCase());
  //     });
  //     print("FFFFFF ${itemList[0].movieName}");
  //     sortFilterList = itemList;
  //     context.read<TvGuideBloc>().add(TvGuideFilteredEvent(sortFilterList));
  //   }
  // }

  // void rateFilter(int selectedFilter, List<TvGuideDetails> itemList) {
  //   if (selectedFilter == 0) {
  //     context.read<TvGuideBloc>().add(TvGuideLoadedEvent());
  //   } else if (selectedFilter == 1) {
  //     itemList.sort((a, b) {
  //       return b.rating!.compareTo(a.rating!);
  //     });
  //     print("LLLLLLL ${itemList[0].movieName}");
  //     rateFilterList = itemList;
  //     context.read<TvGuideBloc>().add(TvGuideFilteredEvent(rateFilterList));
  //   } else {
  //     itemList.sort((a, b) {
  //       return a.rating!.compareTo(b.rating!);
  //     });
  //     print("FFFFFF ${itemList[0].movieName}");
  //     rateFilterList = itemList;
  //     context.read<TvGuideBloc>().add(TvGuideFilteredEvent(rateFilterList));
  //   }
  // }

  sum1(int i, int j) {
    return i + j;
  }

  Widget _buildSearchBar(BuildContext context) {
    return TextField(
      onChanged: (value) => CommonMethods.runSearch(value, tvGuideItemList,
          (List<TvGuideDetails> list) {
        if (value.isEmpty) {
          context.read<TvGuideBloc>().add(TvGuideLoadedEvent());
        } else {
          context.read<TvGuideBloc>().add(TvGuideFilteredEvent(list));
        }
      }),
      style: TextStyle(color: Colors.white),
      decoration: new InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueGrey, width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueGrey, width: 5.0),
          ),
          hintText: 'Search. . . ',
          hintStyle: TextStyle(color: Colors.grey),
          prefixIcon: const Icon(
            Icons.search,
            color: Colors.white,
          ),
          suffixIcon: GestureDetector(
            onTap: () {
              context.read<TvGuideBloc>().add(TvGuideLoadedEvent());

              context
                  .read<TvGuideOptionsBloc>()
                  .add(TvGuideShowSearchEvent(false));
            },
            child: const Icon(
              Icons.close,
              color: Colors.white,
            ),
          )),
    );
  }

  // This function is called whenever the text field changes
  // void _runSearch(String enteredKeyword, List<TvGuideDetails> itemList) {
  //   suggestions = [];
  //   if (enteredKeyword.isEmpty) {
  //     context.read<TvGuideBloc>().add(TvGuideLoadedEvent());
  //   } else {
  //     suggestions = itemList.where((obj) {
  //       final movieName = obj.movieName?.toLowerCase();
  //       final input = enteredKeyword.toLowerCase();
  //
  //       return movieName!.contains(input);
  //     }).toList();
  //   }
  //
  //   context.read<TvGuideBloc>().add(TvGuideFilteredEvent(suggestions));
  // }

  // ################# Using Expansion Panel Radio ********************

  Widget _buildListContainer() {
    //print("tvGuideItemList LENGTH ########### ${tvGuideItemList.length}");

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ExpansionPanelList.radio(
        dividerColor: Colors.black,
        expansionCallback: (index, isExpanded) {
          print("EXPANSION INDEX ${index} EXPANSION ${isExpanded}");

          if (isExpanded) {
            closePrevPlayer();
          } else {
            playVideo(index);
          }
        },
        animationDuration: Duration(milliseconds: 1000),
        children: tvGuideItemList
            .map((e) => ExpansionPanelRadio(
                value: e,
                backgroundColor: Colors.grey,
                canTapOnHeader: true,
                headerBuilder: (context, isExpanded) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8.0, bottom: 8.0),
                    child: Container(
                      height: 60,
                      color: Colors.blueGrey,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            e.movieName!,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                body: Container(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8.0, bottom: 8.0),
                    child: _buildAdvancedPlayerScreen(),
                  ),
                )))
            .toList(),
      ),
    );
  }

  // *****************************************************************

  // ********************* Using listview with expansion tile

  Widget _buildListViewUi(BuildContext context, TvGuideState state) {
    return ListView.builder(
      key: Key(selectedTile.toString()),
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context, index) {
        return _buildCardTile(index);
        //_buildCustomContainer(context, index, state);
      },
      itemCount: tvGuideItemList.length,
    );
  }

  Widget _buildCardTile(int index) {
    return Card(
      child: ExpansionTile(
        key: Key(index.toString()),
        textColor: Colors.white,
        collapsedTextColor: Colors.black,
        initiallyExpanded: index == selectedTile,
        trailing: Text("Rating : ${tvGuideItemList[index].rating!}"),
        collapsedBackgroundColor: Colors.brown,
        backgroundColor: Colors.grey,
        onExpansionChanged: ((newState) {
          if (newState) {
            selectedTile = index;
            context.read<TvGuideBloc>().add(TvGuideExpandNextEvent());
            playVideo(index);
          } else {
            selectedTile = -1;
            context.read<TvGuideBloc>().add(TvGuideExpandNextEvent());
            closePrevPlayer();
          }

          print("##### ${newState} ${index}*********");
        }),
        title: Text(tvGuideItemList[index].movieName!),
        children: [
          Container(
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
              child: _buildAdvancedPlayerScreen(),
            ),
          )
        ],
      ),
    );
  }

  // *****************************************************************

  // ********** Video player related methods *******************

  Widget _buildAdvancedPlayerScreen() {
    return VideoPlayerFactory(
            VideoPlayerType.TV_GUIDE_VIDEO_PLAYER, videoPlayerController)
        .build(context);
  }

  void closePrevPlayer() {
    videoPlayerController.removeListener(() {});
    videoPlayerController.pause();
    videoPlayerController.dispose();
  }

  void playVideo(int index) {
    Future.delayed(const Duration(seconds: 1), () {
      videoPlayerController =
          VideoPlayerController.network(tvGuideItemList[index].video?.url ?? "")
            ..addListener(() => setState(() {}))
            ..setLooping(true)
            ..initialize().then((value) => videoPlayerController.play());
    });
  }

  // *****************************************************************

  // ********************* Using custom container and listview
  void openPlayer(int index) {
    Future.delayed(const Duration(seconds: 1), () {
      videoPlayerController =
          VideoPlayerController.network(tvGuideItemList[index].video?.url ?? "")
            ..addListener(() => setState(() {}))
            ..setLooping(true)
            ..initialize().then((value) => videoPlayerController.play());
    });
  }

  Widget _buildAdvancedPlayer(int index) {
    return VideoPlayerFactory(
            VideoPlayerType.TV_GUIDE_VIDEO_PLAYER, videoPlayerController)
        .build(context);
  }

  Widget _buildCustomContainer(
      BuildContext context, int index, TvGuideState state) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            closePrevPlayer();

            print("CLICKED INDEX ${index}");
            // expand the current tile
            tvGuideItemList[index].isExpanded =
                !tvGuideItemList[index].isExpanded;

            print("CLICKED INDEX STATUS${tvGuideItemList[index].isExpanded}");

            // close any other opened tile
            if (_selectedTilePrev != -1 && _selectedTilePrev != index) {
              print("PREV INDEX ${_selectedTilePrev}");
              print(
                  "PREV INDEX STATUS${tvGuideItemList[_selectedTilePrev].isExpanded}");

              tvGuideItemList[_selectedTilePrev].isExpanded =
                  !tvGuideItemList[_selectedTilePrev].isExpanded;
              closePrevPlayer();
            }

            if (index == _selectedTilePrev) {
              print("SAME INDEX CLICKED");
              print("SAME INDEX STATUS${tvGuideItemList[index].isExpanded}");
              closePrevPlayer();
            } else {
              openPlayer(index);
            }

            _selectedTilePrev = index;

            print("SENDING EXPAND EVENT");
            context.read<TvGuideBloc>().add(TvGuideExpandNextEvent());

            // setState(() {
            //   tvGuideItemList[index].isExpanded =
            //       !tvGuideItemList[index].isExpanded;
            //   if (_selectedTilePrev != -1 && _selectedTilePrev != index) {
            //     tvGuideItemList[_selectedTilePrev].isExpanded =
            //         !tvGuideItemList[_selectedTilePrev].isExpanded;
            //   }
            // });
            // _selectedTilePrev = index;
            //
            // openPlayer(index);
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
            child: Container(
              height: 60,
              color: Colors.brown,
              child: Align(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    tvGuideItemList[index].movieName!,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                alignment: Alignment.centerLeft,
              ),
            ),
          ),
        ),
        Visibility(
          visible: tvGuideItemList[index].isExpanded,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
            child: _buildAdvancedPlayer(index),
          ),
        )
      ],
    );
  }
}

// *****************************************************************
