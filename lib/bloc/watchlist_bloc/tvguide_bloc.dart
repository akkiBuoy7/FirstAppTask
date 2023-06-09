import 'dart:async';
import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../model/tv_guide_item.dart';
import '../../repository/tv_guide_repository.dart';

part 'tvguide_event.dart';

part 'tvguide_state.dart';

class TvGuideBloc extends Bloc<TvGuideEvent, TvGuideState> {
  TvGuideRepository tvGuideRepository;
  late List<TvGuideDetails> tvGuideItemList;

  TvGuideBloc(this.tvGuideRepository) : super(TvGuideLoadingState()) {
    on<TvGuideLoadedEvent>((event, emit) async {
      getTvGuideApiData(event, state);
    });
    on<TvGuideExpandNextEvent>((event, emit) async {
      emit(TvGuideExpandNextState());
    });

    on<TvGuideFilteredEvent>((event, emit) =>
        emit(TvGuideLoadedState( DateTime.now().millisecondsSinceEpoch,event.tvGuideItemList)));
  }

  getTvGuideApiData(TvGuideEvent event, TvGuideState state) async{
    try {
      emit(TvGuideLoadingState());
      tvGuideItemList = await tvGuideRepository.fetchApiData();
      print("################## TV GUIDE RESPONSE ${tvGuideItemList.length}");
      emit(TvGuideLoadedState( DateTime.now().millisecondsSinceEpoch,tvGuideItemList));
    } catch (e) {
      emit(TvGuideErrorState(e.toString()));
    }
  }
}
