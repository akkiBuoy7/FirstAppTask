import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:first_app/model/movie_items.dart';
import 'package:first_app/repository/home_repository.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

part 'home_movies_event.dart';

part 'home_movies_state.dart';

class HomeMoviesBloc extends Bloc<HomeMoviesEvent, HomeMoviesState> {
  final HomeRepository _homeRepository;
  late MovieItems movieItem;

  HomeMoviesBloc(this._homeRepository) : super(HomeMoviesInitialState()) {
    on<GetMoviesList>((event, emit) async {
      try {
        emit(HomeMoviesLoadingState());
        movieItem = await _homeRepository.fetchAllMovies();
        print("######### STATE Loaded ${movieItem.movieDetails.length}##########");
        emit(HomeMoviesLoadedState(movieItem));
      } catch (e) {
        emit(HomeMoviesErrorState("CATCHED ERROR >>>>${e.toString()}"));
      }
    });
  }
}
