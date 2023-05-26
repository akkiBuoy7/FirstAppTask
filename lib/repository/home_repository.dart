import 'dart:convert';

import 'package:first_app/model/movie_items.dart';
import 'package:first_app/provider/NetworkProvider.dart';

class HomeRepository {
  final moviesApiProvider = NetworkProvider();
  final _url =
      "https://run.mocky.io/v3/38379295-243e-42d0-b912-fbf751a54ec9";

  Future<MovieItems> fetchAllMovies() async{
    var response = await moviesApiProvider.fetchMovieList(_url);
    return MovieItems.fromJson(json.decode(response));
  }
}
