part of 'home_movies_bloc.dart';

@immutable
abstract class HomeMoviesEvent  extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetMoviesList extends HomeMoviesEvent{


}
