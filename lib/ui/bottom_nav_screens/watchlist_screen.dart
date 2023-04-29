import 'package:first_app/bloc/watchlist_bloc/tvguide_bloc.dart';
import 'package:first_app/model/tv_guide_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/internet_bloc/internet_bloc.dart';

class WatchlistScreen extends StatefulWidget {
  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  List<TvGuideDetails> tvGuideItemList = [];
  int selectedTile = -1;
  @override
  void initState() {
    context.read<InternetBloc>().getConnectivity();
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
                return _buildListViewUi(context,);
              } else {
                return Container();
              }
            },
          )),
    );
  }

  Widget _buildLoading() => Center(child: CircularProgressIndicator());

  Widget _buildListViewUi(
      BuildContext context,) {
    return ListView.builder(
      key: Key(selectedTile.toString()),
      itemBuilder: (context, index) {
        return _buildListContainer(index);
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
          value: Key(tvGuideItemList[indexMain].movieName.toString()),)
      ],
    );
  }
}
