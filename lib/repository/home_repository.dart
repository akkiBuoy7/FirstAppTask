import 'dart:convert';

import 'package:first_app/model/movie_items.dart';
import 'package:first_app/provider/NetworkProvider.dart';

class HomeRepository {
  final moviesApiProvider = NetworkProvider();
  final _url =
      "https://211f5a56-03b1-4286-96f0-49957cf39d53.mock.pstmn.io/movies";

  Future<MovieItems> fetchAllMovies() async{
    var response = await moviesApiProvider.fetchMovieList(_url);
    return MovieItems.fromJson(json.decode(response));
  }
}
