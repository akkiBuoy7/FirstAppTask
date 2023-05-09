part of 'tvguide_bloc.dart';

@immutable
abstract class TvGuideEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class TvGuideLoadingEvent extends TvGuideEvent {}

class TvGuideLoadedEvent extends TvGuideEvent {
  @override
  List<Object?> get props => [];
}

class TvGuideFilteredEvent extends TvGuideEvent {
  List<TvGuideDetails> tvGuideItemList;

  TvGuideFilteredEvent(this.tvGuideItemList);

  @override
  List<Object?> get props => [tvGuideItemList];
}

class TvGuideExpandNextEvent extends TvGuideEvent {
  // int index;
  //
  // TvGuideExpandNextEvent(this.index);

  @override
  List<Object?> get props => [];
}


