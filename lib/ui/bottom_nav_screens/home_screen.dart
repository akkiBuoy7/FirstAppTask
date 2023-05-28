import 'dart:async';
import 'package:http/http.dart' show Client;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:first_app/Utility/project_util.dart';
import 'package:first_app/bloc/home_movies_bloc.dart';
import 'package:first_app/bloc/internet_bloc/internet_bloc.dart';
import 'package:first_app/model/movie_items.dart';
import 'package:first_app/repository/home_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<MovieDetail>? movieList = [];
  StreamSubscription? _connectivityStreamSubscription;
  late bool isConnected;

  //final HomeMoviesBloc _moviesBloc = HomeMoviesBloc();

  observeNetwork() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      context.read<InternetBloc>().add(InternetLostEvent());
      print("######## INTERNET LOST EVENT FIRED");
    } else if (connectivityResult == ConnectivityResult.mobile) {
      context.read<InternetBloc>().add(InternetConnectedEvent());
      print("######## INTERNET CONNECTED EVENT FIRED");
    } else if (connectivityResult == ConnectivityResult.wifi) {
      context.read<InternetBloc>().add(InternetConnectedEvent());
      print("######## INTERNET CONNECTED EVENT FIRED");
    }
  }

  @override
  void initState() {
    //_moviesBloc.add(GetMoviesList());
    //context.read<HomeMoviesBloc>().add(GetMoviesList());

    context.read<InternetBloc>().getConnectivity();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //_readJsonData();

    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          centerTitle: true,
          leading:
              IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back_ios)),
          title: Text("Home", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.black,
        ),
        body: _usingMultiBlocListener());
  }

  Widget _usingProvider() {
    return Container(
      child: BlocProvider(
        create: (_) => context.read<HomeMoviesBloc>(),
        child: BlocListener<HomeMoviesBloc, HomeMoviesState>(
          listener: (context, state) {
            if (state is HomeMoviesErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message!),
                ),
              );
            } else if (state is HomeMoviesLoadedState) {
            }
          },
          child: BlocBuilder<HomeMoviesBloc, HomeMoviesState>(
            builder: (context, state) {
              if (state is HomeMoviesInitialState) {
                return Container();
              } else if (state is HomeMoviesLoadingState) {
                return _buildLoading();
              } else if (state is HomeMoviesLoadedState) {
                return buildGridViewUi(context, state.movieItems);
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _usingMultiBlocListener() {
    return Container(
      child: MultiBlocListener(
          listeners: [
            BlocListener<InternetBloc, InternetState>(
              listener: (context, state) {
                if (state is InternetConnectedState) {
                  context.read<HomeMoviesBloc>().add(GetMoviesList());
                } else if (state is InternetLostState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("No internet"),
                    ),
                  );
                }
              },
            ),
            BlocListener<HomeMoviesBloc, HomeMoviesState>(
                listener: (context, state) {
              if (state is HomeMoviesErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                  ),
                );
              }
            })
          ],
          child: BlocBuilder<HomeMoviesBloc, HomeMoviesState>(
            builder: (context, state) {
              if (state is HomeMoviesInitialState) {
                return Container();
              } else if (state is HomeMoviesLoadingState) {
                return _buildLoading();
              } else if (state is HomeMoviesLoadedState) {
                return buildGridViewUi(context, state.movieItems);
              } else {
                return Container();
              }
            },
          )),
    );
  }

  Widget usingBlocConsumer() {
    return Container(
      child: BlocConsumer<HomeMoviesBloc, HomeMoviesState>(
        listener: (context, state) {
          if (state is HomeMoviesErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is HomeMoviesInitialState) {
            return _buildLoading();
          } else if (state is HomeMoviesLoadingState) {
            return _buildLoading();
          } else if (state is HomeMoviesLoadedState) {
            return buildGridViewUi(context, state.movieItems);
          } else {
            return Container();
          }
        },
      ),
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
              // var nextPageData = {"data": dataModel.movieDetails[index]};
              // Navigator.pushNamed(
              //     context, ProjectUtil.HOME_DETAILS_SCREEN_ROUTE,
              //     arguments: nextPageData);

              Navigator.pushNamed(
                  context, ProjectUtil.HOME_DETAILS_SCREEN_ROUTE,
                  arguments: dataModel.movieDetails[index]);
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
