import 'package:flutter/material.dart';

import 'bottom_nav_detail_screens/tv_guide_screen.dart';
import 'favorites_screen.dart';

class WatchlistScreen extends StatefulWidget  {
  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> with AutomaticKeepAliveClientMixin<WatchlistScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("Watch List", style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.black,
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: "Watch Tv",
                ),
                Tab(text: "Tv Guide & Replay"),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              FavoritesScreen(),
              TvGuideScreen(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
