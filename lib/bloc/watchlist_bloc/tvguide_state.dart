part of 'tvguide_bloc.dart';

@immutable
abstract class TvGuideState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TvGuideLoadingState extends TvGuideState {
  @override
  List<Object?> get props => [Random().nextDouble()];
}

class TvGuideLoadedState extends TvGuideState {
  List<TvGuideDetails> tvGuideItemList;
  final int now;
  TvGuideLoadedState(this.now,this.tvGuideItemList);

  @override
  List<Object?> get props => [now,tvGuideItemList];
}

class TvGuideErrorState extends TvGuideState {
  String message;

  TvGuideErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class TvGuideExpandNextState extends TvGuideState{
  // int indexNext;
  //
  // TvGuideExpandNextState(this.indexNext);

  @override
  List<Object?> get props => [identityHashCode(this)];
}


