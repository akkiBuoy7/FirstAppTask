part of 'tvguide_bloc.dart';

@immutable
abstract class TvGuideState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TvGuideLoadingState extends TvGuideState {}

class TvGuideLoadedState extends TvGuideState {
  List<TvGuideDetails> tvGuideItemList;

  TvGuideLoadedState(this.tvGuideItemList);

  @override
  List<Object?> get props => [tvGuideItemList];
}

class TvGuideErrorState extends TvGuideState {
  String message;

  TvGuideErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class TvGuideExpandNextState extends TvGuideState{
  int indexNext;

  TvGuideExpandNextState(this.indexNext);

  @override
  List<Object?> get props => [indexNext];
}
