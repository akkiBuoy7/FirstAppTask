import 'dart:convert';

import 'package:first_app/model/movie_items.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as myService;

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<MovieDetailItems>? movieList = [];
  MovieItems? movieItems;

  var arrayColors = [
    Colors.grey,
    Colors.blue,
    Colors.black,
    Colors.red,
    Colors.green,
    Colors.lightGreen,
    Colors.yellow,
    Colors.black,
    Colors.red,
    Colors.green,
    Colors.lightGreen,
    Colors.yellow
  ];

  @override
  Widget build(BuildContext context) {
    _readJsonData();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back_ios)),
        title: Text("Home", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder(
          future: _readJsonData(),
          builder: (context, data) {
            if (data.hasError) {
              return Center(
                child: Text("${data.error}"),
              );
            } else if (data.hasData) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  primary: false,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 120,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12),
                  itemBuilder: (context, index) {
                    return Stack(children: [
                      Container(
                        color: Colors.black,
                        child: Image.network(
                          movieList?[index].imageUrl ?? "",
                          fit: BoxFit.fill,
                        ),
                        width: double.infinity,
                        height: double.infinity,
                      ),
                      Positioned(
                        bottom: 30,
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: SizedBox.square(
                            dimension: 10,
                            child: IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.play_circle),
                            color: Colors.orange,),
                          ),
                        ),
                      )
                    ]);
                  },
                  itemCount: movieList?.length,
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator(color: Colors.orange,));
            }
          }),
    );
  }

  Future<List<MovieDetailItems>?> _readJsonData() async {
    final jsonData =
        await myService.rootBundle.loadString('assets/json/movies.json');

    movieItems = MovieItems.fromJson(jsonDecode(jsonData));
    print("*****************data response${movieItems?.movieDetails.length}");
    movieList = movieItems?.movieDetails;
    return movieList;
  }
}
