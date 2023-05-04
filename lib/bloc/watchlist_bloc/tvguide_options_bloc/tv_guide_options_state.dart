part of 'tv_guide_options_bloc.dart';

@immutable
abstract class TvGuideOptionsState {}

class TvGuideOptionsInitial extends TvGuideOptionsState {}

class TvGuideShowSearchState extends TvGuideOptionsState {

  bool showSearchBar=false;

  TvGuideShowSearchState(this.showSearchBar);

  @override
  List<Object?> get props => [showSearchBar];

}