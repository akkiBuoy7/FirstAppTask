import 'package:first_app/model/movie_items.dart';
import 'package:first_app/provider/NetworkProvider.dart';

class HomeRepository {
  final moviesApiProvider = NetworkProvider();

  Future<MovieItems> fetchAllMovies() => moviesApiProvider.fetchMovieList();
}