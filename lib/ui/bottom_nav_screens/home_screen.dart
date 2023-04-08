import 'dart:convert';

import 'package:first_app/Utility/ProjectUtil.dart';
import 'package:first_app/bloc/home_movies_bloc.dart';
import 'package:first_app/model/movie_items.dart';
import 'package:first_app/provider/NetworkProvider.dart';
import 'package:first_app/repository/home_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as myService;
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<MovieDetail>? movieList = [];
  final HomeMoviesBloc _moviesBloc = HomeMoviesBloc();

  @override
  void initState() {
    _moviesBloc.add(GetMoviesList());
    print("########### Event Added ############");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //_readJsonData();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back_ios)),
        title: Text("Home", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: Container(
        child: BlocProvider(
              create: (_) => _moviesBloc,
              child: BlocListener<HomeMoviesBloc,HomeMoviesState>(
                listener: (context, state) {
                  if (state is HomeMoviesErrorState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message!),
                      ),
                    );
                  } else if (state is HomeMoviesLoadedState) {
                    print("######### LISTENER LOADED STATE ##########");
                  }
                },
                child: BlocBuilder<HomeMoviesBloc, HomeMoviesState>(
                  builder: (context, state) {
                    if (state is HomeMoviesInitialState) {
                      print("######### INITIAL STATE ##########");
                      return Container();
                    } else if (state is HomeMoviesLoadingState) {
                      print("######### LOADING STATE ##########");
                      return _buildLoading();
                    } else if (state is HomeMoviesLoadedState) {
                      print("######### LOADED STATE ##########");
                      return buildGridViewUi(context, state.movieItems);
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
    ),
      ));
  }

  BlocConsumer usingBlocConsumer() {
    return BlocConsumer<HomeMoviesBloc, HomeMoviesState>(
      listener: (context, state) {
        if (state is HomeMoviesErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message!),
            ),
          );
        } else if (state is HomeMoviesLoadedState) {
          print("######### LISTENER LOADED STATE ##########");
        }
      },
      builder: (context, state) {
        if (state is HomeMoviesInitialState) {
          print("######### INITIAL STATE ##########");
          return _buildLoading();
        } else if (state is HomeMoviesLoadingState) {
          print("######### LOADING STATE ##########");
          return _buildLoading();
        } else if (state is HomeMoviesLoadedState) {
          print("######### LOADED STATE ##########");
          return buildGridViewUi(context, state.movieItems);
        } else {
          return Container();
        }
      },
    );
  }

  Widget buildGridViewUi(BuildContext context, MovieItems dataModel) {
    return GridView.builder(
      shrinkWrap: true,
      primary: false,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: 120,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12),
      itemBuilder: (context, index) {
        return Stack(children: [
          InkWell(
            onTap: () {
              var nextPageData = {"data": dataModel.movieDetails[index]};
              Navigator.pushNamed(
                  context, ProjectUtil.HOME_DETAILS_SCREEN_ROUTE,
                  arguments: nextPageData);
            },
            child: Container(
              color: Colors.black,
              child: Image.network(
                dataModel.movieDetails[index].imageUrl ?? "",
                fit: BoxFit.fill,
              ),
              width: double.infinity,
              height: double.infinity,
            ),
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
                  color: Colors.orange,
                ),
              ),
            ),
          )
        ]);
      },
      itemCount: dataModel.movieDetails.length,
    );
  }

  Widget _buildLoading() => Center(child: CircularProgressIndicator());

  FutureBuilder usingFuture() {
    return FutureBuilder(
        future: _fetchApi(),
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
                    InkWell(
                      onTap: () {
                        var nextPageData = {"data": movieList?[index]};
                        Navigator.pushNamed(
                            context, ProjectUtil.HOME_DETAILS_SCREEN_ROUTE,
                            arguments: nextPageData);
                      },
                      child: Container(
                        color: Colors.black,
                        child: Image.network(
                          movieList?[index].imageUrl ?? "",
                          fit: BoxFit.fill,
                        ),
                        width: double.infinity,
                        height: double.infinity,
                      ),
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
                            color: Colors.orange,
                          ),
                        ),
                      ),
                    )
                  ]);
                },
                itemCount: movieList?.length,
              ),
            );
          } else {
            return Center(
                child: CircularProgressIndicator(
              color: Colors.orange,
            ));
          }
        });
  }

  Future<List<MovieDetail>?> _fetchApi() async {
    final movieResponse = await HomeRepository().fetchAllMovies();
    print("*****************data response${movieResponse.movieDetails.length}");
    movieList = movieResponse.movieDetails;
    return movieList;
  }

// Future<List<MovieDetail>?> _readJsonData() async {
//   final jsonData =
//       await myService.rootBundle.loadString('assets/json/movies.json');
//
//   movieItems = MovieItems.fromJson(jsonDecode(jsonData));
//   print("*****************data response${movieItems?.movieDetails.length}");
//   movieList = movieItems?.movieDetails;
//   return movieList;
// }
}
