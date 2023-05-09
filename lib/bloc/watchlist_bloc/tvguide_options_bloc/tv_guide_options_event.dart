part of 'tv_guide_options_bloc.dart';

@immutable
abstract class TvGuideOptionsEvent {}

class TvGuideShowSearchEvent extends TvGuideOptionsEvent {
  bool showSearchBar = false;

  TvGuideShowSearchEvent(this.showSearchBar);

  @override
  List<Object?> get props => [showSearchBar];
}

class TvGuideSelectItemEvent extends TvGuideOptionsEvent {
  String value;

  TvGuideSelectItemEvent(this.value);

  @override
  List<Object?> get props => [value];
}
