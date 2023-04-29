part of 'tvguide_bloc.dart';

@immutable
abstract class TvGuideEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class TvGuideLoadingEvent extends TvGuideEvent {}

class TvGuideLoadedEvent extends TvGuideEvent {}
