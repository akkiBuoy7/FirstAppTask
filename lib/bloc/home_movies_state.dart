part of 'home_movies_bloc.dart';

@immutable
abstract class HomeMoviesState extends Equatable{
  @override
  List<Object?> get props => [];
}

class HomeMoviesInitialState extends HomeMoviesState {}

class HomeMoviesLoadingState extends HomeMoviesState {}

class HomeMoviesLoadedState extends HomeMoviesState {

  MovieItems movieItems;

  @override
  List<Object> get props => [movieItems];

  HomeMoviesLoadedState(this.movieItems);
}

class HomeMoviesErrorState extends HomeMoviesState {

  final String message;

  HomeMoviesErrorState(this.message);

  @override
  List<Object> get props => [message];
}