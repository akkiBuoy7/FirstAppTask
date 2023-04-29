import 'dart:convert';

import 'package:first_app/model/movie_items.dart';
import 'package:first_app/provider/NetworkProvider.dart';

class HomeRepository {
  final moviesApiProvider = NetworkProvider();
  final _url =
      "https://dfa44662-a181-4ca4-b613-9d9754818cff.mock.pstmn.io/tvguide";

  Future<MovieItems> fetchAllMovies() async{
    var response = await moviesApiProvider.fetchMovieList(_url);
    return MovieItems.fromJson(json.decode(response));
  }
}
