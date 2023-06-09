import 'package:first_app/ui/bottom_nav_screens/bottom_nav_detail_screens/advance_player_screen.dart';
import 'package:flutter/material.dart';

import '../../../Utility/project_util.dart';
import '../../../model/movie_items.dart';

class HomeDetailsScreen extends StatefulWidget {
  MovieDetail? model;

  HomeDetailsScreen(this.model);

  @override
  State<HomeDetailsScreen> createState() => _HomeDetailsScreenState();
}

class _HomeDetailsScreenState extends State<HomeDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    // MovieDetail? model;
    // final routeArgs1 = ModalRoute.of(context as BuildContext)
    //     ?.settings
    //     .arguments as Map<String, MovieDetail?>;
    // model = routeArgs1['data'];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text("${widget.model?.movieName}"),
      ),
      body: Scaffold(
        backgroundColor: Colors.black,
        body: CustomScrollView(slivers: [
          SliverToBoxAdapter(
            child: Container(
              height: 450,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.5), BlendMode.luminosity),
                      image: NetworkImage(widget.model?.imageUrl ?? ""))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    height: 100,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                              side: BorderSide(width:10, color: Colors.red))),
                      onPressed: () {
                        var nextPageData = {"data": widget.model?.video};

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>  AdvancePlayerScreen(
                              widget.model?.video
                          )),
                        );

                        // Navigator.pushNamed(
                        //   context,
                        //   ProjectUtil.ADVANCE_PLAYERS_SCREEN_ROUTE,
                        //   arguments: nextPageData
                        // );
                      },
                      child: Center(
                        child: Text(
                          "Watch Now",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}
