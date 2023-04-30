part of 'tvguide_bloc.dart';

@immutable
abstract class TvGuideEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class TvGuideLoadingEvent extends TvGuideEvent {}

class TvGuideLoadedEvent extends TvGuideEvent {}

class TvGuideExpandNextEvent extends TvGuideEvent {
  int index;

  TvGuideExpandNextEvent(this.index);

  @override
  List<Object?> get props => [index];
}
